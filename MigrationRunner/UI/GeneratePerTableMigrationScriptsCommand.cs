using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json;

namespace MigrationRunner.UI
{
    internal sealed class GeneratePerTableMigrationScriptsCommand : IMenuCommand
    {
        private readonly string _migrationsDir;
        private readonly bool _skipOverwritePrompt;

        public string Key => ">";
        public string Description => "Generate per-table migration scripts (Migrate_[TableName].sql)";

        public GeneratePerTableMigrationScriptsCommand(string migrationsDir, bool skipOverwritePrompt = false)
        {
            _migrationsDir = migrationsDir;
            _skipOverwritePrompt = skipOverwritePrompt;
        }

        string GetCorrectCSV(string csvDir)
        {
            var files = Directory.EnumerateFiles(csvDir, "*.csv", SearchOption.TopDirectoryOnly)
                     .Select(f => new FileInfo(f))
                     .OrderByDescending(fi => fi.LastWriteTimeUtc)
                     .ToList();

            string csvPath = null;

            if (files.Count == 0)
            {
                Console.WriteLine("No CSV files found in: " + csvDir);
                Console.Write("Enter full path to CSV (or blank to cancel): ");
                var manual = Console.ReadLine();

                if (string.IsNullOrWhiteSpace(manual))
                    return "";

                csvPath = manual.Trim();

                if (!File.Exists(csvPath))
                {
                    Console.WriteLine("File not found.");
                    return "";
                }
            }
            else
            {
                Console.WriteLine();
                Console.WriteLine("Available CSVs (newest first):");

                for (int i = 0; i < files.Count; i++)
                {
                    var fi = files[i];
                    Console.WriteLine($"  {i + 1}. {fi.Name} [{fi.LastWriteTime:yyyy-MM-dd HH:mm}]");
                }

                Console.Write("Select file [1]: ");
                var input = Console.ReadLine();

                int index = 0;
                if (!string.IsNullOrWhiteSpace(input))
                {
                    if (!int.TryParse(input, out var n) || n < 1 || n > files.Count)
                    {
                        Console.WriteLine("Invalid selection.");
                        return "";
                    }
                    index = n - 1;
                }

                csvPath = files[index].FullName;
            }

            return csvPath;
        }
        public int Execute()
        {
            var csvDir = Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Csv");
            var latestCsv = GetCorrectCSV(csvDir);
            if (string.IsNullOrEmpty(latestCsv) || !File.Exists(latestCsv))
            {
                Console.WriteLine("ERROR: No TableMigrationReport-*.csv file found in " + csvDir);
                return 1;
            }
            var csvPath = latestCsv;
            var sqlDir = Path.Combine(_migrationsDir, "Metadata", "PlanEdits", "Sql");
            Directory.CreateDirectory(sqlDir);

            var oldScripts = Directory.GetFiles(sqlDir, "Migrate_*.sql", SearchOption.TopDirectoryOnly);
            if (oldScripts.Length > 0 && !_skipOverwritePrompt)
            {
                Console.WriteLine($"Found {oldScripts.Length} existing Migrate_*.sql file(s).");
                if (!ScriptOverwritePrompt.ConfirmRegenerate("per-table migration scripts (Migrate_*.sql) — ALL existing Migrate scripts will be deleted first"))
                {
                    Console.WriteLine("Per-table migration generation cancelled — existing scripts unchanged.");
                    return 0;
                }
            }

            // Delete all existing per-table migration scripts before generating new ones
            foreach (var old in oldScripts)
            {
                try { File.Delete(old); } catch { /* ignore errors */ }
            }
            var mappings = PlanHumanReviewImporter.ParseCsv(csvPath);

            var actionableTables = mappings
                .Where(m =>
                    !string.IsNullOrWhiteSpace(m.BeforeTable) &&
                    !string.IsNullOrWhiteSpace(m.AfterTable) &&
                    !string.Equals(m.Action, "Ignore", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(m.Action, "Normalize", StringComparison.OrdinalIgnoreCase))
                .Select(m => (Before: m.BeforeTable, After: m.AfterTable, Action: m.Action))
                .ToList();

            int count = 0;
            var schemaDir = Path.Combine(_migrationsDir, "Metadata", "AccessSchema");

            foreach (var (before, after, action) in actionableTables)
            {
                if (string.IsNullOrWhiteSpace(before) || string.IsNullOrWhiteSpace(after))
                    continue;

                var schemaFile = Path.Combine(schemaDir, before + ".schema.json");

                if (!File.Exists(schemaFile))
                {
                    Console.WriteLine($"⚠️ Schema not found: {before}");
                    continue;
                }

                try
                {
                    var json = File.ReadAllText(schemaFile);
                    var schema = JsonConvert.DeserializeObject<TableSchema>(json);

                    if (schema?.Plan == null)
                    {
                        Console.WriteLine($"⚠️ Missing plan for: {before}");
                        continue;
                    }

                    var tableName = Sanitize(after);

                    var scriptPath = Path.Combine(sqlDir, $"Migrate_{tableName}.sql");

                    var script = DmlScriptGenerator.GenerateSingleTableScript(
                        _migrationsDir,
                        schema,
                        tableName);

                    File.WriteAllText(scriptPath, script);

                    Console.WriteLine($"✅ Generated: {scriptPath}");
                    count++;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"❌ Error generating script for {before}: {ex.Message}");
                }
            }
            Console.WriteLine($"Generated {count} scripts from {actionableTables.Count} tables.");
            return 0;
        }
        private static string Sanitize(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return name;

            foreach (var c in Path.GetInvalidFileNameChars())
                name = name.Replace(c, '_');

            return name.Trim();
        }
    }
}
