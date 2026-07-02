using System;
using System.Collections.Generic;

namespace MigrationRunner
{
    public class CsvValidationResult
    {
        public bool IsValid { get; set; } = true;
        public List<string> Errors { get; set; } = new List<string>();
    }

    public static class CsvValidator
    {
        // Example: validate TableMapping (adjust fields as needed)
        public static CsvValidationResult ValidateTableMapping(TableMapping mapping)
        {
            var result = new CsvValidationResult();
            if (mapping == null)
            {
                result.IsValid = false;
                result.Errors.Add("Mapping is null.");
                return result;
            }
            if (string.IsNullOrWhiteSpace(mapping.BeforeTable))
            {
                result.IsValid = false;
                result.Errors.Add("BeforeTable is required.");
            }
            if (string.IsNullOrWhiteSpace(mapping.Action))
            {
                result.IsValid = false;
                result.Errors.Add($"Action is required for table '{mapping.BeforeTable ?? "(unknown)"}'.");
            }
            // Add more checks as needed (e.g., AfterTable required for certain actions)
            // Type checks can be added if fields are not string
            return result;
        }
    }
}
