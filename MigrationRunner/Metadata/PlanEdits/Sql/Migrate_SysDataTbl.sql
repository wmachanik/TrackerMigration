-- Migration script for table: SysDataTbl
-- COLUMN RENAMES (AccessSrc -> dbo):
--   [LastReoccurringDate] -> [LastRecurringDate]
--   [DoReoccuringOrders]  -> [DoRecurringOrders]
-- Use Access names in SELECT only; INSERT uses dbo names from CreateTables_LATEST_FIXED.sql.
DELETE FROM [SysDataTbl];
SET IDENTITY_INSERT [SysDataTbl] ON;
INSERT INTO [SysDataTbl] (
[ID], [LastRecurringDate], [DoRecurringOrders], [DateLastPrepDateCalcd], [MinReminderDate], [GroupReferenceItemID], [InternalContactIDs]
)
SELECT
[ID], CAST(dbo.SafeDateConvert([LastReoccurringDate]) AS DATE) AS [LastRecurringDate], [DoReoccuringOrders] AS [DoRecurringOrders], CAST(dbo.SafeDateConvert([DateLastPrepDateCalcd]) AS DATE) AS [DateLastPrepDateCalcd], CAST(dbo.SafeDateConvert([MinReminderDate]) AS DATE) AS [MinReminderDate], [GroupItemTypeID] AS [GroupReferenceItemID], [InternalCustomerIds] AS [InternalContactIDs]
FROM [AccessSrc].[SysDataTbl];
SET IDENTITY_INSERT [SysDataTbl] OFF;

