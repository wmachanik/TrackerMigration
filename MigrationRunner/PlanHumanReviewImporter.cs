using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace MigrationRunner
{
    internal class PlanHumanReviewImporter
    {
        // Load the schema files and update them based on CSV plan mappings
        public static int ImportPlan(string migrationsDir, string csvPath, out string constraintsPath)
        {
            constraintsPath = null;
            Console.WriteLine($"?? Starting CSV import from: {csvPath}");

            // Debug: show what paths we're working with
            Console.WriteLine($"?? Input migrationsDir: {migrationsDir}");
            Console.WriteLine($"?? Current directory: {Directory.GetCurrentDirectory()}");


            var schemaDir = Path.Combine(migrationsDir, "Metadata", "AccessSchema");
            if (!Directory.Exists(schemaDir))
            {
                // Try to create the directory if it doesn't exist
                try
                {
                    Directory.CreateDirectory(schemaDir);
                    Console.WriteLine($"? Schema directory did not exist, created: {schemaDir}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"? Failed to create schema directory: {schemaDir} ({ex.Message})");
                    return 1;
                }
            }
            Console.WriteLine($"?? Schema directory: {schemaDir}");

            // List schema files for verification
            var schemaFiles = Directory.GetFiles(schemaDir, "*.schema.json");
            Console.WriteLine($"?? Found {schemaFiles.Length} schema files in directory:");
            foreach (var file in schemaFiles.Take(10))
            {
                Console.WriteLine($"    - {Path.GetFileName(file)}");
            }
            if (schemaFiles.Length > 10)
            {
                Console.WriteLine($"    ... and {schemaFiles.Length - 10} more");
            }
            if (schemaFiles.Length == 0)
            {
                Console.WriteLine("\nNo schema files found. You must run option 1 (Export Access schema) before importing the CSV.");
                Console.Write("Would you like to run option 1 now? [Y/n]: ");
                var resp = (System.Console.ReadLine() ?? "").Trim().ToLowerInvariant();
                if (resp == "" || resp == "y" || resp == "yes")
                {
                    // Try to run ExportAccessSchemaCommand directly
                    try
                    {
                        var configPath = System.IO.Path.Combine(migrationsDir, "MigrationConfig.json");
                        if (!File.Exists(configPath))
                        {
                            configPath = System.IO.Path.Combine(System.IO.Directory.GetParent(migrationsDir).FullName, "MigrationConfig.json");
                        }
                        var configJson = File.ReadAllText(configPath);
                        var config = Newtonsoft.Json.JsonConvert.DeserializeObject<MigrationConfig>(configJson);
                        var rc = new MigrationRunner.UI.ExportAccessSchemaCommand(migrationsDir, config).Execute();
                        if (rc != 0)
                        {
                            Console.WriteLine("Failed to export Access schema. Aborting import.");
                            return 1;
                        }
                        // Re-scan for schema files
                        schemaFiles = Directory.GetFiles(schemaDir, "*.schema.json");
                        if (schemaFiles.Length == 0)
                        {
                            Console.WriteLine("Still no schema files found after export. Aborting import.");
                            return 1;
                        }
                        Console.WriteLine($"Exported {schemaFiles.Length} schema files. Continuing import...\n");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Failed to run option 1 automatically: {ex.Message}");
                        return 1;
                    }
                }
                else
                {
                    Console.WriteLine("Aborting import. Please run option 1 manually and try again.");
                    return 1;
                }
            }

            // Parse CSV
            var tableMappings = ParseCsv(csvPath);
            if (tableMappings.Count == 0)
            {
                Console.WriteLine("? No table mappings found in CSV");
                return 1;
            }

            Console.WriteLine($"?? Parsed {tableMappings.Count} table mappings from CSV");
            Console.WriteLine();

            // Process each table mapping with validation
            int successCount = 0;
            int failCount = 0;
            var allConstraints = new List<ConstraintTable>();

            for (int i = 0; i < tableMappings.Count; i++)
            {
                var mapping = tableMappings[i];
                Console.WriteLine($"=== TABLE {i + 1}/{tableMappings.Count}: {mapping.BeforeTable} -> {mapping.AfterTable ?? "n/a"} (Action: {mapping.Action}) ===");

                // Validation step
                var validation = CsvValidator.ValidateTableMapping(mapping);
                if (!validation.IsValid)
                {
                    Console.WriteLine($"!! Validation failed for table mapping {i + 1}:");
                    foreach (var err in validation.Errors)
                        Console.WriteLine($"   - {err}");
                    failCount++;
                    Console.WriteLine();
                    continue;
                }

                try
                {
                    if (ProcessTableMapping(schemaDir, mapping, allConstraints))
                    {
                        successCount++;
                    }
                    else
                    {
                        failCount++;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"? Error processing table {mapping.BeforeTable}: {ex.Message}");
                    failCount++;
                }

                Console.WriteLine();
            }

            // Generate constraints file
            constraintsPath = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "PlanConstraints.json");
            Directory.CreateDirectory(Path.GetDirectoryName(constraintsPath));
            
            // SECOND PASS: Resolve FK reference columns by looking up the PK of each referenced table
            Console.WriteLine();
            Console.WriteLine("============================================================");
            Console.WriteLine("? SECOND PASS: Resolving FK reference columns...");
            Console.WriteLine("============================================================");
            ResolveForeignKeyReferences(allConstraints);
            
            var constraintsIndex = new ConstraintsIndex { Tables = allConstraints };
            var constraintsSummary = GenerateConstraintsSummary(allConstraints);
            
            File.WriteAllText(constraintsPath, JsonConvert.SerializeObject(constraintsIndex, Formatting.Indented));

            // ✅ ADD THIS LINE
            //GenerateMigrationScriptsPerTable(migrationsDir, allConstraints);  ->< that is option ">"


            // Final summary
            Console.WriteLine("============================================================");
            Console.WriteLine("?? FINAL SUMMARY");
            Console.WriteLine("============================================================");
            Console.WriteLine($"?? Total tables in CSV: {tableMappings.Count}");
            Console.WriteLine($"??  Tables ignored: {tableMappings.Count(m => m.Action.Equals("Ignore", StringComparison.OrdinalIgnoreCase))}");
            Console.WriteLine($"?? Tables processed: {successCount + failCount}");
            Console.WriteLine($"? Tables successful: {successCount}");
            Console.WriteLine($"? Tables failed: {failCount}");
            Console.WriteLine("============================================================");
            Console.WriteLine($"?? Constraints summary: {constraintsSummary}");
            Console.WriteLine($"?? Constraints JSON: {constraintsPath}");
            
            if (successCount > 0)
            {
                Console.WriteLine($"?? SUCCESS! {successCount} tables were successfully updated!");
            }
            else
            {
                Console.WriteLine("? No tables were successfully processed!");
            }

            Console.WriteLine();
            Console.WriteLine("?? CSV import completed!");

            return successCount > 0 ? 0 : 1;
        }

        private static bool ProcessTableMapping(string schemaDir, TableMapping mapping, List<ConstraintTable> constraints)
        {
            string schemaPath;
            if (!TryResolveSchemaPath(schemaDir, mapping.BeforeTable, out schemaPath))
            {
                Console.WriteLine($"    ? Schema file not found for table {mapping.BeforeTable}");
                return false;
            }

            TableSchema schema;
            try
            {
                schema = JsonConvert.DeserializeObject<TableSchema>(File.ReadAllText(schemaPath));
                if (schema == null)
                {
                    Console.WriteLine("    ? Failed to deserialize schema file");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"    ? Error parsing schema file: {ex.Message}");
                return false;
            }

            EnsurePlan(schema, mapping.BeforeTable);

            if (string.Equals(mapping.Action, "Ignore", StringComparison.OrdinalIgnoreCase))
            {
                Console.WriteLine($"??  Ignoring table '{mapping.BeforeTable}' as specified");
                schema.Plan.Ignore = true;
                SaveSchema(schemaPath, schema);
                return true;
            }

            Console.WriteLine($"?? Processing table '{mapping.BeforeTable}' -> '{mapping.AfterTable}'");

            schema.Plan.Ignore = false;
            schema.Plan.TargetTable = mapping.AfterTable ?? mapping.BeforeTable;
            schema.Plan.Classification = string.Equals(mapping.Action, "Normalize", StringComparison.OrdinalIgnoreCase)
                ? "Normalize"
                : string.Equals(mapping.Action, "Rename", StringComparison.OrdinalIgnoreCase)
                    ? "Rename"
                    : "Copy";

            if (string.Equals(schema.Plan.Classification, "Normalize", StringComparison.OrdinalIgnoreCase))
            {
                ApplyNormalizePlan(schema, mapping);
                schema.Plan.ColumnActions.RemoveAll(a => IsSyntheticSource(a.Source));
            }
            else
            {
                schema.Plan.Normalize = null;
            }

            int appliedMappings = 0;
            if (mapping.ColumnMappings?.Any() == true)
            {
                Console.WriteLine($"    ?? Processing {mapping.ColumnMappings.Count} column mappings:");
                foreach (var columnMapping in mapping.ColumnMappings)
                {
                    if (string.IsNullOrWhiteSpace(columnMapping.BeforeColumn))
                        continue;

                    var existing = schema.Plan.ColumnActions
                        .FirstOrDefault(a => string.Equals(a.Source, columnMapping.BeforeColumn, StringComparison.OrdinalIgnoreCase));

                    if (existing == null)
                    {
                        existing = new ColumnPlan
                        {
                            Source = columnMapping.BeforeColumn,
                            Target = columnMapping.BeforeColumn,
                            Action = "Copy"
                        };
                        schema.Plan.ColumnActions.Add(existing);
                    }

                    if (string.Equals(columnMapping.Action, "Drop", StringComparison.OrdinalIgnoreCase))
                    {
                        existing.Target = columnMapping.BeforeColumn;
                        existing.Action = "Drop";
                    }
                    else if (!string.IsNullOrWhiteSpace(columnMapping.AfterColumn))
                    {
                        existing.Target = columnMapping.AfterColumn;
                        existing.Action = NormalizeColumnAction(columnMapping.BeforeColumn, columnMapping.AfterColumn, columnMapping.Action);
                    }

                    appliedMappings++;
                }
            }

            Console.WriteLine($"    ? Applied {appliedMappings} column mappings");

            CreateConstraintsForTable(mapping, constraints);

            try
            {
                SaveSchema(schemaPath, schema);
                Console.WriteLine($"    ? Successfully saved schema: {mapping.BeforeTable} -> {schema.Plan.TargetTable}");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"    ? Error saving schema for {mapping.BeforeTable}: {ex.Message}");
                return false;
            }
        }

        private static void CreateConstraintsForTable(TableMapping mapping, List<ConstraintTable> constraints)
        {
            if (string.Equals(mapping.Action, "Ignore", StringComparison.OrdinalIgnoreCase))
                return;

            if (string.Equals(mapping.Action, "Normalize", StringComparison.OrdinalIgnoreCase) && mapping.NormalizationInfo != null)
            {
                var info = mapping.NormalizationInfo;
                var headerMappings = (mapping.ColumnMappings ?? new List<ColumnMapping>())
                    .Where(cm => string.Equals(cm.NormalizationTarget, "Header", StringComparison.OrdinalIgnoreCase))
                    .ToList();
                var lineMappings = (mapping.ColumnMappings ?? new List<ColumnMapping>())
                    .Where(cm => string.Equals(cm.NormalizationTarget, "Lines", StringComparison.OrdinalIgnoreCase))
                    .ToList();

                var headerTable = BuildConstraintTable(info.HeaderTable, headerMappings, info.HeaderPrimaryKey, info.NewHeaderKeyName);
                var lineTable = BuildConstraintTable(info.LinesTable, lineMappings, info.LinePrimaryKey, info.NewLineKeyName);

                var headerPk = headerTable.PrimaryKey.FirstOrDefault() ?? info.NewHeaderKeyName;
                if (!string.IsNullOrWhiteSpace(info.LineLinkKeyName) && !string.IsNullOrWhiteSpace(info.HeaderTable) && !string.IsNullOrWhiteSpace(headerPk))
                {
                    if (!lineTable.ForeignKeys.Any(fk => string.Equals(fk.Column, info.LineLinkKeyName, StringComparison.OrdinalIgnoreCase)))
                    {
                        lineTable.ForeignKeys.Add(new ForeignKeyDef
                        {
                            Column = info.LineLinkKeyName,
                            RefTable = info.HeaderTable,
                            RefColumn = headerPk
                        });
                    }

                    AddUnique(lineTable.NotNullColumns, info.LineLinkKeyName);
                }

                if (!string.IsNullOrWhiteSpace(headerTable.Table))
                {
                    constraints.Add(headerTable);
                    Console.WriteLine($"    ? Creating constraints for normalized header table: {headerTable.Table} PK={string.Join(", ", headerTable.PrimaryKey)}");
                }

                if (!string.IsNullOrWhiteSpace(lineTable.Table))
                {
                    constraints.Add(lineTable);
                    Console.WriteLine($"    ? Creating constraints for normalized line table: {lineTable.Table} PK={string.Join(", ", lineTable.PrimaryKey)}");
                }

                return;
            }

            var targetTable = BuildConstraintTable(mapping.AfterTable ?? mapping.BeforeTable, mapping.ColumnMappings ?? new List<ColumnMapping>(), null, null);
            if (!string.IsNullOrWhiteSpace(targetTable.Table))
            {
                constraints.Add(targetTable);
            }
        }

        private static ConstraintTable BuildConstraintTable(string tableName, IList<ColumnMapping> columnMappings, IList<string> explicitPrimaryKeys, string explicitIdentityKey)
        {
            var constraintTable = new ConstraintTable
            {
                Table = tableName,
                PrimaryKey = new List<string>(),
                IdentityColumns = new List<string>(),
                ForeignKeys = new List<ForeignKeyDef>(),
                NotNullColumns = new List<string>()
            };

            foreach (var pk in explicitPrimaryKeys ?? new List<string>())
                AddUnique(constraintTable.PrimaryKey, pk);

            if (!string.IsNullOrWhiteSpace(explicitIdentityKey))
                AddUnique(constraintTable.IdentityColumns, explicitIdentityKey);

            var mappings = columnMappings ?? new List<ColumnMapping>();
            foreach (var pkCol in mappings.Where(cm => cm.IsPrimaryKey && !string.IsNullOrWhiteSpace(cm.AfterColumn)))
            {
                AddUnique(constraintTable.PrimaryKey, pkCol.AfterColumn);
                if (pkCol.IsIdentity)
                    AddUnique(constraintTable.IdentityColumns, pkCol.AfterColumn);
            }

            if (constraintTable.PrimaryKey.Count == 0)
            {
                var idColumns = mappings
                    .Where(cm => !string.IsNullOrEmpty(cm.BeforeColumn) &&
                                 !string.IsNullOrEmpty(cm.AfterColumn) &&
                                 cm.BeforeColumn.EndsWith("ID", StringComparison.OrdinalIgnoreCase) &&
                                 !cm.IsForeignKey)
                    .ToList();

                var tableBaseName = (tableName ?? string.Empty).Replace("Tbl", "");
                // Use consistent 'Id' casing for generated PK names to match generated CREATE scripts
                var expectedPkName = tableBaseName.EndsWith("s", StringComparison.OrdinalIgnoreCase)
                    ? tableBaseName.TrimEnd('s') + "Id"
                    : tableBaseName + "Id";

                var pkColumn = idColumns.FirstOrDefault(cm => string.Equals(cm.AfterColumn, expectedPkName, StringComparison.OrdinalIgnoreCase)) ??
                               idColumns.FirstOrDefault(cm => string.Equals(cm.BeforeColumn, "ID", StringComparison.OrdinalIgnoreCase)) ??
                               idColumns.FirstOrDefault();

                if (pkColumn != null)
                {
                    AddUnique(constraintTable.PrimaryKey, pkColumn.AfterColumn);
                    AddUnique(constraintTable.IdentityColumns, pkColumn.AfterColumn);
                }
            }

            foreach (var fkCol in mappings.Where(cm => cm.IsForeignKey && !string.IsNullOrEmpty(cm.AfterColumn) && !string.IsNullOrEmpty(cm.ForeignKeyRefTable)))
            {
                if (!constraintTable.ForeignKeys.Any(fk => string.Equals(fk.Column, fkCol.AfterColumn, StringComparison.OrdinalIgnoreCase) &&
                                                           string.Equals(fk.RefTable, fkCol.ForeignKeyRefTable, StringComparison.OrdinalIgnoreCase)))
                {
                    constraintTable.ForeignKeys.Add(new ForeignKeyDef
                    {
                        Column = fkCol.AfterColumn,
                        RefTable = fkCol.ForeignKeyRefTable,
                        RefColumn = null
                    });
                }
            }

            foreach (var pk in constraintTable.PrimaryKey)
                AddUnique(constraintTable.NotNullColumns, pk);
            foreach (var id in constraintTable.IdentityColumns)
                AddUnique(constraintTable.NotNullColumns, id);

            return constraintTable;
        }

        private static void ResolveForeignKeyReferences(List<ConstraintTable> constraints)
        {
            // Build a lookup dictionary of table name -> primary key column
            var tablePkLookup = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            
            foreach (var constraint in constraints)
            {
                if (constraint.PrimaryKey != null && constraint.PrimaryKey.Count > 0)
                {
                    // For now, assume single-column PKs (composite PKs are rare in this schema)
                    tablePkLookup[constraint.Table] = constraint.PrimaryKey[0];
                }
            }
            
            Console.WriteLine($"Built PK lookup for {tablePkLookup.Count} tables");
            
            // Now resolve all FK reference columns
            int resolvedCount = 0;
            int unresolvedCount = 0;
            
            foreach (var constraint in constraints)
            {
                if (constraint.ForeignKeys == null || constraint.ForeignKeys.Count == 0)
                    continue;
                    
                foreach (var fk in constraint.ForeignKeys)
                {
                    if (fk.RefColumn == null && !string.IsNullOrEmpty(fk.RefTable))
                    {
                        if (tablePkLookup.TryGetValue(fk.RefTable, out var refPk))
                        {
                            fk.RefColumn = refPk;
                            resolvedCount++;
                            Console.WriteLine($"  ? Resolved FK: {constraint.Table}.{fk.Column} -> {fk.RefTable}.{refPk}");
                        }
                        else
                        {
                            // Fallback: try table name + "Id" pattern (use consistent casing)
                            var refTableBase = fk.RefTable.Replace("Tbl", "");
                            fk.RefColumn = refTableBase + "Id";
                            unresolvedCount++;
                            Console.WriteLine($"  ? FK fallback (table not found): {constraint.Table}.{fk.Column} -> {fk.RefTable}.{fk.RefColumn}");
                        }
                    }
                }
            }
            
            Console.WriteLine($"FK resolution complete: {resolvedCount} resolved, {unresolvedCount} used fallback");
        }
        private static string BuildMigrationScript(ConstraintTable table)
        {
            var sb = new StringBuilder();

            sb.AppendLine($"-- Migration for table [{table.Table}]");
            sb.AppendLine("BEGIN TRANSACTION;");
            sb.AppendLine();

            // Example: CREATE TABLE (basic)
            sb.AppendLine($"-- CREATE TABLE [{table.Table}] (");
            sb.AppendLine();

            // Primary Key
            if (table.PrimaryKey?.Any() == true)
            {
                sb.AppendLine($"-- PK: {string.Join(", ", table.PrimaryKey)}");
            }

            // Identity
            if (table.IdentityColumns?.Any() == true)
            {
                foreach (var id in table.IdentityColumns)
                {
                    sb.AppendLine($"-- Identity: {id}");
                }
            }

            // Foreign Keys
            if (table.ForeignKeys?.Any() == true)
            {
                foreach (var fk in table.ForeignKeys)
                {
                    sb.AppendLine($"-- FK: {fk.Column} -> {fk.RefTable}.{fk.RefColumn}");
                }
            }

            sb.AppendLine();
            sb.AppendLine("COMMIT;");
            return sb.ToString();
        }
        private static string Sanitize(string name)
        {
            foreach (var c in Path.GetInvalidFileNameChars())
                name = name.Replace(c, '_');

            return name;
        }
        private static void GenerateMigrationScriptsPerTable(string migrationsDir, List<ConstraintTable> constraints)
        {
            var outputDir = Path.Combine(migrationsDir, "Migrations", "PerTable");
            Directory.CreateDirectory(outputDir);

            foreach (var table in constraints)
            {
                if (string.IsNullOrWhiteSpace(table.Table))
                    continue;

                var fileName = $"Migration_{Sanitize(table.Table)}.sql";
                var fullPath = Path.Combine(outputDir, fileName);

                var script = BuildMigrationScript(table);

                File.WriteAllText(fullPath, script);

                Console.WriteLine($"    📄 Generated migration: {fileName}");
            }

            Console.WriteLine($"✅ Generated {constraints.Count} per-table migration scripts in: {outputDir}");
        }

        private static bool TryResolveSchemaPath(string schemaDir, string tableName, out string schemaPath)
        {
            schemaPath = null;
            if (string.IsNullOrWhiteSpace(schemaDir) || string.IsNullOrWhiteSpace(tableName))
                return false;

            var primaryPath = Path.Combine(schemaDir, tableName + ".schema.json");
            var fallbackPath = Path.Combine(schemaDir, tableName + ".json");

            Console.WriteLine("    ?? Looking for schema file:");
            Console.WriteLine("      Primary: " + primaryPath);
            Console.WriteLine("      Fallback: " + fallbackPath);

            if (File.Exists(primaryPath))
            {
                schemaPath = primaryPath;
                Console.WriteLine("    ? Found primary schema file");
                return true;
            }

            if (File.Exists(fallbackPath))
            {
                schemaPath = fallbackPath;
                Console.WriteLine("    ? Found fallback schema file");
                return true;
            }

            return false;
        }

        private static void EnsurePlan(TableSchema schema, string defaultTable)
        {
            if (schema.Plan == null)
            {
                schema.Plan = new TablePlan
                {
                    Classification = "Copy",
                    TargetTable = defaultTable,
                    Ignore = false,
                    ColumnActions = new List<ColumnPlan>()
                };
            }

            if (schema.Plan.ColumnActions == null)
                schema.Plan.ColumnActions = new List<ColumnPlan>();
        }

        private static void ApplyNormalizePlan(TableSchema schema, TableMapping mapping)
        {
            if (schema == null || schema.Plan == null || mapping?.NormalizationInfo == null)
                return;

            var info = mapping.NormalizationInfo;
            if (schema.Plan.Normalize == null)
                schema.Plan.Normalize = new NormalizePlan();

            schema.Plan.Normalize.HeaderTable = string.IsNullOrWhiteSpace(info.HeaderTable) ? (mapping.AfterTable ?? mapping.BeforeTable) : info.HeaderTable;
            schema.Plan.Normalize.LineTable = info.LinesTable;
            schema.Plan.Normalize.HeaderColumns = CloneList(info.HeaderColumns);
            schema.Plan.Normalize.LineColumns = CloneList(info.LineColumns);
            schema.Plan.Normalize.HeaderPrimaryKey = CloneList(info.HeaderPrimaryKey);
            schema.Plan.Normalize.LinePrimaryKey = CloneList(info.LinePrimaryKey);
            schema.Plan.Normalize.HeaderCalculations = CloneDictionary(info.HeaderCalculations);
            schema.Plan.Normalize.NewHeaderKeyName = info.NewHeaderKeyName;
            schema.Plan.Normalize.NewLineKeyName = info.NewLineKeyName;
            schema.Plan.Normalize.LineLinkKeyName = info.LineLinkKeyName;
            schema.Plan.Normalize.PreserveHeaderIds = info.PreserveHeaderIds;
            schema.Plan.Normalize.PreserveLineIds = info.PreserveLineIds;

            schema.Plan.TargetTable = schema.Plan.Normalize.HeaderTable ?? schema.Plan.TargetTable;

            Console.WriteLine($"    ?? Setting up normalization: {mapping.BeforeTable} -> {schema.Plan.Normalize.HeaderTable} + {schema.Plan.Normalize.LineTable}");
            Console.WriteLine($"    ?? Normalization setup complete, table will be handled by custom normalizer");
        }

        private static List<string> CloneList(IEnumerable<string> values)
        {
            var list = new List<string>();
            if (values == null)
                return list;

            foreach (var value in values)
                AddUnique(list, value);

            return list;
        }

        private static Dictionary<string, string> CloneDictionary(IDictionary<string, string> values)
        {
            var dictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            if (values == null)
                return dictionary;

            foreach (var pair in values)
            {
                if (string.IsNullOrWhiteSpace(pair.Key))
                    continue;

                dictionary[pair.Key] = pair.Value;
            }

            return dictionary;
        }

        private static string NormalizeColumnAction(string beforeColumn, string afterColumn, string action)
        {
            if (string.Equals(action, "Drop", StringComparison.OrdinalIgnoreCase))
                return "Drop";

            if (!string.IsNullOrWhiteSpace(action) &&
                !string.Equals(action, "New", StringComparison.OrdinalIgnoreCase) &&
                !string.Equals(action, "LinkFK", StringComparison.OrdinalIgnoreCase))
            {
                return action;
            }

            return string.Equals(beforeColumn, afterColumn, StringComparison.OrdinalIgnoreCase) ? "Copy" : "Rename";
        }

        private static void SaveSchema(string schemaPath, TableSchema schema)
        {
            File.WriteAllText(schemaPath, JsonConvert.SerializeObject(schema, Formatting.Indented));
        }

        private static void AddUnique(List<string> values, string value)
        {
            if (values == null || string.IsNullOrWhiteSpace(value))
                return;

            if (!values.Any(v => string.Equals(v, value, StringComparison.OrdinalIgnoreCase)))
                values.Add(value);
        }

        private static bool IsYes(string value)
        {
            return !string.IsNullOrWhiteSpace(value) && value.Trim().StartsWith("y", StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsSyntheticSource(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return true;

            var trimmed = value.Trim();
            return string.Equals(trimmed, "new", StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(trimmed, "n/a", StringComparison.OrdinalIgnoreCase);
        }

        private static string ParseForeignKeyTable(string keyValue)
        {
            if (string.IsNullOrWhiteSpace(keyValue))
                return null;

            var match = System.Text.RegularExpressions.Regex.Match(keyValue, @"FK\s*\(([^)]+)\)");
            return match.Success ? match.Groups[1].Value.Trim() : null;
        }

        private static ColumnMapping CreateColumnMapping(string beforeColumn, string afterColumn, string action, string targetLocation, bool isPrimaryKey, bool isIdentity, string foreignKeyRefTable)
        {
            return new ColumnMapping
            {
                BeforeColumn = beforeColumn,
                AfterColumn = afterColumn,
                Action = NormalizeColumnAction(beforeColumn, afterColumn, action),
                NormalizationTarget = targetLocation,
                IsPrimaryKey = isPrimaryKey,
                IsIdentity = isIdentity,
                IsForeignKey = !string.IsNullOrWhiteSpace(foreignKeyRefTable),
                ForeignKeyRefTable = foreignKeyRefTable
            };
        }

        private static bool IsCalcExpression(string value)
        {
            return !string.IsNullOrWhiteSpace(value) && value.TrimStart().StartsWith("Calc:", StringComparison.OrdinalIgnoreCase);
        }

        private static string ExtractCalcExpression(string value)
        {
            if (!IsCalcExpression(value))
                return value ?? string.Empty;

            return value.Substring(value.IndexOf(':') + 1).Trim();
        }

        private static string GenerateConstraintsSummary(List<ConstraintTable> constraints)
        {
            var tables = constraints.Count;
            var pkCols = constraints.SelectMany(c => c.PrimaryKey).Count();
            var identityCols = constraints.SelectMany(c => c.IdentityColumns).Count();
            var fks = constraints.SelectMany(c => c.ForeignKeys).Count();
            var notNullCols = constraints.SelectMany(c => c.NotNullColumns).Count();

            return $"Tables={tables}, PKCols={pkCols}, IdentityCols={identityCols}, FKs={fks}, NotNullCols={notNullCols}";
        }

        public static List<TableMapping> ParseCsv(string csvPath)
        {
            var lines = File.ReadAllLines(csvPath);
            var mappings = new List<TableMapping>();

            if (lines.Length == 0) return mappings;

            Console.WriteLine($"?? Parsing CSV with {lines.Length} total lines");

            for (int i = 0; i < lines.Length; i++)
            {
                var line = lines[i].Trim();
                
                // Skip empty lines and report headers
                if (string.IsNullOrEmpty(line) || line.StartsWith("Table Migration report:") || line.StartsWith("====") || line.StartsWith("-------"))
                    continue;

                Console.WriteLine($"?? Processing line {i + 1}: {line.Substring(0, Math.Min(80, line.Length))}...");

                // Handle normalization section differently
                if (line.StartsWith("Table:,Before,After Header Tbl,After Lines Tbl,Action"))
                {
                    Console.WriteLine($"?? Found NORMALIZATION section at line {i + 1}");
                    
                    // Move to next line to find the table data
                    i++;
                    if (i >= lines.Length) continue;
                    
                    var tableDataLine = lines[i].Trim();
                    Console.WriteLine($"?? Next line: {tableDataLine}");
                    
                    // Process the table data line (starts with "=====")
                    if (tableDataLine.StartsWith("====="))
                    {
                        Console.WriteLine($"??   Processing table data line: {tableDataLine.Substring(0, Math.Min(80, tableDataLine.Length))}...");
                        
                        var normParts = ParseCsvLine(tableDataLine);
                        if (normParts.Length >= 5)
                        {
                            var beforeTable = normParts[1]?.Trim();
                            var afterHeaderTable = normParts[2]?.Trim();
                            var afterLinesTable = normParts[3]?.Trim();
                            var action = normParts[4]?.Trim();
                            
                            Console.WriteLine($"??   Parsed: Before={beforeTable}, HeaderTbl={afterHeaderTable}, LinesTbl={afterLinesTable}, Action={action}");
                            
                            if (!string.IsNullOrEmpty(beforeTable) && 
                                string.Equals(action, "Normalise", StringComparison.OrdinalIgnoreCase))
                            {
                                Console.WriteLine($"?? Found normalization: {beforeTable} -> {afterHeaderTable} + {afterLinesTable}");
                                
                                var mapping = new TableMapping
                                {
                                    BeforeTable = beforeTable,
                                    AfterTable = afterHeaderTable, // Use header table as the target table name
                                    Action = "Normalize",
                                    ColumnMappings = new List<ColumnMapping>(),
                                    NormalizationInfo = new NormalizationMapping
                                    {
                                        HeaderTable = afterHeaderTable,
                                        LinesTable = afterLinesTable
                                    }
                                };
                                
                                // Parse normalization column mappings
                                i = ParseNormalizationColumns(lines, i, mapping);
                                mappings.Add(mapping);
                                
                                Console.WriteLine($"?? Added normalization mapping for {beforeTable}");
                            }
                        }
                    }
                    continue; // Continue to process more sections instead of breaking
                }
                // Look for standard table definition lines: "Table,Before,After,Action"
                else if (line.StartsWith("Table,Before,After,Action"))
                {
                    // Parse the table section
                    i++; // Move to next line (the actual table data)
                    if (i >= lines.Length) break;
                    
                    var tableDataLine = lines[i].Trim();
                    if (string.IsNullOrEmpty(tableDataLine)) continue;
                    
                    var tableParts = ParseCsvLine(tableDataLine);
                    if (tableParts.Length < 4) continue;
                    
                    var beforeTable = tableParts[1]?.Trim(); // Skip first empty column
                    var afterTable = tableParts[2]?.Trim();
                    var action = tableParts[3]?.Trim();
                    
                    if (string.IsNullOrEmpty(beforeTable)) continue;
                    
                    // Clean up AfterTable
                    if (string.IsNullOrEmpty(afterTable) || string.Equals(afterTable, "n/a", StringComparison.OrdinalIgnoreCase))
                    {
                        afterTable = null;
                    }
                    
                    // Default action if empty
                    if (string.IsNullOrEmpty(action))
                    {
                        action = "Copy";
                    }
                    
                    var mapping = new TableMapping
                    {
                        BeforeTable = beforeTable,
                        AfterTable = afterTable,
                        Action = action,
                        ColumnMappings = new List<ColumnMapping>()
                    };
                    
                    Console.WriteLine($"?? Found table: {beforeTable} -> {afterTable ?? "same"} ({action})");
                    
                    // Now look for the column mappings that follow
                    i++; // Move to next line
                    if (i < lines.Length)
                    {
                        var columnHeaderLine = lines[i].Trim();
                        
                        // Check if this is a column definition section
                        if (columnHeaderLine.StartsWith("Rows:,Before Col name"))
                        {
                            Console.WriteLine($"    ?? Found column section for {beforeTable}");
                            
                            // Parse all column mappings for this table
                            i++; // Move to first column data line
                            int columnCount = 0;
                            
                            while (i < lines.Length)
                            {
                                var columnLine = lines[i].Trim();
                                
                                // Stop when we hit a section separator or another table
                                if (string.IsNullOrEmpty(columnLine) || 
                                    columnLine.StartsWith("------") ||
                                    columnLine.StartsWith("Table,Before,After,Action") ||
                                    columnLine.StartsWith("Table:,"))
                                {
                                    break;
                                }
                                
                                // Parse column mapping
                                var columnParts = ParseCsvLine(columnLine);
                                if (columnParts.Length >= 13) // We need at least 13 columns to get the Action and Source
                                {
                                    var beforeCol = columnParts[1]?.Trim(); // Before Col name
                                    var afterCol = columnParts[6]?.Trim();  // After Col Name
                                    var afterKey = columnParts[8]?.Trim();  // After Key (PK, FK, No)
                                    var afterAuto = columnParts[9]?.Trim(); // After Auto (Yes/No)
                                    var colAction = columnParts[12]?.Trim(); // Action

                                    // IMPROVED: Try different column positions for Action if standard position is empty
                                    if (string.IsNullOrEmpty(colAction) && columnParts.Length > 12)
                                    {
                                        // Check other common positions for the Action column
                                        for (int actionIndex = 11; actionIndex < Math.Min(columnParts.Length, 16); actionIndex++)
                                        {
                                            var potentialAction = columnParts[actionIndex]?.Trim();
                                            if (!string.IsNullOrEmpty(potentialAction) && 
                                                (string.Equals(potentialAction, "Drop", StringComparison.OrdinalIgnoreCase) ||
                                                 string.Equals(potentialAction, "Copy", StringComparison.OrdinalIgnoreCase) ||
                                                 string.Equals(potentialAction, "Rename", StringComparison.OrdinalIgnoreCase)))
                                            {
                                                colAction = potentialAction;
                                                Console.WriteLine($"        ??? Found Action '{colAction}' at column index {actionIndex}");
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if (!string.IsNullOrEmpty(beforeCol))
                                    {
                                        // Handle dropped columns (empty after column OR explicit Drop action)
                                        if (string.IsNullOrEmpty(afterCol) || string.Equals(colAction, "Drop", StringComparison.OrdinalIgnoreCase))
                                        {
                                            colAction = "Drop";
                                            afterCol = null; // Ensure afterCol is null for dropped columns
                                            Console.WriteLine($"        ??? Detected DROP column: {beforeCol} (afterCol empty or explicit Drop action)");
                                        }
                                        
                                        // Default column action
                                        if (string.IsNullOrEmpty(colAction))
                                        {
                                            colAction = string.Equals(beforeCol, afterCol, StringComparison.OrdinalIgnoreCase) ? "Copy" : "Rename";
                                        }
                                        
                                        // Detect primary key, identity, and foreign key from CSV
                                        var isPrimaryKey = string.Equals(afterKey, "PK", StringComparison.OrdinalIgnoreCase);
                                        var isIdentity = string.Equals(afterAuto, "Yes", StringComparison.OrdinalIgnoreCase);
                                        var isForeignKey = (afterKey ?? "").StartsWith("FK", StringComparison.OrdinalIgnoreCase);
                                        string fkRefTable = null;
                                        
                                        if (isForeignKey)
                                        {
                                            // Parse FK (TableName) from afterKey - extract table name between parentheses
                                            var match = System.Text.RegularExpressions.Regex.Match(afterKey, @"FK\s*\(([^)]+)\)");
                                            if (match.Success)
                                            {
                                                fkRefTable = match.Groups[1].Value.Trim();
                                            }
                                        }
                                        
                                        var columnMapping = new ColumnMapping
                                        {
                                            BeforeColumn = beforeCol,
                                            AfterColumn = afterCol,
                                            Action = colAction,
                                            IsPrimaryKey = isPrimaryKey,
                                            IsIdentity = isIdentity,
                                            IsForeignKey = isForeignKey,
                                            ForeignKeyRefTable = fkRefTable
                                        };
                                        
                                        mapping.ColumnMappings.Add(columnMapping);
                                        columnCount++;

                                        var pkMarker = isPrimaryKey ? " [PK]" : "";
                                        var identityMarker = isIdentity ? " [IDENTITY]" : "";
                                        var fkMarker = isForeignKey ? $" [FK->{fkRefTable}]" : "";
                                        Console.WriteLine($"      ? Column: {beforeCol} -> {afterCol ?? "DROP"} ({colAction}){pkMarker}{identityMarker}{fkMarker}");
                                    }
                                    // Handle NEW columns (no before column, but has after column)
                                    else if (!string.IsNullOrEmpty(afterCol))
                                    {
                                        if (string.IsNullOrEmpty(colAction))
                                            colAction = "New";
                                        
                                        // Detect primary key, identity, and foreign key from CSV
                                        var isPrimaryKey = string.Equals(afterKey, "PK", StringComparison.OrdinalIgnoreCase);
                                        var isIdentity = string.Equals(afterAuto, "Yes", StringComparison.OrdinalIgnoreCase);
                                        var isForeignKey = (afterKey ?? "").StartsWith("FK", StringComparison.OrdinalIgnoreCase);
                                        string fkRefTable = null;
                                        
                                        if (isForeignKey)
                                        {
                                            // Parse FK (TableName) from afterKey
                                            var match = System.Text.RegularExpressions.Regex.Match(afterKey, @"FK\s*\(([^)]+)\)");
                                            if (match.Success)
                                            {
                                                fkRefTable = match.Groups[1].Value.Trim();
                                            }
                                        }
                                        
                                        var columnMapping = new ColumnMapping
                                        {
                                            BeforeColumn = afterCol,  // Use target name as source for NEW columns
                                            AfterColumn = afterCol,
                                            Action = colAction,
                                            IsPrimaryKey = isPrimaryKey,
                                            IsIdentity = isIdentity,
                                            IsForeignKey = isForeignKey,
                                            ForeignKeyRefTable = fkRefTable
                                        };
                                        
                                        mapping.ColumnMappings.Add(columnMapping);
                                        columnCount++;
                                        
                                        var pkMarker = isPrimaryKey ? " [PK]" : "";
                                        var identityMarker = isIdentity ? " [IDENTITY]" : "";
                                        var fkMarker = isForeignKey ? $" [FK->{fkRefTable}]" : "";
                                        Console.WriteLine($"      ? NEW Column: {afterCol} ({colAction}){pkMarker}{identityMarker}{fkMarker}");
                                    }
                                }
                                
                                i++;
                            }
                            
                            Console.WriteLine($"    ?? Added {columnCount} column mappings for {beforeTable}");
                            i--; // Back up one since the outer loop will increment
                        }
                    }
                    
                    mappings.Add(mapping);
                }
            }

            Console.WriteLine($"?? Successfully parsed {mappings.Count} table mappings from CSV");
            
            // Summary of what we found
            var ignoredCount = mappings.Count(m => string.Equals(m.Action, "Ignore", StringComparison.OrdinalIgnoreCase));
            var renamedCount = mappings.Count(m => string.Equals(m.Action, "Rename", StringComparison.OrdinalIgnoreCase));
            var copiedCount = mappings.Count(m => string.Equals(m.Action, "Copy", StringComparison.OrdinalIgnoreCase));
            var normalizedCount = mappings.Count(m => string.Equals(m.Action, "Normalize", StringComparison.OrdinalIgnoreCase));
            var totalColumns = mappings.Sum(m => m.ColumnMappings?.Count ?? 0);
            
            Console.WriteLine($"?? Summary: {ignoredCount} ignored, {renamedCount} renamed, {copiedCount} copied, {normalizedCount} normalized, {totalColumns} column mappings");
            
            return mappings;
        }

        private static int ParseNormalizationColumns(string[] lines, int currentIndex, TableMapping mapping)
        {
            int i = currentIndex + 1;
            if (mapping.NormalizationInfo == null)
            {
                mapping.NormalizationInfo = new NormalizationMapping();
            }
            
            // Look for the header line with column definitions
            while (i < lines.Length)
            {
                var line = lines[i].Trim();
                
                if (line.StartsWith("Rows:,Before Col name"))
                {
                    Console.WriteLine($"    ?? Found normalization column section");
                    i++; // Move to first data row
                    break;
                }
                
                if (string.IsNullOrEmpty(line) || line.StartsWith("Table"))
                {
                    return i - 1; // No column section found
                }
                
                i++;
            }
            
            int columnCount = 0;
            
            // Parse normalization column mappings
            while (i < lines.Length)
            {
                var line = lines[i].Trim();
                
                // Stop at section separators or new tables
                if (string.IsNullOrEmpty(line) || 
                    line.StartsWith("------") ||
                    line.StartsWith("Table"))
                {
                    break;
                }
                
                var parts = ParseCsvLine(line);
                if (parts.Length >= 23) // Normalization has more columns
                {
                    var beforeCol = parts[1]?.Trim();
                    var headerCol = parts[6]?.Trim();
                    var headerKey = parts[8]?.Trim();
                    var headerAuto = parts[9]?.Trim();
                    var headerPreserve = parts[11]?.Trim();
                    var headerAction = parts[12]?.Trim();
                    var headerSource = parts[13]?.Trim();
                    var linesCol = parts[15]?.Trim();

                    var lineKey = parts[17]?.Trim();
                    var lineAuto = parts[18]?.Trim();
                    var linePreserve = parts[20]?.Trim();
                    var lineAction = parts[21]?.Trim();
                    var lineSource = parts[22]?.Trim();

                    if (!string.IsNullOrWhiteSpace(headerCol))
                    {
                        AddUnique(mapping.NormalizationInfo.HeaderPrimaryKey,
                            string.Equals(headerKey, "PK", StringComparison.OrdinalIgnoreCase) ? headerCol : null);

                        if (string.Equals(headerKey, "PK", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(mapping.NormalizationInfo.NewHeaderKeyName))
                        {
                            mapping.NormalizationInfo.NewHeaderKeyName = headerCol;
                        }

                        if (IsYes(headerPreserve))
                        {
                            mapping.NormalizationInfo.PreserveHeaderIds = true;
                        }

                        if (IsCalcExpression(headerSource))
                        {
                            AddUnique(mapping.NormalizationInfo.HeaderColumns, beforeCol);
                            mapping.NormalizationInfo.HeaderCalculations[headerCol] = ExtractCalcExpression(headerSource);
                            Console.WriteLine($"      ?? Normalization calc: {headerCol} = {mapping.NormalizationInfo.HeaderCalculations[headerCol]}");
                        }
                    }

                    if (!string.IsNullOrWhiteSpace(linesCol))
                    {
                        AddUnique(mapping.NormalizationInfo.LinePrimaryKey,
                            string.Equals(lineKey, "PK", StringComparison.OrdinalIgnoreCase) ? linesCol : null);

                        if (string.Equals(lineKey, "PK", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(mapping.NormalizationInfo.NewLineKeyName))
                        {
                            mapping.NormalizationInfo.NewLineKeyName = linesCol;
                        }

                        if (IsYes(linePreserve))
                        {
                            mapping.NormalizationInfo.PreserveLineIds = true;
                        }

                        var fkRefTable = ParseForeignKeyTable(lineKey);
                        if ((lineKey ?? string.Empty).StartsWith("FK", StringComparison.OrdinalIgnoreCase) &&
                            (string.Equals(fkRefTable, mapping.NormalizationInfo.HeaderTable, StringComparison.OrdinalIgnoreCase) ||
                             string.Equals(fkRefTable, "Header", StringComparison.OrdinalIgnoreCase) ||
                             string.Equals(lineAction, "LinkFK", StringComparison.OrdinalIgnoreCase)))
                        {
                            mapping.NormalizationInfo.LineLinkKeyName = linesCol;
                        }
                    }

                    if (!IsSyntheticSource(beforeCol))
                    {
                        if (!string.IsNullOrWhiteSpace(headerCol))
                        {
                            AddUnique(mapping.NormalizationInfo.HeaderColumns, beforeCol);

                            if (!IsCalcExpression(headerSource))
                            {
                                mapping.ColumnMappings.Add(CreateColumnMapping(
                                    beforeCol,
                                    headerCol,
                                    headerAction,
                                    "Header",
                                    string.Equals(headerKey, "PK", StringComparison.OrdinalIgnoreCase),
                                    IsYes(headerAuto),
                                    ParseForeignKeyTable(headerKey)));

                                columnCount++;
                                Console.WriteLine($"      ?? Normalization column: {beforeCol} -> {headerCol} (Header)");
                            }
                        }

                        if (!string.IsNullOrWhiteSpace(linesCol))
                        {
                            AddUnique(mapping.NormalizationInfo.LineColumns, beforeCol);

                            mapping.ColumnMappings.Add(CreateColumnMapping(
                                beforeCol,
                                linesCol,
                                lineAction,
                                "Lines",
                                string.Equals(lineKey, "PK", StringComparison.OrdinalIgnoreCase),
                                IsYes(lineAuto),
                                ParseForeignKeyTable(lineKey)));

                            columnCount++;
                            Console.WriteLine($"      ?? Normalization column: {beforeCol} -> {linesCol} (Lines)");
                        }
                    }
                }
                
                i++;
            }
            
            Console.WriteLine($"    ?? Added {columnCount} normalization column mappings");
            
            return i - 1;
        }

        private static string[] ParseCsvLine(string line)
        {
            var values = new List<string>();
            var inQuotes = false;
            var currentValue = "";

            for (int i = 0; i < line.Length; i++)
            {
                var c = line[i];
                
                if (c == '"')
                {
                    if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                    {
                        currentValue += '"';
                        i++; // Skip next quote
                    }
                    else
                    {
                        inQuotes = !inQuotes;
                    }
                }
                else if (c == ',' && !inQuotes)
                {
                    values.Add(currentValue);
                    currentValue = "";
                }
                else
                {
                    currentValue += c;
                }
            }

            values.Add(currentValue);
            return values.ToArray();
        }

        // This method is called by the Menu system
        public static int Import(string migrationsDir, string csvPath, out string planLogPath)
        {
            return ImportPlan(migrationsDir, csvPath, out planLogPath);
        }
    }

    public class TableMapping
    {
        public string BeforeTable { get; set; }
        public string AfterTable { get; set; }
        public string Action { get; set; }
        public List<ColumnMapping> ColumnMappings { get; set; }
        public NormalizationMapping NormalizationInfo { get; set; }
    }

    public class ColumnMapping
    {
        public string BeforeColumn { get; set; }
        public string AfterColumn { get; set; }
        public string Action { get; set; }
        public string NormalizationTarget { get; set; } // "Header" or "Lines"
        public bool IsPrimaryKey { get; set; }
        public bool IsIdentity { get; set; }
        public bool IsForeignKey { get; set; }
        public string ForeignKeyRefTable { get; set; }  // The referenced table name from FK (TableName)
    }

    public class NormalizationMapping
    {
        public string HeaderTable { get; set; }
        public string LinesTable { get; set; }
        public List<string> HeaderColumns { get; set; } = new List<string>();
        public List<string> LineColumns { get; set; } = new List<string>();
        public List<string> HeaderPrimaryKey { get; set; } = new List<string>();
        public List<string> LinePrimaryKey { get; set; } = new List<string>();
        public Dictionary<string, string> HeaderCalculations { get; set; } = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        public string NewHeaderKeyName { get; set; }
        public string NewLineKeyName { get; set; }
        public string LineLinkKeyName { get; set; }
        public bool PreserveHeaderIds { get; set; }
        public bool PreserveLineIds { get; set; }
    }
}
