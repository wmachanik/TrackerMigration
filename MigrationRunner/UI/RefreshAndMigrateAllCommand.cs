using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;

namespace MigrationRunner.UI
{
    /// <summary>
    /// Full refresh: drop all tables, stage Access → AccessSrc, apply fixed DDL,
    /// run hand-tuned Migrate_*.sql scripts, then Orders/Recurring normalization.
    /// </summary>
    internal sealed class RefreshAndMigrateAllCommand : IMenuCommand
    {
        private readonly string _migrationsDir;
        private readonly MigrationConfig _config;
        private readonly List<IMenuCommand> _allCommands;

        public RefreshAndMigrateAllCommand(string migrationsDir, MigrationConfig config, List<IMenuCommand> allCommands)
        {
            _migrationsDir = migrationsDir;
            _config = config;
            _allCommands = allCommands ?? new List<IMenuCommand>();
        }

        public string Key => "99";
        public string Description => "* Refresh and migrate all (drop → MS → DDL → $ → FKs → !) [recommended]";

        public int Execute()
        {
            Console.WriteLine("=== REFRESH AND MIGRATE ALL ===");
            Console.WriteLine("This pipeline will:");
            Console.WriteLine("  1. Drop ALL user tables (dbo + AccessSrc — clean slate)");
            Console.WriteLine("  2. Stage fresh Access data into [AccessSrc] (MS)");
            Console.WriteLine("  3. Apply CreateTables_LATEST_FIXED.sql only (no FKs yet)");
            Console.WriteLine("  4. Run all hand-tuned Migrate_*.sql scripts (FK dependency order)");
            Console.WriteLine("  5. Apply FK constraint scripts");
            Console.WriteLine("  6. Migrate Orders + Recurring normalised tables (!)");
            Console.WriteLine();
            Console.WriteLine("NOTE: Does NOT regenerate SQL from CSV (steps A, B, M, N are skipped).");
            Console.WriteLine();

            var accessCs = _config?.AccessConnectionString ?? "";
            var sqlCs = _config?.TargetConnectionString ?? "";

            Console.WriteLine($"Access connection [{ShortConn(accessCs)}]:");
            Console.Write("Press Enter to keep, or enter a new Access connection string: ");
            var accessInput = (Console.ReadLine() ?? "").Trim();
            if (!string.IsNullOrEmpty(accessInput))
            {
                accessCs = accessInput;
                _config.AccessConnectionString = accessCs;
            }

            Console.WriteLine($"SQL connection [{ShortConn(sqlCs)}]:");
            Console.Write("Press Enter to keep, or enter a new SQL connection string: ");
            var sqlInput = (Console.ReadLine() ?? "").Trim();
            if (!string.IsNullOrEmpty(sqlInput))
            {
                sqlCs = sqlInput;
                _config.TargetConnectionString = sqlCs;
            }

            if (string.IsNullOrWhiteSpace(accessCs) || string.IsNullOrWhiteSpace(sqlCs))
            {
                Console.WriteLine("Both Access and SQL connection strings are required.");
                return 2;
            }

            if (!TestConnection(accessCs, true, out var accessErr))
            {
                Console.WriteLine("Access connection failed: " + accessErr);
                return 1;
            }

            if (!TestConnection(sqlCs, false, out var sqlErr))
            {
                Console.WriteLine("SQL connection failed: " + sqlErr);
                return 1;
            }

            var fixedCreate = Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Sql", "CreateTables_LATEST_FIXED.sql");
            if (!File.Exists(fixedCreate))
            {
                Console.WriteLine("WARNING: CreateTables_LATEST_FIXED.sql not found; step C will fall back to latest generated create script.");
            }

            var migrateScripts = Directory.GetFiles(
                Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Sql"),
                "Migrate_*.sql",
                SearchOption.TopDirectoryOnly);
            if (migrateScripts.Length == 0)
            {
                Console.WriteLine("ERROR: No Migrate_*.sql scripts found. Add hand-tuned scripts before running option 99.");
                return 1;
            }

            Console.WriteLine($"Found {migrateScripts.Length} Migrate_*.sql script(s).");
            Console.WriteLine();
            Console.Write("Proceed with refresh and migrate all? [Y/n]: ");
            var confirm = (Console.ReadLine() ?? "").Trim();
            if (!string.IsNullOrWhiteSpace(confirm) &&
                !confirm.StartsWith("y", StringComparison.OrdinalIgnoreCase))
            {
                Console.WriteLine("Cancelled.");
                return 0;
            }

            RunRangeState.Current = new RunRangeOptions
            {
                SuppressPrompts = true,
                SkipSqlScriptGeneration = true,
                ContinueOnTableMigrationErrors = false,
                TargetConnectionString = sqlCs,
                AccessConnectionString = accessCs
            };

            var pipelineHadErrors = false;
            var lastErrorCode = 0;
            var stepResults = new List<PipelineStepResult>();
            var pipelineStepNames = new[]
            {
                "1. Drop all user tables",
                "2. Stage Access → AccessSrc",
                "3. Apply CREATE TABLE DDL",
                "4. Table-by-table migration",
                "5. Apply FK constraints",
                "6. Orders + Recurring normalisation"
            };

            try
            {
                // 1) Drop everything (dbo + AccessSrc) for a clean slate
                Console.WriteLine("\n=== STEP 1/6: Drop all user tables ===");
                try
                {
                    TargetDatabaseHelper.DropAllUserTables(sqlCs);
                    Console.WriteLine("All user tables dropped (dbo and AccessSrc).");
                    RecordStep(stepResults, pipelineStepNames[0], true, 0);
                }
                catch (Exception ex)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = 1;
                    RecordStep(stepResults, pipelineStepNames[0], false, 1, ex.Message);
                    if (!PromptContinuePipeline("Step 1 — Drop all user tables", ex.Message, 1))
                    {
                        MarkStepsSkipped(stepResults, pipelineStepNames, 1);
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return 1;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }

                // 2) MS — stage fresh Access → AccessSrc
                Console.WriteLine("\n=== STEP 2/6: Stage Access → AccessSrc (MS) ===");
                var msRc = InvokeCommand("MS");
                if (msRc != 0)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = msRc;
                    RecordStep(stepResults, pipelineStepNames[1], false, msRc, "See Metadata/PlanEdits/Logs/StageAccess_*.log");
                    if (!PromptContinuePipeline("Step 2 — Stage Access to AccessSrc", "Access staging reported issues. Check Metadata/PlanEdits/Logs/StageAccess_*.log", msRc))
                    {
                        MarkStepsSkipped(stepResults, pipelineStepNames, 2);
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return msRc;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }
                else
                {
                    RecordStep(stepResults, pipelineStepNames[1], true, 0);
                }

                // 3) Create tables only (FKs applied after data load)
                Console.WriteLine("\n=== STEP 3/6: Apply CREATE TABLE DDL (no FKs) ===");
                string createLogPath;
                var ddlRc = DdlScriptApplier.ApplyLatest(
                    _migrationsDir,
                    sqlCs,
                    out createLogPath,
                    DdlApplyScope.CreateTablesOnly);
                Console.WriteLine("Create tables rc=" + ddlRc + " log: " + createLogPath);
                if (ddlRc != 0)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = ddlRc;
                    RecordStep(stepResults, pipelineStepNames[2], false, ddlRc, createLogPath);
                    if (!PromptContinuePipeline("Step 3 — Apply CREATE TABLE DDL", "See log: " + createLogPath, ddlRc))
                    {
                        MarkStepsSkipped(stepResults, pipelineStepNames, 3);
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return ddlRc;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }
                else
                {
                    RecordStep(stepResults, pipelineStepNames[2], true, 0, createLogPath);
                }

                // 4) Table-by-table Migrate_*.sql in FK dependency order
                Console.WriteLine("\n=== STEP 4/6: Table-by-table migration (Migrate_*.sql) ===");
                EnsureSafeDateConvert(sqlCs);
                var tableNames = migrateScripts
                    .Select(f => Path.GetFileNameWithoutExtension(f).Substring("Migrate_".Length))
                    .ToList();
                var tables = MigrationTableOrderer.OrderByForeignKeyDependencies(_migrationsDir, tableNames);
                Console.WriteLine("Migration order (parents before children): " + string.Join(" → ", tables));
                var logPath = Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Logs", "TableByTableMigration.log");
                var migrateRc = TableByTableMigrationRunner.Run(_migrationsDir, sqlCs, tables, logPath);
                if (migrateRc != 0)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = migrateRc;
                    RecordStep(stepResults, pipelineStepNames[3], false, migrateRc, logPath);
                    if (!PromptContinuePipeline("Step 4 — Table-by-table migration", "One or more tables failed. See log: " + logPath, migrateRc))
                    {
                        MarkStepsSkipped(stepResults, pipelineStepNames, 4);
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return migrateRc;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }
                else
                {
                    RecordStep(stepResults, pipelineStepNames[3], true, 0, logPath);
                }

                // 5) Apply FK constraints after data is loaded
                Console.WriteLine("\n=== STEP 5/6: Apply FK constraints ===");
                string fkLogPath;
                var fkRc = DdlScriptApplier.ApplyLatest(
                    _migrationsDir,
                    sqlCs,
                    out fkLogPath,
                    DdlApplyScope.ForeignKeysOnly);
                Console.WriteLine("FK apply rc=" + fkRc + " log: " + fkLogPath);
                if (fkRc != 0)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = fkRc;
                    RecordStep(stepResults, pipelineStepNames[4], false, fkRc, fkLogPath);
                    if (!PromptContinuePipeline("Step 5 — Apply FK constraints", "See log: " + fkLogPath, fkRc))
                    {
                        MarkStepsSkipped(stepResults, pipelineStepNames, 5);
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return fkRc;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }
                else
                {
                    RecordStep(stepResults, pipelineStepNames[4], true, 0, fkLogPath);
                }

                // 6) ! — Orders + Recurring
                Console.WriteLine("\n=== STEP 6/6: Normalised migration — Orders + Recurring (!) ===");
                var normRc = InvokeCommand("!");
                if (normRc != 0)
                {
                    pipelineHadErrors = true;
                    lastErrorCode = normRc;
                    RecordStep(stepResults, pipelineStepNames[5], false, normRc, "See Metadata/PlanEdits/Logs/CustomNormalize_*.log");
                    if (!PromptContinuePipeline("Step 6 — Orders + Recurring normalisation", "Custom normalise migration reported issues.", normRc))
                    {
                        PrintPipelineSummary(stepResults, stoppedEarly: true);
                        Console.WriteLine("Pipeline stopped by user.");
                        return normRc;
                    }
                    stepResults[stepResults.Count - 1].Status = "FAILED (continued)";
                }
                else
                {
                    RecordStep(stepResults, pipelineStepNames[5], true, 0);
                }

                PrintPipelineSummary(stepResults, stoppedEarly: false);

                if (pipelineHadErrors)
                {
                    Console.WriteLine("Review logs under Metadata/PlanEdits/Logs, fix issues, then re-run affected step(s) or option 99.");
                    return lastErrorCode != 0 ? lastErrorCode : 1;
                }

                return 0;
            }
            finally
            {
                RunRangeState.Current = null;
            }
        }

