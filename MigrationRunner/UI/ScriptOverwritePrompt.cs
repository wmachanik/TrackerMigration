using System;

namespace MigrationRunner.UI
{
    internal static class ScriptOverwritePrompt
    {
        /// <summary>
        /// Ask before overwriting generated SQL under Metadata/PlanEdits/Sql.
        /// Returns true to proceed with regeneration, false to keep existing files.
        /// </summary>
        public static bool ConfirmRegenerate(string scriptDescription, bool defaultYes = false)
        {
            var rro = RunRangeState.Current;
            if (rro != null && rro.SuppressPrompts)
            {
                if (rro.SkipSqlScriptGeneration)
                {
                    Console.WriteLine($"Skipping regeneration of {scriptDescription} (using existing scripts).");
                    return false;
                }
            }

            var prompt = defaultYes ? "[Y/n]" : "[y/N]";
            Console.WriteLine();
            Console.WriteLine($"WARNING: This will regenerate {scriptDescription} and overwrite files in Metadata/PlanEdits/Sql.");
            Console.Write($"Regenerate {scriptDescription}? {prompt}: ");
            var response = (Console.ReadLine() ?? "").Trim();
            if (string.IsNullOrWhiteSpace(response))
            {
                return defaultYes;
            }

            return response.StartsWith("y", StringComparison.OrdinalIgnoreCase);
        }
    }
}
