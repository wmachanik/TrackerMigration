using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace MigrationRunner
{
    public class TableMigrationLogger
    {
        private readonly string _logFilePath;
        private readonly StringBuilder _log = new StringBuilder();
        private readonly List<string> _success = new List<string>();
        private readonly List<string> _warnings = new List<string>();
        private readonly List<string> _errors = new List<string>();

        public TableMigrationLogger(string logFilePath)
        {
            _logFilePath = logFilePath;
            Directory.CreateDirectory(Path.GetDirectoryName(_logFilePath));
        }

        public void LogTableHeader(string table)
        {
            _log.AppendLine($"==== Table: {table} ====");
        }

        public void LogStatus(string table, int srcRows, int tgtRows, int warnings, int errors)
        {
            _log.AppendLine($"Status: {srcRows} source rows migrated to {tgtRows} target");
            _log.AppendLine($"Warnings: {warnings}");
            _log.AppendLine($"Errors: {errors}");
            if (errors > 0) _errors.Add(table);
            else if (warnings > 0) _warnings.Add(table);
            else _success.Add(table);
        }

        public void LogWarning(string msg)
        {
            _log.AppendLine($"WARNING: {msg}");
        }

        public void LogError(string msg)
        {
            _log.AppendLine($"ERROR: {msg}");
        }

        public void LogInfo(string msg)
        {
            _log.AppendLine(msg);
        }

        public void Save()
        {
            _log.AppendLine();
            _log.AppendLine("==== SUMMARY ====");
            _log.AppendLine($"Success: {string.Join(", ", _success)}");
            _log.AppendLine($"Warnings: {string.Join(", ", _warnings)}");
            _log.AppendLine($"Errors: {string.Join(", ", _errors)}");
            File.WriteAllText(_logFilePath, _log.ToString());
        }

        public void PrintSummary()
        {
            Console.WriteLine("==== SUMMARY ====");
            Console.WriteLine($"Success: {string.Join(", ", _success)}");
            Console.WriteLine($"Warnings: {string.Join(", ", _warnings)}");
            Console.WriteLine($"Errors: {string.Join(", ", _errors)}");
        }
    }
}
