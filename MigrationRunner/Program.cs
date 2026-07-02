using System;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using MigrationRunner.UI;

namespace MigrationRunner
{
    internal static class Program
    {
        private static int Main(string[] args)
        {
            try
            {
                // Check for command-line option first
                var directOption = ParseCommandLineOption(args);
                if (!string.IsNullOrEmpty(directOption))
                {
                    return RunDirectOption(directOption, args);
                }

                Console.WriteLine("== Migration Runner (menu v2: options 1..12, A..D, M/MS/N/!, O, R, X, &, Z, $, *99) ==");
                var baseDir = AppDomain.CurrentDomain.BaseDirectory.TrimEnd('\\');

                var configPath = ConfigService.ResolveConfigPath(baseDir, args);
                if (string.IsNullOrEmpty(configPath) || !File.Exists(configPath))
                {
                    Console.Error.WriteLine("Missing MigrationConfig.json. Place it next to the exe, in a parent folder, or pass --config <fullPath>.");
                    return 2;
                }

                var migrationsDir = PathService.ResolveWritableRoot(baseDir);
                if (string.IsNullOrWhiteSpace(migrationsDir))
                {
                    Console.Error.WriteLine("Could not find a writable working folder for Metadata output.");
                    return 2;
                }
                Console.WriteLine("Working folder: " + migrationsDir);

                MetadataService.BootstrapMetadata(migrationsDir, baseDir);

                var configJson = File.ReadAllText(configPath);
                var config = JsonConvert.DeserializeObject<MigrationConfig>(configJson);
                if (config == null)
                    throw new InvalidOperationException("Invalid config JSON at: " + configPath);

                var commands = new List<MigrationRunner.UI.IMenuCommand>
                {
                    new MigrationRunner.UI.GeneratePerTableMigrationScriptsCommand(migrationsDir),
                    new MigrationRunner.UI.ExportAccessSchemaCommand(migrationsDir, config),
                    new MigrationRunner.UI.ReviewEditPlanCommand(migrationsDir),
                    new MigrationRunner.UI.ExportPlanSummaryCsvCommand(migrationsDir),
                    new MigrationRunner.UI.ExportPlanCsvInteractiveCommand(migrationsDir),
                    new MigrationRunner.UI.ImportPlanCsvInteractiveCommand(migrationsDir),
                    new MigrationRunner.UI.BulkRenameDryRunCommand(migrationsDir),
                    new MigrationRunner.UI.BulkRenameApplyCommand(migrationsDir),
                    new MigrationRunner.UI.FullPlanReviewCommand(migrationsDir),
                    new MigrationRunner.UI.BeforeAfterCsvCommand(migrationsDir),
                    new MigrationRunner.UI.HumanReviewCsvCommand(migrationsDir),
                    new MigrationRunner.UI.HumanReviewCsvImportCommand(migrationsDir),
                    new MigrationRunner.UI.PreflightValidateCommand(migrationsDir),
                    new MigrationRunner.UI.TableByTableMigrationCommand(migrationsDir, config),
                    new MigrationRunner.UI.GenerateCreateTablesScriptCommand(migrationsDir),
                    new MigrationRunner.UI.GenerateForeignKeysScriptCommand(migrationsDir),
                    new MigrationRunner.UI.GenerateDataMigrationScriptCommand(migrationsDir),
                    new MigrationRunner.UI.StageAccessToSqlCommand(migrationsDir, config),
                    new MigrationRunner.UI.ApplyDataMigrationScriptCommand(migrationsDir, config),
                    new MigrationRunner.UI.ApplyUnnormalizedDataMigrationCommand(migrationsDir, config),
                    new MigrationRunner.UI.CustomNormalizeCommand(migrationsDir, config),
                    new MigrationRunner.UI.ApplyDdlScriptsCommand(migrationsDir, config),
                    new MigrationRunner.UI.OpenSqlFolderCommand(migrationsDir),
                    new MigrationRunner.UI.PostMigrationVerificationCommand(migrationsDir, config),
                    new MigrationRunner.UI.CleanupTablesCommand(migrationsDir, config),
                    new MigrationRunner.UI.DropAllTablesCommand(migrationsDir, config),
                    new MigrationRunner.UI.ExitCommand(),
                };

                commands.Add(new MigrationRunner.UI.RefreshAndMigrateAllCommand(migrationsDir, config, commands));
                commands.Add(new MigrationRunner.UI.RunRangeCommand(commands, config));

                var menu = new MenuController("Select an option:", commands);
                try
                {
                    Console.WriteLine("-- Registered menu commands (debug):");
                    foreach (var c in commands)
                    {
                        Console.WriteLine($"  [{c.Key}] {c.Description}");
                    }
                }
                catch { }
                return menu.RunLoop();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("ERROR: " + ex);
                return 1;
            }
        }

