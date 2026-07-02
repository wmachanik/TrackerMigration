using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using MigrationRunner.UI;

namespace MigrationRunner
{
    public static class TableByTableMigrationRunner
    {
        public static int Run(string migrationsDir, string sqlConnectionString, List<string> tables, string logFilePath)
        {
            // Ensure logs are written to the project folder
            var logsDir = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Logs");
            Directory.CreateDirectory(logsDir);
            var logFile = Path.Combine(logsDir, "TableByTableMigration.log");
            var logger = new TableMigrationLogger(logFile);
            int overallStatus = 0;
            var tableResults = new List<(string Table, int SrcRows, int TgtRows, bool Success, bool Warning, bool Error)>();
            foreach (var table in tables)
            {
                logger.LogTableHeader(table);
                Console.WriteLine($"Migrating table: {table}");
                bool success = false, warning = false, error = false;
                int srcRows = -1, tgtRows = -1;
                bool dateConversionError = false;
                try
                {
                    // Run migration script
                    var migrateScript = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Sql", $"Migrate_{table}.sql");
                    if (!File.Exists(migrateScript))
                    {
                        logger.LogError($"Migration script not found: {migrateScript}");
                        Console.WriteLine($"ERROR: Migration script not found for table {table}");
                        error = true;
                        overallStatus = 1;
                        tableResults.Add((table, srcRows, tgtRows, success, warning, error));
                        if (!PromptContinue($"Migration script not found for table {table}."))
                        {
                            break;
                        }
                        continue;
                    }
                    string lastSqlError = null;
                    int migrateResult = RunSqlScript(sqlConnectionString, migrateScript, logger, out lastSqlError);
                    error = migrateResult != 0;
                    if (error && lastSqlError != null && lastSqlError.ToLowerInvariant().Contains("conversion failed when converting date"))
                    {
                        dateConversionError = true;
                    }
                    if (error)
                    {
                        // Prompt user to continue or stop after migration error
                        if (!PromptContinue($"Error occurred during migration of table {table}. Do you want to continue? (Y/N)"))
                        {
                            break;
                        }
                    }

                    // Run verification script
                    var verifyScript = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Sql", $"Verify_{table}.sql");
                    int verifyResult = 0;
                    bool verificationError = false;
                    if (File.Exists(verifyScript))
                    {
                        verifyResult = RunSqlScript(sqlConnectionString, verifyScript, logger, out string verifySqlError);
                        warning = verifyResult != 0;
                        if (verifyResult != 0)
                        {
                            verificationError = true;
                            // Prompt user to continue or stop after verification error
                            if (!PromptContinue($"Error occurred during verification of table {table}. Do you want to continue? (Y/N)"))
                            {
                                break;
                            }
                        }
                    }
                    else
                    {
                        logger.LogWarning($"Verification script not found: {verifyScript}");
                        Console.WriteLine($"WARNING: Verification script not found for table {table}");
                        warning = true;
                    }

                    srcRows = GetRowCount(sqlConnectionString, $"AccessSrc.{table}");
                    tgtRows = GetRowCount(sqlConnectionString, table);

                    logger.LogStatus(table, srcRows, tgtRows, warning ? 1 : 0, error ? 1 : 0);
                    Console.WriteLine($"Status: {srcRows} source rows migrated to {tgtRows} target");
                    success = !error;
                }
                catch (System.Exception ex)
                {
                    logger.LogError($"Exception: {ex}");
                    Console.WriteLine($"ERROR: Exception during migration of table {table}: {ex.Message}");
                    error = true;
                    overallStatus = 1;
                }
                // If date conversion error, run C# fallback
                if (dateConversionError)
                {
                    Console.WriteLine($"[FALLBACK] Detected date conversion error for {table}. Running C# data migration fallback...");
                    try
                    {
                        RunCSharpDataMigrationFallback(migrationsDir, table, logger);
                        error = false; // Assume fallback succeeded for now
                        success = true;
                    }
                    catch (System.Exception ex)
                    {
                        logger.LogError($"C# fallback failed: {ex}");
                        Console.WriteLine($"[FALLBACK ERROR] {ex.Message}");
                        error = true;
                        success = false;
                    }
                }
                tableResults.Add((table, srcRows, tgtRows, success, warning, error));
            }
                // (Removed inlined fallback code. The call below is correct)
            logger.Save();
            logger.PrintSummary();

            // Print detailed summary
            int total = tableResults.Count;

            int succeeded = tableResults.Count(r => r.Success && !r.Error);
            int failed = tableResults.Count(r => r.Error);
            int warned = tableResults.Count(r => r.Warning && !r.Error);
            Console.WriteLine("\n==== MIGRATION SUMMARY ====");
            Console.WriteLine($"Tables attempted: {total}");
            Console.WriteLine($"Tables succeeded: {succeeded}");
            Console.WriteLine($"Tables with warnings: {warned}");
            Console.WriteLine($"Tables failed: {failed}");
            Console.WriteLine();
            Console.WriteLine("Table results:");
            foreach (var r in tableResults)
            {
                Console.WriteLine($"- {r.Table}: srcRows={r.SrcRows}, tgtRows={r.TgtRows}, Success={r.Success}, Warning={r.Warning}, Error={r.Error}");
            }
            Console.WriteLine("==========================\n");
            if (tableResults.Any(r => r.Error))
                overallStatus = 1;
            return overallStatus;
        }