        private sealed class PipelineStepResult
        {
            public string Name { get; set; }
            public string Status { get; set; }
            public int ReturnCode { get; set; }
            public string Detail { get; set; }
        }

        private static void RecordStep(List<PipelineStepResult> results, string name, bool success, int returnCode, string detail = null)
        {
            results.Add(new PipelineStepResult
            {
                Name = name,
                Status = success ? "OK" : "FAILED",
                ReturnCode = returnCode,
                Detail = detail
            });
        }

        private static void MarkStepsSkipped(List<PipelineStepResult> results, string[] allStepNames, int fromIndex)
        {
            var recorded = new HashSet<string>(results.Select(r => r.Name), StringComparer.OrdinalIgnoreCase);
            for (int i = fromIndex; i < allStepNames.Length; i++)
            {
                if (recorded.Contains(allStepNames[i]))
                    continue;
                results.Add(new PipelineStepResult
                {
                    Name = allStepNames[i],
                    Status = "SKIPPED",
                    ReturnCode = -1,
                    Detail = "Not run — pipeline stopped earlier"
                });
            }
        }

        private static void PrintPipelineSummary(List<PipelineStepResult> steps, bool stoppedEarly)
        {
            var ok = steps.Count(s => s.Status == "OK");
            var failed = steps.Count(s => s.Status == "FAILED" || s.Status == "FAILED (continued)");
            var skipped = steps.Count(s => s.Status == "SKIPPED");

            Console.WriteLine();
            Console.WriteLine("========== PIPELINE SUMMARY ==========");
            if (stoppedEarly)
                Console.WriteLine("Run ended early (stopped by user after a failure).");
            else if (failed == 0)
                Console.WriteLine("All pipeline steps completed successfully.");
            else
                Console.WriteLine("Pipeline completed with one or more step failures.");

            Console.WriteLine($"Steps: {ok} succeeded, {failed} failed, {skipped} skipped (of {steps.Count} recorded)");
            Console.WriteLine();

            foreach (var step in steps)
            {
                var marker = step.Status == "OK" ? "+" :
                    step.Status == "SKIPPED" ? "-" :
                    step.Status == "FAILED (continued)" ? "!" : "X";
                Console.WriteLine($"  [{marker}] {step.Name}: {step.Status} (rc={step.ReturnCode})");
                if (!string.IsNullOrWhiteSpace(step.Detail))
                    Console.WriteLine($"       {step.Detail}");
            }

            Console.WriteLine("======================================");
            if (failed > 0 || stoppedEarly)
                Console.WriteLine("RESULT: FINISHED WITH ERRORS");
            else
                Console.WriteLine("RESULT: SUCCESS");
            Console.WriteLine();
        }

