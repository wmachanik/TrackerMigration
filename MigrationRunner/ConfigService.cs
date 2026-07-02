using System;
using System.IO;

namespace MigrationRunner
{
    public static class ConfigService
    {
        public static string ResolveConfigPath(string baseDir, string[] args)
        {
            // 1) --config <path> or --config=path
            for (int i = 0; i < (args?.Length ?? 0); i++)
            {
                var a = args[i] ?? "";
                if (a.Equals("--config", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                {
                    var p = args[i + 1];
                    if (!string.IsNullOrWhiteSpace(p)) return Path.GetFullPath(p);
                }
                else if (a.StartsWith("--config=", StringComparison.OrdinalIgnoreCase))
                {
                    var p = a.Substring("--config=".Length).Trim();
                    if (!string.IsNullOrWhiteSpace(p)) return Path.GetFullPath(p);
                }
            }

            // 2) exe folder
            var here = Path.Combine(baseDir, "MigrationConfig.json");
            if (File.Exists(here)) return here;

            // 3) walk up to 7 parents; probe both direct and sibling "Migrations\\MigrationConfig.json"
            var dir = new DirectoryInfo(baseDir);
            for (int up = 0; up < 7 && dir != null; up++, dir = dir.Parent)
            {
                var direct = Path.Combine(dir.FullName, "MigrationConfig.json");
                if (File.Exists(direct)) return direct;

                var siblingMigrations = Path.Combine(dir.FullName, "Migrations", "MigrationConfig.json");
                if (File.Exists(siblingMigrations)) return siblingMigrations;
            }

            return null;
        }
    }
}
