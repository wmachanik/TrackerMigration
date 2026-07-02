-- Migration script for table: RecurringTypesTbl
-- Source: AccessSrc.ReoccuranceTypeTbl (legacy Access spelling)
DELETE FROM [RecurringTypesTbl];
SET IDENTITY_INSERT [RecurringTypesTbl] ON;
INSERT INTO [RecurringTypesTbl] (
[RecurringTypeID], [RecurringTypeDesc]
)
SELECT
[ID], [Type]
FROM [AccessSrc].[ReoccuranceTypeTbl];
SET IDENTITY_INSERT [RecurringTypesTbl] OFF;