        private static bool PromptContinuePipeline(string stepLabel, string reason, int returnCode)
        {
            Console.WriteLine();
            Console.WriteLine("*** STEP FAILED: " + stepLabel + " ***");
            if (!string.IsNullOrWhiteSpace(reason))
                Console.WriteLine(reason);
            if (returnCode != 0)
                Console.WriteLine("Return code: " + returnCode);
            Console.Write("Continue with the next pipeline step anyway? [y/N]: ");
            var response = (Console.ReadLine() ?? "").Trim();
            return response.StartsWith("y", StringComparison.OrdinalIgnoreCase);
        }

        private int InvokeCommand(string key)
        {
            var command = _allCommands.FirstOrDefault(c =>
                string.Equals(c.Key, key, StringComparison.OrdinalIgnoreCase));
            if (command == null)
            {
                Console.WriteLine($"ERROR: Menu command '{key}' not found.");
                return 1;
            }

            Console.WriteLine($"Executing: {command.Description}");
            return command.Execute();
        }

        private static void EnsureSafeDateConvert(string sqlCs)
        {
            try
            {
                using (var conn = new SqlConnection(sqlCs))
                {
                    conn.Open();
                    using (var checkCmd = conn.CreateCommand())
                    {
                        checkCmd.CommandText = "SELECT OBJECT_ID('dbo.SafeDateConvert', 'FN')";
                        var exists = checkCmd.ExecuteScalar();
                        if (exists != null && exists != DBNull.Value)
                        {
                            return;
                        }
                    }

                    Console.WriteLine("Creating dbo.SafeDateConvert function...");
                    using (var createCmd = conn.CreateCommand())
                    {
                        createCmd.CommandText = @"
CREATE FUNCTION dbo.SafeDateConvert(@input NVARCHAR(255))
RETURNS DATETIME
AS
BEGIN
    RETURN TRY_CONVERT(DATETIME, @input, 120);
END";
                        createCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Warning: Could not ensure SafeDateConvert exists: " + ex.Message);
            }
        }

        private static bool TestConnection(string connectionString, bool isAccess, out string error)
        {
            error = null;
            try
            {
                if (isAccess)
                {
                    using (var conn = new System.Data.OleDb.OleDbConnection(connectionString))
                    {
                        conn.Open();
                    }
                }
                else
                {
                    using (var conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                error = ex.Message;
                return false;
            }
        }

        private static string ShortConn(string cs)
        {
            if (string.IsNullOrWhiteSpace(cs)) return "(empty)";
            return cs.Length > 80 ? cs.Substring(0, 77) + "..." : cs;
        }
    }
}
