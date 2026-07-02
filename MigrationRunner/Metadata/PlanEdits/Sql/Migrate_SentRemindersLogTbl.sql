-- Migration script for table: SentRemindersLogTbl
-- COLUMN RENAMES (AccessSrc -> dbo):
--   [NextPrepDate] -> [NextPreparationDate]
--   [HadReoccurItems] -> [HadRecurringItems]
DELETE FROM [SentRemindersLogTbl];
SET IDENTITY_INSERT [SentRemindersLogTbl] ON;
INSERT INTO [SentRemindersLogTbl] (
[ReminderID], [ContactID], [DateSentReminder], [NextPreparationDate], [ReminderSent], [HadAutoFulfilItem], [HadRecurringItems]
)
SELECT
[ReminderID], [CustomerID], CAST(dbo.SafeDateConvert([DateSentReminder]) AS DATE) AS [DateSentReminder], CAST(dbo.SafeDateConvert([NextPrepDate]) AS DATE) AS [NextPreparationDate], [ReminderSent], [HadAutoFulfilItem], [HadReoccurItems] AS [HadRecurringItems]
FROM [AccessSrc].[SentRemindersLogTbl];
SET IDENTITY_INSERT [SentRemindersLogTbl] OFF;