        private static string ParseCommandLineOption(string[] args)
        {
            if (args == null || args.Length == 0) return null;

            for (int i = 0; i < args.Length; i++)
            {
                var arg = args[i];
                if (arg.Equals("--option", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                {
                    return args[i + 1];
                }
                else if (arg.StartsWith("--option=", StringComparison.OrdinalIgnoreCase))
                {
                    return arg.Substring("--option=".Length).Trim();
                }
            }

            if (args.Length > 0 && !args[0].StartsWith("--"))
            {
                return args[0];
            }

            return null;
        }

        private static int RunDirectOption(string option, string[] args)
        {
            Console.WriteLine($"== Migration Runner - Running Option {option} ==");
            var baseDir = AppDomain.CurrentDomain.BaseDirectory.TrimEnd('\\');

            var configPath = ConfigService.ResolveConfigPath(baseDir, args);
            if (string.IsNullOrEmpty(configPath) || !File.Exists(configPath))
            {
                Console.Error.WriteLine("Missing MigrationConfig.json. Place it next to the exe, in a parent folder, or pass --config <fullPath>.");
                return 2;
            }

            var migrationsDir = PathService.ResolveWritableRoot(baseDir);
            if (string.IsNullOrWhiteSpace(migrationsDir))
            {
                Console.Error.WriteLine("Could not find a writable working folder for Metadata output.");
                return 2;
            }
            Console.WriteLine("Working folder: " + migrationsDir);

            MetadataService.BootstrapMetadata(migrationsDir, baseDir);

            var configJson = File.ReadAllText(configPath);
            var config = JsonConvert.DeserializeObject<MigrationConfig>(configJson);
            if (config == null)
                throw new InvalidOperationException("Invalid config JSON at: " + configPath);

            try
            {
                switch (option.ToUpper())
                {
                    case "11":
                        return RunOption11(migrationsDir, args);
                    case "12":
                        return RunOption12(migrationsDir, config);
                    case "&":
                        return RunOptionVerification(migrationsDir, config);
                    case "A":
                        return RunOptionA(migrationsDir);
                    case "M":
                        return RunOptionM(migrationsDir);
                    case "N":
                        return RunOptionN(migrationsDir, config);
                    default:
                        Console.Error.WriteLine($"Direct option '{option}' not supported via command line yet.");
                        Console.Error.WriteLine("Supported options: 11, 12, &, A, M, N");
                        return 1;
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error running option {option}: {ex.Message}");
                return 1;
            }
        }

        private static int RunOption11(string migrationsDir, string[] args)
        {
            // Option 11: Import Human Review CSV
            Console.WriteLine("Running Option 11: Import Human Review CSV");
            
            // Look for --csv parameter
            string csvPath = null;
            for (int i = 0; i < args.Length; i++)
            {
                if (args[i].Equals("--csv", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                {
                    csvPath = args[i + 1];
                    break;
                }
                else if (args[i].StartsWith("--csv=", StringComparison.OrdinalIgnoreCase))
                {
                    csvPath = args[i].Substring("--csv=".Length).Trim();
                    break;
                }
            }

            // If no CSV path provided, use default
            if (string.IsNullOrEmpty(csvPath))
            {
                csvPath = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "TableMigrationReport-Dec-1.csv");
                Console.WriteLine($"No --csv parameter provided, using default: {csvPath}");
            }
            else
            {
                csvPath = Path.GetFullPath(csvPath);
                Console.WriteLine($"Using CSV file: {csvPath}");
            }

            if (!File.Exists(csvPath))
            {
                Console.Error.WriteLine($"CSV file not found: {csvPath}");
                return 1;
            }

            string planLogPath;
            int result = PlanHumanReviewImporter.Import(migrationsDir, csvPath, out planLogPath);
            
            Console.WriteLine($"CSV import completed with result: {result}");
            if (!string.IsNullOrEmpty(planLogPath))
            {
                Console.WriteLine($"Constraints file written to: {planLogPath}");
            }

            return result;
        }

        private static int RunOption12(string migrationsDir, MigrationConfig config)
        {
            // Option 12: Validate plan
            Console.WriteLine("Running Option 12: Validate plan");
            // TODO: Implement direct validation call
            Console.WriteLine("Option 12 direct execution not implemented yet.");
            return 1;
        }

        private static int RunOptionVerification(string migrationsDir, MigrationConfig config)
        {
            // Option &: Post-migration data validation
            Console.WriteLine("Running Option &: Post-migration data validation");
            // TODO: Implement direct verification call
            Console.WriteLine("Option & direct execution not implemented yet.");
            return 1;
        }

        private static int RunOptionA(string migrationsDir)
        {
            // Option A: Generate CREATE TABLE DDL
            Console.WriteLine("Running Option A: Generate CREATE TABLE DDL");
            
            try
            {
                string sqlPath;
                int result = DdlScriptGenerator.GenerateCreateTables(migrationsDir, out sqlPath);
                
                if (result == 0)
                {
                    Console.WriteLine($"CREATE TABLE DDL generated successfully: {sqlPath}");
                }
                else
                {
                    Console.WriteLine($"CREATE TABLE DDL generation failed with code: {result}");
                }
                
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error generating CREATE TABLE DDL: {ex.Message}");
                return 1;
            }
        }

        private static int RunOptionM(string migrationsDir)
        {
            // Option M: Generate data migration script
            Console.WriteLine("Running Option M: Generate data migration script");
            
            try
            {
                string sqlPath;
                int result = DmlScriptGenerator.GenerateDataMigration(migrationsDir, out sqlPath);
                
                if (result == 0)
                {
                    Console.WriteLine($"Data migration script generated successfully: {sqlPath}");
                }
                else
                {
                    Console.WriteLine($"Data migration script generation failed with code: {result}");
                }
                
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error generating data migration script: {ex.Message}");
                return 1;
            }
        }

        private static int RunOptionN(string migrationsDir, MigrationConfig config)
        {
            // Option N: Apply data migration script
            Console.WriteLine("Running Option N: Apply data migration script");
            // TODO: Implement direct migration execution
            Console.WriteLine("Option N direct execution not implemented yet.");
            return 1;
        }


        // (BootstrapMetadata and CopyDirectory moved to MetadataService)
    }
}
