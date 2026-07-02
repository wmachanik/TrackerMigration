using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace MigrationRunner
{
    internal static class MigrationTableOrderer
    {
        /// <summary>
        /// Order migrate target tables so referenced (parent) tables load before dependents.
        /// Uses AddForeignKeys_*.sql when available; falls back to alphabetical.
        /// </summary>
        public static List<string> OrderByForeignKeyDependencies(string migrationsDir, IEnumerable<string> tables)
        {
            var tableList = (tables ?? Enumerable.Empty<string>())
                .Where(t => !string.IsNullOrWhiteSpace(t))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            if (tableList.Count <= 1)
                return tableList;

            var deps = BuildDependencyMap(migrationsDir, tableList);
            return TopologicalSort(tableList, deps);
        }

        private static Dictionary<string, HashSet<string>> BuildDependencyMap(string migrationsDir, List<string> tables)
        {
            var tableSet = new HashSet<string>(tables, StringComparer.OrdinalIgnoreCase);
            var deps = tables.ToDictionary(
                t => t,
                t => new HashSet<string>(StringComparer.OrdinalIgnoreCase),
                StringComparer.OrdinalIgnoreCase);

            var sqlDir = Path.Combine(migrationsDir, "Metadata", "PlanEdits", "Sql");
            if (!Directory.Exists(sqlDir))
                return deps;

            var fkFile = Directory.EnumerateFiles(sqlDir, "AddForeignKeys_*.sql", SearchOption.TopDirectoryOnly)
                .Select(p => new FileInfo(p))
                .OrderByDescending(fi => fi.LastWriteTimeUtc)
                .Select(fi => fi.FullName)
                .FirstOrDefault();

            if (string.IsNullOrWhiteSpace(fkFile) || !File.Exists(fkFile))
                return deps;

            var fkSql = File.ReadAllText(fkFile);
            var rx = new Regex(
                @"ALTER\s+TABLE\s+(?:\[(?<childSchema>[^\]]+)\]\.)?\[(?<child>[^\]]+)\][\s\S]*?REFERENCES\s+(?:\[(?<parentSchema>[^\]]+)\]\.)?\[(?<parent>[^\]]+)\]",
                RegexOptions.IgnoreCase);

            foreach (Match match in rx.Matches(fkSql))
            {
                var child = match.Groups["child"]?.Value?.Trim();
                var parent = match.Groups["parent"]?.Value?.Trim();
                if (string.IsNullOrWhiteSpace(child) || string.IsNullOrWhiteSpace(parent))
                    continue;
                if (!tableSet.Contains(child))
                    continue;
                if (tableSet.Contains(parent) &&
                    !string.Equals(parent, child, StringComparison.OrdinalIgnoreCase))
                {
                    deps[child].Add(parent);
                }
            }

            return deps;
        }

        private static List<string> TopologicalSort(List<string> tables, Dictionary<string, HashSet<string>> deps)
        {
            var indeg = tables.ToDictionary(t => t, t => 0, StringComparer.OrdinalIgnoreCase);
            foreach (var table in tables)
            {
                if (!deps.TryGetValue(table, out var parents))
                    continue;
                foreach (var parent in parents)
                {
                    if (!indeg.ContainsKey(parent))
                        indeg[parent] = 0;
                    indeg[table]++;
                }
            }

            var queue = new Queue<string>(
                indeg.Where(kv => kv.Value == 0)
                     .Select(kv => kv.Key)
                     .OrderBy(s => s, StringComparer.OrdinalIgnoreCase));

            var ordered = new List<string>();
            var mutableDeps = deps.ToDictionary(
                kv => kv.Key,
                kv => new HashSet<string>(kv.Value, StringComparer.OrdinalIgnoreCase),
                StringComparer.OrdinalIgnoreCase);

            while (queue.Count > 0)
            {
                var current = queue.Dequeue();
                ordered.Add(current);

                foreach (var dependent in mutableDeps
                    .Where(kv => kv.Value.Contains(current))
                    .Select(kv => kv.Key)
                    .ToList())
                {
                    mutableDeps[dependent].Remove(current);
                    indeg[dependent]--;
                    if (indeg[dependent] == 0)
                        queue.Enqueue(dependent);
                }
            }

            foreach (var table in tables.OrderBy(t => t, StringComparer.OrdinalIgnoreCase))
            {
                if (!ordered.Contains(table, StringComparer.OrdinalIgnoreCase))
                    ordered.Add(table);
            }

            return ordered;
        }
    }
}
