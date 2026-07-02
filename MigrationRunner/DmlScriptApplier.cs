using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace MigrationRunner
{
    internal static class DmlScriptApplier
    {
        public static int ApplyLatest(string migrationsDir, string connectionString, out string logPath, out string errorLogPath)
        {
            var sqlDir = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Sql");
            var logsDir = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Logs");
            Directory.CreateDirectory(sqlDir);
            Directory.CreateDirectory(logsDir);
            var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            logPath = Path.Combine(logsDir, "ApplyData_" + timestamp + ".log");
            errorLogPath = Path.Combine(logsDir, "ApplyData_Errors_" + timestamp + ".log");

            // Always run UNNORMALIZED and NORMALIZED scripts if they exist and are not empty
            var scripts = new List<string>();
            var unnormalizedPath = Path.Combine(sqlDir, "DataMigration_UNNORMALIZED.sql");
            var normalizedPath = Path.Combine(sqlDir, "DataMigration_NORMALIZED.sql");
            if (File.Exists(unnormalizedPath) && new FileInfo(unnormalizedPath).Length > 100)
                scripts.Add(unnormalizedPath);
            if (File.Exists(normalizedPath) && new FileInfo(normalizedPath).Length > 100)
                scripts.Add(normalizedPath);

            if (scripts.Count == 0)
            {
                var sb = new StringBuilder();
                sb.AppendLine("No DataMigration_UNNORMALIZED.sql or DataMigration_NORMALIZED.sql found in: " + sqlDir);
                File.WriteAllText(logPath, sb.ToString(), Encoding.UTF8);
                File.WriteAllText(errorLogPath, sb.ToString(), Encoding.UTF8);
                return 2;
            }

            var mainLog = new StringBuilder();
            var mainErrorLog = new StringBuilder();
            int anyError = 0;
            foreach (var scriptPath in scripts)
            {
                mainLog.AppendLine($"========== Executing: {Path.GetFileName(scriptPath)} ==========");
                int rc = ApplyScript(migrationsDir, connectionString, scriptPath, out var stepLog, out var stepErrorLog);
                mainLog.AppendLine(File.ReadAllText(stepLog));
                mainErrorLog.AppendLine(File.ReadAllText(stepErrorLog));
                if (rc != 0)
                {
                    mainLog.AppendLine($"WARNING: {Path.GetFileName(scriptPath)} returned rc={rc}");
                    anyError = rc;
                }
            }
            File.WriteAllText(logPath, mainLog.ToString(), Encoding.UTF8);
            File.WriteAllText(errorLogPath, mainErrorLog.ToString(), Encoding.UTF8);
            return anyError;
        }

        // Run a specific migration script file (not by timestamp)
        public static int ApplyScript(string migrationsDir, string connectionString, string scriptPath, out string logPath, out string errorLogPath)
        {
            var logsDir = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Logs");
            Directory.CreateDirectory(logsDir);
            var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            logPath = Path.Combine(logsDir, "ApplyData_" + timestamp + ".log");
            errorLogPath = Path.Combine(logsDir, "ApplyData_Errors_" + timestamp + ".log");

            var sb = new StringBuilder();
            var errSb = new StringBuilder();
            if (string.IsNullOrWhiteSpace(scriptPath) || !File.Exists(scriptPath))
            {
                sb.AppendLine("Specified DataMigration SQL file not found: " + scriptPath);
                File.WriteAllText(logPath, sb.ToString(), Encoding.UTF8);
                return 2;
            }

            sb.AppendLine("Applying DATA MIGRATION script to target DB");
            sb.AppendLine("File:");
            sb.AppendLine("  - " + scriptPath);

            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    var infoBuf = new StringBuilder();
                    conn.InfoMessage += (s, e) =>
                    {
                        if (e?.Message != null)
                        {
                            foreach (var line in e.Message.Replace("\r", "").Split('\n'))
                            {
                                if (string.IsNullOrWhiteSpace(line)) continue;
                                infoBuf.AppendLine("SQL> " + line.TrimEnd());
                            }
                        }
                    };
                    conn.FireInfoMessageEventOnUserErrors = true;

                    conn.Open();

                    // Log connection info so we can diagnose DB/schema mismatches
                    try
                    {
                        sb.AppendLine($"-- Connection: DataSource={conn.DataSource}, Database={conn.Database}");
                        errSb.AppendLine($"CONN: DataSource={conn.DataSource}, Database={conn.Database}");
                    }
                    catch { }

                    // Before migration: capture baseline row counts for all target tables
                    var baselineCounts = CaptureTableRowCounts(conn, sb);

                    int batchResult = ExecuteBatches(conn, File.ReadAllText(scriptPath), sb, errSb, Path.GetFileName(scriptPath));
                    bool hadBatchErrors = batchResult < 0;
                    int executedBatches = Math.Abs(batchResult);

                    // After migration: compare source vs target row counts
                    var migrationReport = GenerateMigrationReport(conn, baselineCounts, sb, errSb);

                    // Append captured PRINT/RAISERROR messages
                    var infoText = infoBuf.ToString();
                    if (infoText.Length > 0)
                    {
                        sb.AppendLine();
                        sb.AppendLine("-- Messages from SQL Server (PRINT/INFO):");
                        sb.Append(infoText);

                        // Extract relevant runtime messages into the error-only log as well
                        foreach (var line in infoText.Replace("\r", "").Split('\n'))
                        {
                            var l = line?.Trim();
                            if (string.IsNullOrWhiteSpace(l)) continue;

                            // Capture explicit migration ERROR lines
                            if (l.StartsWith("SQL> ERROR", StringComparison.OrdinalIgnoreCase) || l.Contains("ERROR migrate"))
                            {
                                errSb.AppendLine(l);
                                continue;
                            }

                            // Capture warnings and other important diagnostics that indicate problems
                            if (l.IndexOf("WARN:", StringComparison.OrdinalIgnoreCase) >= 0
                                || l.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0
                                || l.IndexOf("could not CHECK", StringComparison.OrdinalIgnoreCase) >= 0
                                || l.IndexOf("Violation of PRIMARY KEY constraint", StringComparison.OrdinalIgnoreCase) >= 0
                                || l.IndexOf("Violation of UNIQUE KEY constraint", StringComparison.OrdinalIgnoreCase) >= 0
                                || l.IndexOf("The DELETE statement conflicted with the REFERENCE constraint", StringComparison.OrdinalIgnoreCase) >= 0)
                            {
                                errSb.AppendLine(l);
                            }
                        }
                    }

                    // Heuristic: treat common severity messages printed via InfoMessage as failure
                    // Only detect ACTUAL runtime errors, not template strings from CATCH blocks
                    // Template strings appear as: "    PRINT N'ERROR: Failed to purge..."
                    // Actual errors appear as: "SQL> ERROR migrate [TableName]..."
                    var actualErrorPatterns = new[]
                    {
                        "Invalid column name",
                        "Incorrect syntax near",
                        "Invalid object name",
                        @"^SQL> ERROR migrate \[" // Only match actual runtime PRINT statements
                    };
                    bool infoHadErrors = actualErrorPatterns.Any(p => Regex.IsMatch(infoText, p, RegexOptions.Multiline));

                    sb.AppendLine();
                    sb.AppendLine("=" + new string('=', 110));
                    sb.AppendLine("MIGRATION SUMMARY REPORT");
                    sb.AppendLine("=" + new string('=', 110));
                    sb.Append(migrationReport);

                    // Also write the summary to console immediately
                    Console.WriteLine();
                    Console.WriteLine("=" + new string('=', 110));
                    Console.WriteLine("MIGRATION SUMMARY REPORT");
                    Console.WriteLine("=" + new string('=', 110));
                    Console.Write(migrationReport);

                    sb.AppendLine();
                    if (hadBatchErrors || infoHadErrors)
                    {
                        var failMsg = $"? MIGRATION FAILED: executedBatches={executedBatches}, hadBatchErrors={hadBatchErrors}, infoHadErrors={infoHadErrors}";
                        sb.AppendLine(failMsg);
                        sb.AppendLine("Check the detailed error messages above for specific issues.");
                        Console.WriteLine(failMsg);
                        Console.WriteLine("Check the error log for specific issues: " + errorLogPath);
                    }
                    else
                    {
                        var successMsg = $"? SUCCESS: batchesExecuted={executedBatches}, no errors detected";
                        sb.AppendLine(successMsg);
                        Console.WriteLine(successMsg);
                    }
                    
                     File.WriteAllText(logPath, sb.ToString(), Encoding.UTF8);
                    // Write separate error-only log (may be empty)
                    try
                    {
                        File.WriteAllText(errorLogPath, errSb.ToString(), Encoding.UTF8);
                    }
                    catch { /* don't fail overall due to error-log write */ }

                    // CRITICAL FIX: Return proper error code
                     return (hadBatchErrors || infoHadErrors) ? 1 : 0;
                }
            }
            catch (Exception ex)
            {
                sb.AppendLine("ERROR: " + ex);
                File.WriteAllText(logPath, sb.ToString(), Encoding.UTF8);
                try { File.WriteAllText(errorLogPath, ex.ToString(), Encoding.UTF8); } catch { }
                return 1;
            }
        }
        // Split on GO batch separators (line with only GO, any casing)
        private static int ExecuteBatches(SqlConnection conn, string script, StringBuilder log, StringBuilder errLog, string currentFile)
        {
            // Correctly split script on GO statements (case-insensitive, any line ending)
            var batches = Regex.Split(script ?? string.Empty, @"^\s*GO\s*$(\r?\n)?", RegexOptions.Multiline | RegexOptions.IgnoreCase)
                .Select(b => b.Trim())
                .Where(b => !string.IsNullOrWhiteSpace(b))
                .ToList();

            log.AppendLine($"-- Script split into {batches.Count} batches for execution");

            int executed = 0;
            bool hasErrors = false;

            for (int i = 0; i < batches.Count; i++)
            {
                var part = batches[i];
                log.AppendLine($"-- BEGIN BATCH {i + 1}/{batches.Count}");
                log.AppendLine("   Snippet: " + Summarize(part));
                log.AppendLine("   Full batch follows:");
                log.AppendLine(part);
                log.AppendLine("-- END BATCH BODY");

                // Allow a transformed copy of the batch to be executed. Some generated
                // migration SQL uses joins like "ON c.ContactID = src.CustomerID" where
                // the source CustomerID column can be text. Converting via TRY_CONVERT
                // at runtime avoids the INNER JOIN filtering out all rows when types
                // mismatch. We only apply a small, targeted transformation to avoid
                // touching generated files.
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandTimeout = 0;

                    // Apply lightweight, safe transformations to improve matching of
                    // Contacts joins coming from Access source (text IDs) vs int target.
                    var transformedPart = TransformCustomerIdJoin(part);
                    if (!string.Equals(transformedPart, part, StringComparison.Ordinal))
                    {
                        log.AppendLine("   -- NOTE: Applied JOIN->TRY_CONVERT transform to aid Contacts join matching");
                        log.AppendLine("   -- Transformed snippet follows:");
                        log.AppendLine(Summarize(transformedPart));
                    }

                    // If this batch inserts into ContactsItemSvcSummaryTbl, inject lightweight
                    // server-side diagnostics before the INSERT so we can see source vs matched
                    // counts in the normal migration log (InfoMessage captured).
                    if (Regex.IsMatch(transformedPart, @"INSERT\s+INTO\s+\[ContactsItemSvcSummaryTbl\]", RegexOptions.IgnoreCase))
                    {
                        var diagSql = @"-- DIAG: counts for ContactsItemSvcSummaryTbl incoming data
DECLARE @srcCount int = (SELECT COUNT(*) FROM AccessSrc.ClientUsageLinesTbl);
DECLARE @srcNotNull int = (SELECT COUNT(*) FROM AccessSrc.ClientUsageLinesTbl WHERE CustomerID IS NOT NULL AND LTRIM(RTRIM(CustomerID)) <> '');
DECLARE @matched int = (SELECT COUNT(*) FROM AccessSrc.ClientUsageLinesTbl src LEFT JOIN ContactsTbl c ON TRY_CONVERT(INT, src.CustomerID) = c.ContactID WHERE src.CustomerID IS NOT NULL AND LTRIM(RTRIM(src.CustomerID)) <> '');
PRINT 'DIAG: AccessSrc.ClientUsageLinesTbl Rows=' + CAST(@srcCount AS nvarchar(20)) + ', NonNull=' + CAST(@srcNotNull AS nvarchar(20)) + ', MatchedContacts=' + CAST(@matched AS nvarchar(20));
";
                        transformedPart = diagSql + "\n" + transformedPart;
                        log.AppendLine("   -- Injected diagnostics for ContactsItemSvcSummaryTbl batch");
                    }

                    cmd.CommandText = transformedPart;
                    try
                    {
                        // Capture InfoMessage output that occurs during this specific batch
                        var batchInfo = new StringBuilder();
                        SqlInfoMessageEventHandler handler = (s, e) =>
                        {
                            if (e?.Message == null) return;
                            foreach (var line in e.Message.Replace("\r", "").Split('\n'))
                            {
                                if (string.IsNullOrWhiteSpace(line)) continue;
                                batchInfo.AppendLine(line.TrimEnd());
                            }
                        };
                        conn.InfoMessage += handler;

                        cmd.ExecuteNonQuery();
                        // Detach handler immediately after batch completes
                        conn.InfoMessage -= handler;
                        executed++;
                        log.AppendLine($"   ? Batch {i + 1} executed successfully");

                        // If the batch produced informational messages, include them in logs with context
                        if (batchInfo.Length > 0)
                        {
                            log.AppendLine("   -- Messages emitted during this batch:");
                            log.AppendLine(batchInfo.ToString());
                            // Also surface warnings/errors to the concise error log with batch snippet
                            foreach (var line in batchInfo.ToString().Replace("\r", "").Split('\n'))
                            {
                                var l = line?.Trim();
                                if (string.IsNullOrWhiteSpace(l)) continue;
                                if (l.IndexOf("WARN:", System.StringComparison.OrdinalIgnoreCase) >= 0 ||
                                    l.IndexOf("Invalid column name", System.StringComparison.OrdinalIgnoreCase) >= 0 ||
                                    l.IndexOf("could not CHECK", System.StringComparison.OrdinalIgnoreCase) >= 0 ||
                                    l.IndexOf("ERROR migrate", System.StringComparison.OrdinalIgnoreCase) >= 0)
                                {
                                    errLog.AppendLine($"BATCH {i + 1} MSG: {l}");
                                    errLog.AppendLine("SNIPPET: " + Summarize(part));
                                    // If this message indicates an invalid column name, include the full failing batch to help diagnosis
                                    if (l.IndexOf("Invalid column name", System.StringComparison.OrdinalIgnoreCase) >= 0)
                                    {
                                        try
                                        {
                                            var full = part ?? string.Empty;
                                            if (full.Length > 0)
                                            {
                                                errLog.AppendLine("FULL BATCH FOLLOWS:");
                                                // limit to reasonably large chunk to avoid extremely large logs
                                                errLog.AppendLine(full.Length <= 8000 ? full : full.Substring(0, 8000) + "... [truncated]");
                                            }
                                        }
                                        catch { }
                                    }
                                }
                            }
                        }
                    }
                    catch (SqlException sex)
                    {
                        hasErrors = true;
                        log.AppendLine("? ERROR executing batch:");
                        log.AppendLine("  File: " + currentFile);
                        log.AppendLine("  Snippet: " + Summarize(part));
                        log.AppendLine("  SqlException: Number=" + sex.Number + " State=" + sex.State + " Class=" + sex.Class);
                        log.AppendLine("  Message: " + sex.Message);
                        try
                        {
                            foreach (SqlError e in sex.Errors)
                                log.AppendLine($"    -> {e.Number} (Line {e.LineNumber}): {e.Message}");
                        }
                        catch { /* ignore */ }
                        
                        // Also append succinct error info and the failing snippet to the separate error log
                        errLog.AppendLine($"ERROR executing batch {i + 1} (File: {currentFile}): {sex.Message}");
                        // Include summarized snippet to help locate the failing SQL
                        errLog.AppendLine("SNIPPET: " + Summarize(part));
                        try
                        {
                            foreach (SqlError e in sex.Errors)
                                errLog.AppendLine($"  -> {e.Number} (Line {e.LineNumber}): {e.Message}");
                        }
                        catch { }

                        // CRITICAL FIX: Don't throw, continue processing but mark as failed
                        log.AppendLine($"   ? Batch {i + 1} FAILED - continuing with remaining batches");
                    }
                    catch (Exception ex)
                    {
                        hasErrors = true;
                        log.AppendLine("? ERROR executing batch:");
                        log.AppendLine("  File: " + currentFile);
                        log.AppendLine("  Snippet: " + Summarize(part));
                        log.AppendLine("  Exception: " + ex.Message);
                        
                        // Also append to error-only log with snippet for easier diagnosis
                        errLog.AppendLine($"ERROR executing batch {i + 1} (File: {currentFile}): {ex.Message}");
                        errLog.AppendLine("SNIPPET: " + Summarize(part));

                        // CRITICAL FIX: Don't throw, continue processing but mark as failed
                        log.AppendLine($"   ? Batch {i + 1} FAILED - continuing with remaining batches");
                    }
                }
            }
            
            // CRITICAL FIX: Return negative value to indicate errors occurred
            return hasErrors ? -executed : executed;
        }

        private static string Summarize(string sql)
        {
            var s = (sql ?? "").Replace("\r", "").Replace("\n", " ");
            return s.Length <= 400 ? s : s.Substring(0, 397) + "...";
        }

        // Perform small targeted SQL text transforms to improve join matching when
        // source Access columns are text but target columns are numeric. This is a
        // pragmatic runtime fix so generated DataMigration SQL does not have to be
        // re-generated in-place.
        private static string TransformCustomerIdJoin(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql)) return sql;

            try
            {
                // Pattern: JOIN ContactsTbl <alias> ON <alias>.ContactID = src.CustomerID
                // Replace RHS with TRY_CONVERT(INT, src.CustomerID) to avoid type-mismatch
                // inner-join dropping rows when source uses text IDs.
                var regex = new Regex(@"JOIN\s+ContactsTbl\s+(?<alias>\w+)\s+ON\s+(?<alias2>\w+)\.ContactID\s*=\s*src\.CustomerID",
                                      RegexOptions.IgnoreCase | RegexOptions.Multiline);

                var result = regex.Replace(sql, m =>
                {
                    var alias = m.Groups["alias"].Value;
                    // Use TRY_CONVERT to safely handle non-numeric source values (NULL -> no match)
                    return $"JOIN ContactsTbl {alias} ON TRY_CONVERT(INT, src.CustomerID) = {alias}.ContactID";
                });

                // Also handle variant where RHS appears first: ON src.CustomerID = c.ContactID
                var regex2 = new Regex(@"JOIN\s+ContactsTbl\s+(?<alias>\w+)\s+ON\s+src\.CustomerID\s*=\s*(?<alias2>\w+)\.ContactID",
                                      RegexOptions.IgnoreCase | RegexOptions.Multiline);
                result = regex2.Replace(result, m =>
                {
                    var alias = m.Groups["alias"].Value;
                    return $"JOIN ContactsTbl {alias} ON TRY_CONVERT(INT, src.CustomerID) = {alias}.ContactID";
                });

                return result;
            }
            catch
            {
                return sql;
            }
        }

        private static Dictionary<string, int> CaptureTableRowCounts(SqlConnection conn, StringBuilder log)
        {
            var counts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            try
            {
                log.AppendLine("-- Capturing baseline table row counts before migration...");
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandTimeout = 60;
                    cmd.CommandText = @"SELECT t.name, SUM(p.rows) AS [RowCount]
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1) AND t.is_ms_shipped = 0
GROUP BY t.name;";
                    using (var rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            var tableName = rdr.GetString(0);
                            var rowCount = Convert.ToInt32(rdr[1]);
                            counts[tableName] = rowCount;
                        }
                    }
                }
                log.AppendLine($"-- Captured baseline counts for {counts.Count} tables.");
            }
            catch (Exception ex)
            {
                log.AppendLine($"-- WARNING: Failed to capture baseline counts: {ex.Message}");
            }
            return counts;
        }

        private static string GenerateMigrationReport(SqlConnection conn, Dictionary<string, int> baselineCounts, StringBuilder log, StringBuilder errLog)
        {
            var report = new StringBuilder();
            try
            {
                log.AppendLine("-- Generating migration report (source vs target row counts)...");
                report.AppendLine("Table Migration Results:");
                report.AppendLine(new string('-', 110));
                report.AppendLine(String.Format("{0,-35} {1,-35} {2,12} {3,12} {4,12} {5}",
                    "Source Table", "Target Table", "Source Rows", "Before", "After", "Status"));
                report.AppendLine(new string('-', 110));

                // Get current row counts for all tables
                var currentCounts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandTimeout = 60;
                    cmd.CommandText = @"SELECT t.name, SUM(p.rows) AS [RowCount]
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1) AND t.is_ms_shipped = 0
GROUP BY t.name;";
                    using (var rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            var tableName = rdr.GetString(0);
                            var rowCount = Convert.ToInt32(rdr[1]);
                            currentCounts[tableName] = rowCount;
                        }
                    }
                }

                // Get source table counts from AccessSrc schema
                var sourceCounts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                try
                {
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandTimeout = 60;
                        cmd.CommandText = @"SELECT t.name, SUM(p.rows) AS [RowCount]
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE s.name = 'AccessSrc' AND p.index_id IN (0, 1)
GROUP BY t.name;";
                        using (var rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                var tableName = rdr.GetString(0);
                                var rowCount = Convert.ToInt32(rdr[1]);
                                sourceCounts[tableName] = rowCount;
                            }
                        }
                    }
                }
                catch { /* AccessSrc schema may not exist */ }

                // Build source->target mapping from ROWS_INSERTED messages in the SQL Server message buffer
                // Messages look like: "OK migrate [TargetTbl] from [AccessSrc].[SourceTbl]"
                // We'll need to track this from the InfoMessage events during execution
                // For now, use the table names directly - most are 1:1 mappings

                // Generate report for each target table that was migrated
                var totalTables = 0;
                var successTables = 0;
                var failedTables = 0;
                var emptyTables = 0;
                var partialTables = 0;

                // Check all target tables that changed OR have data
                foreach (var targetTable in currentCounts.Keys.OrderBy(k => k))
                {
                    var beforeCount = baselineCounts.ContainsKey(targetTable) ? baselineCounts[targetTable] : 0;
                    var afterCount = currentCounts[targetTable];

                    // Skip ONLY if table is completely empty (both before and after)
                    // This way we show all tables with data, even if they didn't change during THIS run
                    if (afterCount == 0 && beforeCount == 0)
                        continue;

                    // Try to find exact matching source table first, then fuzzy match
                    int sourceCount = 0;
                    string sourceTableName = "";

                    // Try exact match first
                    if (sourceCounts.ContainsKey(targetTable))
                    {
                        sourceCount = sourceCounts[targetTable];
                        sourceTableName = targetTable;
                    }
                    else
                    {
                        // Try common renames: CustomersTbl -> ContactsTbl, etc.
                        var alternateNames = new[]
                        {
                            targetTable.Replace("Contact", "Customer"),
                            targetTable.Replace("Customer", "Contact"),
                            targetTable.Replace("Equip", "Machine"),
                            targetTable.Replace("Item", "CoffeeType"),
                            targetTable.Replace("Prep", "Roast"),
                            targetTable.Replace("Area", "City"),
                            targetTable.Replace("City", "Area")
                        };

                        foreach (var altName in alternateNames)
                        {
                            if (sourceCounts.ContainsKey(altName))
                            {
                                sourceCount = sourceCounts[altName];
                                sourceTableName = altName;
                                break;
                            }
                        }
                    }

                    totalTables++;
                    var rowsAdded = afterCount - beforeCount;
                    string status = "";
                    string sourceDisplay = sourceTableName.Length > 0 ? $"AccessSrc.{sourceTableName}" : "-";

                    if (afterCount == 0 && sourceCount > 0)
                    {
                        status = "? FAILED (0 rows)";
                        failedTables++;
                        errLog.AppendLine($"MIGRATION FAILED: {targetTable} - Source: {sourceCount}, Target: {afterCount}");
                    }
                    else if (afterCount == 0 && sourceCount == 0)
                    {
                        status = "?? EMPTY (source empty)";
                        emptyTables++;
                    }
                    else if (sourceCount > 0 && afterCount != sourceCount)
                    {
                        var pct = sourceCount > 0 ? (afterCount * 100.0 / sourceCount) : 0;
                        if (pct >= 95.0)
                        {
                            status = $"?? NEARLY OK ({pct:F1}%)";
                            partialTables++;
                        }
                        else
                        {
                            status = $"? PARTIAL ({pct:F1}%)";
                            failedTables++;
                        }
                        errLog.AppendLine($"MIGRATION MISMATCH: {targetTable} - Source: {sourceCount}, Target: {afterCount}, Diff: {afterCount - sourceCount} ({pct:F1}%)");
                    }
                    else if (sourceCount > 0 && sourceCount == afterCount)
                    {
                        // Perfect match - show as success regardless of whether it was added just now or earlier
                        status = rowsAdded > 0 ? $"? SUCCESS (100% - added {rowsAdded:N0})" : $"? OK (100% match)";
                        successTables++;
                    }
                    else if (rowsAdded > 0)
                    {
                        status = $"? ADDED (+{rowsAdded:N0})";
                        successTables++;
                    }
                    else if (afterCount > 0 && sourceCount == 0)
                    {
                        // Table has data but no matching source found - probably migrated earlier
                        status = $"? HAS DATA ({afterCount:N0} rows)";
                        successTables++;
                    }
                    else if (sourceCount > 0 && afterCount == 0)
                    {
                        // **CRITICAL**: Source has data but target is EMPTY - migration didn't run!
                        status = "? NO DATA MIGRATED - Script may not have executed";
                        failedTables++;
                        errLog.AppendLine($"**MIGRATION FAILED**: {targetTable} - Source has {sourceCount:N0} rows but target is EMPTY!");
                    }
                    else
                    {
                        status = "?? NO CHANGE";
                    }

                    report.AppendLine(String.Format("{0,-35} {1,-35} {2,12} {3,12} {4,12} {5}",
                        sourceDisplay,
                        targetTable,
                        sourceCount > 0 ? sourceCount.ToString("N0") : "-",
                        beforeCount.ToString("N0"),
                        afterCount.ToString("N0"),
                        status));
                }

                report.AppendLine(new string('-', 110));
                report.AppendLine($"Summary: {totalTables} tables processed");
                report.AppendLine($"  ? Success (100% match): {successTables}");
                report.AppendLine($"  ?? Partial (95-99%): {partialTables}");
                report.AppendLine($"  ? Failed (<95% or 0): {failedTables}");
                report.AppendLine($"  ?? Empty/Unchanged: {emptyTables}");
                report.AppendLine();
            }
            catch (Exception ex)
            {
                report.AppendLine($"ERROR generating migration report: {ex.Message}");
                log.AppendLine($"-- ERROR generating migration report: {ex.Message}");
            }
            return report.ToString();
        }
    }
}
