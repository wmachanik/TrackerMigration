using System;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Linq;

namespace MigrationRunner.UI
{
    internal sealed class ApplyUnnormalizedDataMigrationCommand : IMenuCommand
    {
        private readonly string _migrationsDir;
        private readonly MigrationConfig _config;

        public ApplyUnnormalizedDataMigrationCommand(string migrationsDir, MigrationConfig config)
        {
            _migrationsDir = migrationsDir; _config = config;
        }

        public string Key => "U";
        public string Description => "Apply UN-normalized data migration (creates tables if missing, or drops/recreates if requested)";

        public int Execute()
        {
            try
            {
                var sqlCs = _config?.TargetConnectionString ?? "";
                if (string.IsNullOrWhiteSpace(sqlCs))
                {
                    Console.Write("Target connection string [{0}]: ", "(empty)");
                    var input = Console.ReadLine();
                    if (!string.IsNullOrWhiteSpace(input)) sqlCs = input.Trim();
                }
                if (string.IsNullOrWhiteSpace(sqlCs)) { Console.Error.WriteLine("No target connection string provided"); return 2; }

                var sqlFolder = Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Sql");
                var unnormalizedPath = Path.Combine(sqlFolder, "DataMigration_UNNORMALIZED.sql");

                if (!File.Exists(unnormalizedPath))
                {
                    Console.WriteLine("DataMigration_UNNORMALIZED.sql not found under: " + sqlFolder);
                    Console.WriteLine("Please run option 'M' (Generate data migration script) first to create this file.");
                    return 2;
                }

                Console.WriteLine("Using pre-generated UNNORMALIZED migration script:");
                Console.WriteLine("  " + unnormalizedPath);
                Console.WriteLine();

                Console.WriteLine("Using pre-generated UNNORMALIZED migration script:");
                Console.WriteLine("  " + unnormalizedPath);
                Console.WriteLine();

                // Parse CreateTables header to discover which target tables to drop
                var createTablesPath = Path.Combine(sqlFolder, "CreateTables_LATEST.sql");
                var copyTargets = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);

                if (File.Exists(createTablesPath))
                {
                    var createText = File.ReadAllText(createTablesPath);
                    // Find copy mappings: Class=Copy Target=<TargetName>
                    var copyRegex = new System.Text.RegularExpressions.Regex(@"-- \[(?<src>[^\]]+)\]\s+Class=Copy\s+Target=(?<tgt>\w+)", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                    foreach (System.Text.RegularExpressions.Match m in copyRegex.Matches(createText))
                    {
                        var tgt = (m.Groups["tgt"]?.Value ?? "").Trim();
                        if (!string.IsNullOrWhiteSpace(tgt)) copyTargets.Add(tgt);
                    }
                }

                // Check which target tables exist and which are missing
                var existingTables = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);
                var missingTables = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);