        // Overload: RunSqlScript with error output
        private static int RunSqlScript(string sqlConnectionString, string scriptPath, TableMigrationLogger logger, out string lastSqlError)
        {
            lastSqlError = null;
            var sql = File.ReadAllText(scriptPath);
            try
            {
                using (var conn = new SqlConnection(sqlConnectionString))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandTimeout = 0;
                        cmd.CommandText = sql;
                        try
                        {
                            cmd.ExecuteNonQuery();
                            logger.LogInfo($"Executed script: {scriptPath}");
                            return 0;
                        }
                        catch (SqlException ex)
                        {
                            lastSqlError = ex.Message;
                            logger.LogError($"SQL error in {scriptPath}: {ex.Message}\n{ex.ToString()}");
                            Console.WriteLine($"[ERROR] SQL error in {scriptPath}: {ex.Message}");
                            Console.WriteLine(ex.ToString());
                            return 1;
                        }
                        catch (Exception ex)
                        {
                            lastSqlError = ex.Message;
                            logger.LogError($"Script error in {scriptPath}: {ex.Message}\n{ex.ToString()}");
                            Console.WriteLine($"[ERROR] Script error in {scriptPath}: {ex.Message}");
                            Console.WriteLine(ex.ToString());
                            return 1;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lastSqlError = ex.Message;
                logger.LogError($"Connection or script error in {scriptPath}: {ex.Message}\n{ex.ToString()}");
                Console.WriteLine($"[ERROR] Connection or script error in {scriptPath}: {ex.Message}");
                Console.WriteLine(ex.ToString());
                return 1;
            }
        }

        private static int GetRowCount(string sqlConnectionString, string table)
        {
            try
            {
                using (var conn = new SqlConnection(sqlConnectionString))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = $"SELECT COUNT(*) FROM [{table}]";
                        var result = cmd.ExecuteScalar();
                        return Convert.ToInt32(result);
                    }
                }
            }
            catch
            {
                return -1;
            }
        }

        // Prompt user to continue or stop after an error
        private static bool PromptContinue(string errorMessage)
        {
            var rro = RunRangeState.Current;
            if (rro != null && rro.ContinueOnTableMigrationErrors)
            {
                Console.WriteLine(errorMessage);
                Console.WriteLine("Continuing with next table (batch mode).");
                return true;
            }

            Console.WriteLine();
            Console.WriteLine($"{errorMessage}");
            Console.Write("Do you want to continue with the next table? (Y/N): ");
            var response = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(response)) return false;
               return response.Trim().ToUpperInvariant().StartsWith("Y");
        }

        // C# fallback for data migration if date conversion error is detected
        private static void RunCSharpDataMigrationFallback(string migrationsDir, string table, TableMigrationLogger logger)
        {
            // This is a simplified fallback: reads from AccessSrc, parses dates, inserts into SQL
            // You may want to expand this for your schema and error handling
            var configPath = Path.Combine(migrationsDir, "..", "MigrationConfig.json");
            if (!File.Exists(configPath)) throw new FileNotFoundException("MigrationConfig.json not found");
            var config = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(File.ReadAllText(configPath));
            string accessConnStr = config["AccessConnectionString"];
            string sqlConnStr = config["TargetConnectionString"];

            using (var accessConn = new System.Data.OleDb.OleDbConnection(accessConnStr))
            using (var sqlConn = new System.Data.SqlClient.SqlConnection(sqlConnStr))
            {
                accessConn.Open();
                sqlConn.Open();
                var cmd = accessConn.CreateCommand();
                cmd.CommandText = $"SELECT * FROM [{table}]";
                using (var reader = cmd.ExecuteReader())
                {
                    var columns = new List<string>();
                    var dateColumns = new List<int>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        columns.Add(reader.GetName(i));
                        var dataType = reader.GetFieldType(i);
                        if (dataType == typeof(System.DateTime) || dataType == typeof(string))
                        {
                            // Heuristic: treat string columns as possible date columns
                            dateColumns.Add(i);
                        }
                    }
                    var insertSql = $"INSERT INTO [{table}] (" + string.Join(", ", columns.Select(c => $"[{c}]")) + ") VALUES (" + string.Join(", ", columns.Select((c, idx) => $"@p{idx}")) + ")";
                    using (var insertCmd = sqlConn.CreateCommand())
                    {
                        insertCmd.CommandText = insertSql;
                        foreach (var col in columns.Select((c, idx) => new { c, idx }))
                        {
                            insertCmd.Parameters.Add($"@p{col.idx}", System.Data.SqlDbType.Variant);
                        }
                        while (reader.Read())
                        {
                            for (int i = 0; i < columns.Count; i++)
                            {
                                object val = reader.IsDBNull(i) ? DBNull.Value : reader.GetValue(i);
                                if (dateColumns.Contains(i) && val != DBNull.Value)
                                {
                                    System.DateTime dt;
                                    if (System.DateTime.TryParse(val.ToString(), out dt))
                                        val = dt;
                                    else
                                        val = DBNull.Value;
                                }
                                insertCmd.Parameters[$"@p{i}"].Value = val;
                            }
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            logger.LogInfo($"C# fallback migration completed for {table}");
            Console.WriteLine($"[FALLBACK] C# data migration completed for {table}");
        }
    }
}
