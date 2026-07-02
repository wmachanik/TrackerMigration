using System;
using System.Collections.Generic;
using System.IO;

namespace MigrationRunner
{
    public static class MetadataService
    {
        public static void BootstrapMetadata(string workingRoot, string baseDir)
        {
            var targetAccess = Path.Combine(workingRoot, "Metadata", "AccessSchema");
            var targetEdits = Path.Combine(workingRoot, "Metadata", "PlanEdits");

            if (Directory.Exists(targetAccess)) return; // already set up

            var repoRoot = PathService.FindRepoRoot(baseDir);

            // Known old locations to pull from
            var candidates = new List<string>
            {
                Path.Combine(baseDir, "Metadata"),                        // bin\...\Metadata
                Path.Combine(baseDir, "Migrations", "Metadata"),          // bin\...\Migrations\Metadata
            };

            // Also check repo-level legacy locations
            if (!string.IsNullOrWhiteSpace(repoRoot))
            {
                candidates.Add(Path.Combine(repoRoot, "Migrations", "Metadata"));
                candidates.Add(Path.Combine(repoRoot, "Metadata"));
            }

            foreach (var cand in candidates)
            {
                try
                {
                    var srcAccess = Path.Combine(cand, "AccessSchema");
                    var srcEdits  = Path.Combine(cand, "PlanEdits");
                    if (Directory.Exists(srcAccess) && !Directory.Exists(targetAccess))
                    {
                        CopyDirectory(srcAccess, targetAccess);
                        Console.WriteLine("Copied AccessSchema from: " + srcAccess);
                    }
                    if (Directory.Exists(srcEdits) && !Directory.Exists(targetEdits))
                    {
                        CopyDirectory(srcEdits, targetEdits);
                        Console.WriteLine("Copied PlanEdits from: " + srcEdits);
                    }
                    if (Directory.Exists(targetAccess)) break;
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine("Metadata bootstrap skipped for '" + cand + "': " + ex.Message);
                }
            }
        }

        public static void CopyDirectory(string sourceDir, string destDir)
        {
            Directory.CreateDirectory(destDir);
            foreach (var file in Directory.GetFiles(sourceDir, "*", SearchOption.TopDirectoryOnly))
            {
                var name = Path.GetFileName(file);
                File.Copy(file, Path.Combine(destDir, name), overwrite: true);
            }
            foreach (var dir in Directory.GetDirectories(sourceDir, "*", SearchOption.TopDirectoryOnly))
            {
                var name = Path.GetFileName(dir);
                CopyDirectory(dir, Path.Combine(destDir, name));
            }
        }
    }
}
