using System;
using System.Data.SqlClient;

namespace MigrationRunner
{
    internal static class TargetDatabaseHelper
    {
        /// <summary>
        /// Drops all user tables in every schema except sys (dbo, AccessSrc, etc.).
        /// </summary>
        public static void DropAllUserTables(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
                throw new ArgumentException("Connection string is required.", nameof(connectionString));

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();
                var sql = @"
-- Drop FKs first
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + N';' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON t.object_id = fk.parent_object_id;
IF LEN(@sql) > 0 EXEC sp_executesql @sql;

-- Drop all user tables (dbo, AccessSrc, etc.)
SET @sql = N'';
SELECT @sql = @sql + N'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + N'.' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.tables
WHERE type = N'U' AND SCHEMA_NAME(schema_id) NOT IN (N'sys');
IF LEN(@sql) > 0 EXEC sp_executesql @sql;
";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.CommandTimeout = 600;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Drops all user tables in dbo only. Preserves other schemas (e.g. AccessSrc staging).
        /// </summary>
        public static void DropDboUserTables(string connectionString)
        {
            if (string.IsNullOrWhiteSpace(connectionString))
                throw new ArgumentException("Connection string is required.", nameof(connectionString));

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();
                var sql = @"
-- Drop FKs on dbo tables first
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(fk.name) + N';' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON t.object_id = fk.parent_object_id
WHERE SCHEMA_NAME(t.schema_id) = N'dbo';
IF LEN(@sql) > 0 EXEC sp_executesql @sql;

-- Drop dbo tables
SET @sql = N'';
SELECT @sql = @sql + N'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + N'.' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.tables
WHERE type = N'U' AND SCHEMA_NAME(schema_id) = N'dbo';
IF LEN(@sql) > 0 EXEC sp_executesql @sql;
";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.CommandTimeout = 600;
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
