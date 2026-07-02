-- Migration script for table: SentRemindersLogTbl
-- COLUMN RENAME: AccessSrc has [NextPrepDate]; dbo target is [NextPreparationDate] (see CreateTables_LATEST_FIXED.sql).
-- Do NOT use [NextPreparationDate] in the SELECT — that column exists only on dbo, not in Access.
DELETE FROM [SentRemindersLogTbl];SET IDENTITY_INSERT [SentRemindersLogTbl] ON;
INSERT INTO [SentRemindersLogTbl] (
[ReminderID], [ContactID], [DateSentReminder], [NextPreparationDate], [ReminderSent], [HadAutoFulfilItem], [HadRecurrItems]
)
SELECT
[ReminderID], [CustomerID], CAST(dbo.SafeDateConvert([DateSentReminder]) AS DATE) AS [DateSentReminder], CAST(dbo.SafeDateConvert([NextPrepDate]) AS DATE) AS [NextPreparationDate], [ReminderSent], [HadAutoFulfilItem], [HadReoccurItems]
FROM [AccessSrc].[SentRemindersLogTbl];
SET IDENTITY_INSERT [SentRemindersLogTbl] OFF;