                using (var conn = new SqlConnection(sqlCs))
                {
                    conn.Open();

                    // Get list of all existing tables in the database
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = 'dbo'";
                        using (var rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                existingTables.Add(rdr.GetString(0));
                            }
                        }
                    }
                }

                // Determine which tables are missing
                if (copyTargets.Count > 0)
                {
                    foreach (var tbl in copyTargets)
                    {
                        if (!existingTables.Contains(tbl))
                            missingTables.Add(tbl);
                    }
                }

                // If tables are missing, offer to create them
                if (missingTables.Count > 0)
                {
                    Console.WriteLine($"WARNING: {missingTables.Count} target tables do not exist:");
                    foreach (var tbl in missingTables)
                        Console.WriteLine($"  - {tbl}");
                    Console.WriteLine();
                    Console.Write("Do you want to create missing tables now? Type 'YES' to create them (or press Enter to abort): ");
                    var createConf = Console.ReadLine();

                    if (!string.Equals(createConf, "YES", StringComparison.Ordinal))
                    {
                        Console.WriteLine("Aborted. Please create tables first using option 'B' (Apply CreateTables script) or '$' (Full pipeline).");
                        return 2;
                    }

                    // Create tables by running the CreateTables script
                    if (!File.Exists(createTablesPath))
                    {
                        Console.WriteLine("ERROR: CreateTables_LATEST.sql not found. Please run option 'C' first to generate it.");
                        return 2;
                    }

                    Console.WriteLine("Creating missing tables...");
                    var createRc = DdlScriptApplier.ApplyLatest(_migrationsDir, sqlCs, out var createLog);
                    if (createRc != 0)
                    {
                        Console.WriteLine($"ERROR: Table creation failed (rc={createRc}).");
                        Console.WriteLine($"Check log: {createLog}");
                        return createRc;
                    }
                    Console.WriteLine("Tables created successfully.");
                    Console.WriteLine();
                }

                // Now handle table dropping for existing tables (if user wants to recreate them)
                var tablesToDrop = copyTargets.Where(t => existingTables.Contains(t)).ToList();

                if (tablesToDrop.Count > 0)
                {
                    Console.WriteLine("Existing non-normalized target tables: " + string.Join(", ", tablesToDrop));
                    Console.WriteLine();
                    Console.WriteLine("Options:");
                    Console.WriteLine("  1. Keep existing tables and purge data (migration script will DELETE existing rows)");
                    Console.WriteLine("  2. Drop and recreate tables (ensures clean schema)");
                    Console.WriteLine();
                    Console.Write("Enter choice (1 or 2) [default: 1]: ");
                    var choice = Console.ReadLine()?.Trim();

                    if (choice == "2")
                    {
                        Console.WriteLine("Dropping existing tables...");
                        // Drop non-normalized target tables (best-effort: drop FKs referencing them first)
                        using (var conn = new SqlConnection(sqlCs))
                        {
                            conn.Open();
                            foreach (var t in tablesToDrop)
                            {
                                try
                                {
                                    var sql = $@"DECLARE @sql NVARCHAR(MAX)=N''; 
SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(o.schema_id))+'.'+QUOTENAME(OBJECT_NAME(fk.parent_object_id)) + N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON t.object_id=fk.parent_object_id
JOIN sys.objects o ON o.object_id = fk.parent_object_id
WHERE fk.referenced_object_id = OBJECT_ID(N'[{t}]') OR fk.parent_object_id = OBJECT_ID(N'[{t}]');
IF LEN(ISNULL(@sql,N''))>0 EXEC sp_executesql @sql;
IF OBJECT_ID(N'[{t}]', N'U') IS NOT NULL DROP TABLE [{t}];";
                                    using (var cmd = conn.CreateCommand())
                                    {
                                        cmd.CommandTimeout = 0;
                                        cmd.CommandText = sql;
                                        cmd.ExecuteNonQuery();
                                        Console.WriteLine($"  Dropped: {t}");
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine($"  WARNING: Failed to drop {t}: {ex.Message}");
                                }
                            }
                        }

                        // ALWAYS recreate the dropped tables (not optional - migration will fail without tables!)
                        Console.WriteLine("Recreating tables (required for migration to succeed)...");
                        var recreateRc = DdlScriptApplier.ApplyLatest(_migrationsDir, sqlCs, out var recreateLog);
                        if (recreateRc != 0)
                        {
                            Console.WriteLine($"ERROR: Table recreation failed (rc={recreateRc}).");
                            Console.WriteLine($"Check log: {recreateLog}");
                            Console.WriteLine("Cannot proceed with migration without tables.");
                            return recreateRc;
                        }
                        Console.WriteLine("Tables recreated successfully.");
                        Console.WriteLine();
                    }
                    else
                    {
                        Console.WriteLine("Keeping existing tables. Migration script will DELETE and re-insert data.");
                        Console.WriteLine();
                    }
                }
                else if (copyTargets.Count == 0)
                {
                    Console.WriteLine("No non-normalized (copy) target tables found in CreateTables_LATEST.sql.");
                    Console.WriteLine("Proceeding with migration without table management.");
                    Console.WriteLine();
                }

                // Run the migration using the pre-generated UNNORMALIZED script
                Console.WriteLine("Starting migration...");
                Console.WriteLine();

                var rc = DmlScriptApplier.ApplyScript(_migrationsDir, sqlCs, unnormalizedPath, out var logPath, out var errorLogPath);

                Console.WriteLine();
                Console.WriteLine("Migration completed with return code: " + rc);
                Console.WriteLine("Detailed log: " + logPath);
                Console.WriteLine("Error log: " + errorLogPath);

                // Show summary of migration results
                if (rc == 0)
                {
                    Console.WriteLine();
                    Console.WriteLine("? Migration completed successfully!");
                    Console.WriteLine("Check the migration report in the log file for per-table details.");
                }
                else
                {
                    Console.WriteLine();
                    Console.WriteLine("? Migration completed with errors.");
                    Console.WriteLine("Review the error log for details on failed tables.");
                }

                return rc;
            }
            catch (Exception ex)
            {
                Console.WriteLine("? Apply UN-normalized migration failed: " + ex.Message);
                return 1;
            }
        }
    }
}
