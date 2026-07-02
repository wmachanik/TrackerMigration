-- AUTO-GENERATED NORMALIZED DATA MIGRATION SCRIPT
-- This script migrates only normalized tables (Orders, Recurring).
-- For non-normalized tables, use DataMigration_UNNORMALIZED.sql or the 'N' menu command.

-- Auto-generated DATA MIGRATION script
-- Assumes source data is available under schema [AccessSrc] using Access source table names.
-- If you do not have [AccessSrc] objects, the generator will fall back to unqualified [Source] when Target != Source.
-- If Target == Source and AccessSrc.Source is missing, the table is skipped (no self-select).
-- Create schema once if needed: IF SCHEMA_ID('AccessSrc') IS NULL EXEC('CREATE SCHEMA AccessSrc');
-- AccessSchema: C:\SRC\ASP.net\TrackerMigration\MigrationRunner\Metadata\AccessSchema
-- PlanConstraints: C:\SRC\ASP.net\TrackerMigration\MigrationRunner\Metadata\PlanEdits\PlanConstraints.json
-- Tables to migrate (ordered): 55
--   - AreaPrepDaysTbl
--   - AreasTbl
--   - ArichivedOrdersTbl
--   - AwayReasonTbl
--   - ClientUsageHistoryTbl
--   - ClosureDatesTbl
--   - ContactsAccInfoTbl
--   - ContactsAwayPeriodTbl
--   - ContactsItemsPredictedTbl
--   - ContactsItemSvcSummaryTbl
--   - ContactsItemUsageTbl
--   - ContactsTbl
--   - ContactTrackedServiceItemsTbl
--   - ContactTypesTbl
--   - EquipConditionsTbl
--   - EquipTypesTbl
--   - HolidayClosuresTbl
--   - InvoiceTypesTbl
--   - ItemGroupsTbl
--   - ItemPackagingsTbl
--   - ItemPrepTypesTbl
--   - ItemServiceTypesTbl
--   - ItemsTbl
--   - ItemUnitsTbl
--   - LogTbl
--   - NextPrepDateByAreasTbl
--   - OrderList
--   - OrdersTbl_Apr26_2008
--   - PaymentTermsTbl
--   - PeopleTbl
--   - PredictedOrdersTbl
--   - PriceLevelsTbl
--   - RecurranceTypesTbl
--   - RepairFaultsTbl
--   - RepairStatusesTbl
--   - RepairsTbl
--   - SectionTypesTbl
--   - SendCheckupEmailTextsTbl
--   - SentRemindersLogTbl
--   - SysDataTbl
--   - TempCoffeecheckupCustomerTbl
--   - TempCoffeecheckupItemsTbl
--   - TempOrdersHeaderTbl
--   - TempOrdersLinesTbl
--   - TempOrdersTbl
--   - tmpOrdersReplyTbl
--   - TotalCountTrackerTbl
--   - TrackedServiceItemsTbl
--   - TransactionTypesTbl
--   - UsageAveTbl
--   - UsageTblByDate
--   - UsedItemGroupsTbl
--   - VisitLogTbl
--   - WeekDaysTbl
--   - _ClientUsageTbl
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Disable foreign keys on migrated targets
DECLARE @tbl sysname, @fk sysname, @sql nvarchar(max);
DECLARE fk_cur CURSOR LOCAL FAST_FORWARD FOR
SELECT QUOTENAME(SCHEMA_NAME(t.schema_id))+'.'+QUOTENAME(t.name), QUOTENAME(fk.name)
FROM sys.foreign_keys fk
JOIN sys.tables t ON t.object_id=fk.parent_object_id
WHERE t.name IN (N'AreasTbl', N'ArichivedOrdersTbl', N'AwayReasonTbl', N'ClientUsageHistoryTbl', N'ClosureDatesTbl', N'ContactTypesTbl', N'EquipConditionsTbl', N'EquipTypesTbl', N'HolidayClosuresTbl', N'InvoiceTypesTbl', N'ItemPackagingsTbl', N'ItemPrepTypesTbl', N'ItemUnitsTbl', N'LogTbl', N'OrderList', N'OrdersTbl_Apr26_2008', N'PaymentTermsTbl', N'PeopleTbl', N'PredictedOrdersTbl', N'PriceLevelsTbl', N'RecurranceTypesTbl', N'RepairFaultsTbl', N'RepairStatusesTbl', N'SectionTypesTbl', N'SendCheckupEmailTextsTbl', N'tmpOrdersReplyTbl', N'TotalCountTrackerTbl', N'TransactionTypesTbl', N'UsageAveTbl', N'UsageTblByDate', N'VisitLogTbl', N'WeekDaysTbl', N'_ClientUsageTbl', N'SentRemindersLogTbl', N'ContactsAccInfoTbl', N'AreaPrepDaysTbl', N'ContactsAwayPeriodTbl', N'ContactsItemUsageTbl', N'ContactsTbl', N'ContactsItemSvcSummaryTbl', N'ContactsItemsPredictedTbl', N'ContactTrackedServiceItemsTbl', N'ItemGroupsTbl', N'ItemServiceTypesTbl', N'ItemsTbl', N'NextPrepDateByAreasTbl', N'RepairsTbl', N'SysDataTbl', N'TempCoffeecheckupCustomerTbl', N'TempCoffeecheckupItemsTbl', N'TempOrdersHeaderTbl', N'TempOrdersLinesTbl', N'TempOrdersTbl', N'TrackedServiceItemsTbl', N'UsedItemGroupsTbl');
OPEN fk_cur;
FETCH NEXT FROM fk_cur INTO @tbl, @fk;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'ALTER TABLE ' + @tbl + N' NOCHECK CONSTRAINT ' + @fk + N';';
    PRINT @sql; EXEC sp_executesql @sql;
    FETCH NEXT FROM fk_cur INTO @tbl, @fk;
END
CLOSE fk_cur; DEALLOCATE fk_cur;
GO

-- Purge target tables before load (child-to-parent)
-- Using DELETE instead of TRUNCATE because SQL Server TRUNCATE checks for FK existence even when disabled
PRINT N'Purging [UsedItemGroupsTbl]';
BEGIN TRY
    DELETE FROM [UsedItemGroupsTbl];
    PRINT N'Successfully purged [UsedItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [UsedItemGroupsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TrackedServiceItemsTbl]';
BEGIN TRY
    DELETE FROM [TrackedServiceItemsTbl];
    PRINT N'Successfully purged [TrackedServiceItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TrackedServiceItemsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TempOrdersTbl]';
BEGIN TRY
    DELETE FROM [TempOrdersTbl];
    PRINT N'Successfully purged [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TempOrdersTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TempOrdersLinesTbl]';
BEGIN TRY
    DELETE FROM [TempOrdersLinesTbl];
    PRINT N'Successfully purged [TempOrdersLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TempOrdersLinesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TempOrdersHeaderTbl]';
BEGIN TRY
    DELETE FROM [TempOrdersHeaderTbl];
    PRINT N'Successfully purged [TempOrdersHeaderTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TempOrdersHeaderTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TempCoffeecheckupItemsTbl]';
BEGIN TRY
    DELETE FROM [TempCoffeecheckupItemsTbl];
    PRINT N'Successfully purged [TempCoffeecheckupItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TempCoffeecheckupItemsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TempCoffeecheckupCustomerTbl]';
BEGIN TRY
    DELETE FROM [TempCoffeecheckupCustomerTbl];
    PRINT N'Successfully purged [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [SysDataTbl]';
BEGIN TRY
    DELETE FROM [SysDataTbl];
    PRINT N'Successfully purged [SysDataTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [SysDataTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [RepairsTbl]';
BEGIN TRY
    DELETE FROM [RepairsTbl];
    PRINT N'Successfully purged [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [RepairsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [NextPrepDateByAreasTbl]';
BEGIN TRY
    DELETE FROM [NextPrepDateByAreasTbl];
    PRINT N'Successfully purged [NextPrepDateByAreasTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [NextPrepDateByAreasTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemsTbl]';
BEGIN TRY
    DELETE FROM [ItemsTbl];
    PRINT N'Successfully purged [ItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemServiceTypesTbl]';
BEGIN TRY
    DELETE FROM [ItemServiceTypesTbl];
    PRINT N'Successfully purged [ItemServiceTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemServiceTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemGroupsTbl]';
BEGIN TRY
    DELETE FROM [ItemGroupsTbl];
    PRINT N'Successfully purged [ItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemGroupsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactTrackedServiceItemsTbl]';
BEGIN TRY
    DELETE FROM [ContactTrackedServiceItemsTbl];
    PRINT N'Successfully purged [ContactTrackedServiceItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactTrackedServiceItemsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsItemsPredictedTbl]';
BEGIN TRY
    DELETE FROM [ContactsItemsPredictedTbl];
    PRINT N'Successfully purged [ContactsItemsPredictedTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsItemsPredictedTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsItemSvcSummaryTbl]';
BEGIN TRY
    DELETE FROM [ContactsItemSvcSummaryTbl];
    PRINT N'Successfully purged [ContactsItemSvcSummaryTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsItemSvcSummaryTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsTbl]';
BEGIN TRY
    DELETE FROM [ContactsTbl];
    PRINT N'Successfully purged [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsItemUsageTbl]';
BEGIN TRY
    DELETE FROM [ContactsItemUsageTbl];
    PRINT N'Successfully purged [ContactsItemUsageTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsItemUsageTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsAwayPeriodTbl]';
BEGIN TRY
    DELETE FROM [ContactsAwayPeriodTbl];
    PRINT N'Successfully purged [ContactsAwayPeriodTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsAwayPeriodTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [AreaPrepDaysTbl]';
BEGIN TRY
    DELETE FROM [AreaPrepDaysTbl];
    PRINT N'Successfully purged [AreaPrepDaysTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [AreaPrepDaysTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactsAccInfoTbl]';
BEGIN TRY
    DELETE FROM [ContactsAccInfoTbl];
    PRINT N'Successfully purged [ContactsAccInfoTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactsAccInfoTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [SentRemindersLogTbl]';
BEGIN TRY
    DELETE FROM [SentRemindersLogTbl];
    PRINT N'Successfully purged [SentRemindersLogTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [SentRemindersLogTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [_ClientUsageTbl]';
BEGIN TRY
    DELETE FROM [_ClientUsageTbl];
    PRINT N'Successfully purged [_ClientUsageTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [_ClientUsageTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [WeekDaysTbl]';
BEGIN TRY
    DELETE FROM [WeekDaysTbl];
    PRINT N'Successfully purged [WeekDaysTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [WeekDaysTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [VisitLogTbl]';
BEGIN TRY
    DELETE FROM [VisitLogTbl];
    PRINT N'Successfully purged [VisitLogTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [VisitLogTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [UsageTblByDate]';
BEGIN TRY
    DELETE FROM [UsageTblByDate];
    PRINT N'Successfully purged [UsageTblByDate]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [UsageTblByDate]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [UsageAveTbl]';
BEGIN TRY
    DELETE FROM [UsageAveTbl];
    PRINT N'Successfully purged [UsageAveTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [UsageAveTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TransactionTypesTbl]';
BEGIN TRY
    DELETE FROM [TransactionTypesTbl];
    PRINT N'Successfully purged [TransactionTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TransactionTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [TotalCountTrackerTbl]';
BEGIN TRY
    DELETE FROM [TotalCountTrackerTbl];
    PRINT N'Successfully purged [TotalCountTrackerTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [TotalCountTrackerTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [tmpOrdersReplyTbl]';
BEGIN TRY
    DELETE FROM [tmpOrdersReplyTbl];
    PRINT N'Successfully purged [tmpOrdersReplyTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [tmpOrdersReplyTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [SendCheckupEmailTextsTbl]';
BEGIN TRY
    DELETE FROM [SendCheckupEmailTextsTbl];
    PRINT N'Successfully purged [SendCheckupEmailTextsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [SendCheckupEmailTextsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [SectionTypesTbl]';
BEGIN TRY
    DELETE FROM [SectionTypesTbl];
    PRINT N'Successfully purged [SectionTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [SectionTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [RepairStatusesTbl]';
BEGIN TRY
    DELETE FROM [RepairStatusesTbl];
    PRINT N'Successfully purged [RepairStatusesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [RepairStatusesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [RepairFaultsTbl]';
BEGIN TRY
    DELETE FROM [RepairFaultsTbl];
    PRINT N'Successfully purged [RepairFaultsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [RepairFaultsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [RecurranceTypesTbl]';
BEGIN TRY
    DELETE FROM [RecurranceTypesTbl];
    PRINT N'Successfully purged [RecurranceTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [RecurranceTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [PriceLevelsTbl]';
BEGIN TRY
    DELETE FROM [PriceLevelsTbl];
    PRINT N'Successfully purged [PriceLevelsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [PriceLevelsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [PredictedOrdersTbl]';
BEGIN TRY
    DELETE FROM [PredictedOrdersTbl];
    PRINT N'Successfully purged [PredictedOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [PredictedOrdersTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [PeopleTbl]';
BEGIN TRY
    DELETE FROM [PeopleTbl];
    PRINT N'Successfully purged [PeopleTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [PeopleTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [PaymentTermsTbl]';
BEGIN TRY
    DELETE FROM [PaymentTermsTbl];
    PRINT N'Successfully purged [PaymentTermsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [PaymentTermsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [OrdersTbl_Apr26_2008]';
BEGIN TRY
    DELETE FROM [OrdersTbl_Apr26_2008];
    PRINT N'Successfully purged [OrdersTbl_Apr26_2008]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [OrdersTbl_Apr26_2008]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [OrderList]';
BEGIN TRY
    DELETE FROM [OrderList];
    PRINT N'Successfully purged [OrderList]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [OrderList]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [LogTbl]';
BEGIN TRY
    DELETE FROM [LogTbl];
    PRINT N'Successfully purged [LogTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [LogTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemUnitsTbl]';
BEGIN TRY
    DELETE FROM [ItemUnitsTbl];
    PRINT N'Successfully purged [ItemUnitsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemUnitsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemPrepTypesTbl]';
BEGIN TRY
    DELETE FROM [ItemPrepTypesTbl];
    PRINT N'Successfully purged [ItemPrepTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemPrepTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ItemPackagingsTbl]';
BEGIN TRY
    DELETE FROM [ItemPackagingsTbl];
    PRINT N'Successfully purged [ItemPackagingsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ItemPackagingsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [InvoiceTypesTbl]';
BEGIN TRY
    DELETE FROM [InvoiceTypesTbl];
    PRINT N'Successfully purged [InvoiceTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [InvoiceTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [HolidayClosuresTbl]';
BEGIN TRY
    DELETE FROM [HolidayClosuresTbl];
    PRINT N'Successfully purged [HolidayClosuresTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [HolidayClosuresTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [EquipTypesTbl]';
BEGIN TRY
    DELETE FROM [EquipTypesTbl];
    PRINT N'Successfully purged [EquipTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [EquipTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [EquipConditionsTbl]';
BEGIN TRY
    DELETE FROM [EquipConditionsTbl];
    PRINT N'Successfully purged [EquipConditionsTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [EquipConditionsTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ContactTypesTbl]';
BEGIN TRY
    DELETE FROM [ContactTypesTbl];
    PRINT N'Successfully purged [ContactTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ContactTypesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ClosureDatesTbl]';
BEGIN TRY
    DELETE FROM [ClosureDatesTbl];
    PRINT N'Successfully purged [ClosureDatesTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ClosureDatesTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ClientUsageHistoryTbl]';
BEGIN TRY
    DELETE FROM [ClientUsageHistoryTbl];
    PRINT N'Successfully purged [ClientUsageHistoryTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ClientUsageHistoryTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [AwayReasonTbl]';
BEGIN TRY
    DELETE FROM [AwayReasonTbl];
    PRINT N'Successfully purged [AwayReasonTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [AwayReasonTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [ArichivedOrdersTbl]';
BEGIN TRY
    DELETE FROM [ArichivedOrdersTbl];
    PRINT N'Successfully purged [ArichivedOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [ArichivedOrdersTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
PRINT N'Purging [AreasTbl]';
BEGIN TRY
    DELETE FROM [AreasTbl];
    PRINT N'Successfully purged [AreasTbl]';
END TRY
BEGIN CATCH
    PRINT N'ERROR: Failed to purge [AreasTbl]: ' + ERROR_MESSAGE();
    PRINT N'      This may indicate foreign keys were not properly disabled.';
END CATCH
GO

-- Re-enable foreign keys on migrated targets
DECLARE @tbl2 sysname, @fk2 sysname, @sql2 nvarchar(max);
DECLARE fk_cur2 CURSOR LOCAL FAST_FORWARD FOR
SELECT QUOTENAME(SCHEMA_NAME(t.schema_id))+'.'+QUOTENAME(t.name), QUOTENAME(fk.name)
FROM sys.foreign_keys fk
JOIN sys.tables t ON t.object_id=fk.parent_object_id
WHERE t.name IN (N'AreasTbl', N'ArichivedOrdersTbl', N'AwayReasonTbl', N'ClientUsageHistoryTbl', N'ClosureDatesTbl', N'ContactTypesTbl', N'EquipConditionsTbl', N'EquipTypesTbl', N'HolidayClosuresTbl', N'InvoiceTypesTbl', N'ItemPackagingsTbl', N'ItemPrepTypesTbl', N'ItemUnitsTbl', N'LogTbl', N'OrderList', N'OrdersTbl_Apr26_2008', N'PaymentTermsTbl', N'PeopleTbl', N'PredictedOrdersTbl', N'PriceLevelsTbl', N'RecurranceTypesTbl', N'RepairFaultsTbl', N'RepairStatusesTbl', N'SectionTypesTbl', N'SendCheckupEmailTextsTbl', N'tmpOrdersReplyTbl', N'TotalCountTrackerTbl', N'TransactionTypesTbl', N'UsageAveTbl', N'UsageTblByDate', N'VisitLogTbl', N'WeekDaysTbl', N'_ClientUsageTbl', N'SentRemindersLogTbl', N'ContactsAccInfoTbl', N'AreaPrepDaysTbl', N'ContactsAwayPeriodTbl', N'ContactsItemUsageTbl', N'ContactsTbl', N'ContactsItemSvcSummaryTbl', N'ContactsItemsPredictedTbl', N'ContactTrackedServiceItemsTbl', N'ItemGroupsTbl', N'ItemServiceTypesTbl', N'ItemsTbl', N'NextPrepDateByAreasTbl', N'RepairsTbl', N'SysDataTbl', N'TempCoffeecheckupCustomerTbl', N'TempCoffeecheckupItemsTbl', N'TempOrdersHeaderTbl', N'TempOrdersLinesTbl', N'TempOrdersTbl', N'TrackedServiceItemsTbl', N'UsedItemGroupsTbl');
OPEN fk_cur2;
FETCH NEXT FROM fk_cur2 INTO @tbl2, @fk2;
WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        SET @sql2 = N'ALTER TABLE ' + @tbl2 + N' WITH CHECK CHECK CONSTRAINT ' + @fk2 + N';';
        PRINT @sql2; EXEC sp_executesql @sql2;
    END TRY
    BEGIN CATCH
        PRINT 'WARN: could not CHECK ' + @fk2 + ' on ' + @tbl2 + ': ' + ERROR_MESSAGE();
        SET @sql2 = N'ALTER TABLE ' + @tbl2 + N' WITH NOCHECK CHECK CONSTRAINT ' + @fk2 + N';';
        PRINT @sql2; EXEC sp_executesql @sql2;
    END CATCH
    FETCH NEXT FROM fk_cur2 INTO @tbl2, @fk2;
END
CLOSE fk_cur2; DEALLOCATE fk_cur2;
GO

-- Orphan check for foreign keys that could not be fully trusted after reload
DECLARE @ps sysname, @pt sysname, @rs sysname, @rt sysname, @fkn sysname, @fkId int, @sql nvarchar(max), @pred nvarchar(max);
DECLARE fk_orphans CURSOR LOCAL FAST_FORWARD FOR
SELECT SCHEMA_NAME(tp.schema_id), tp.name, SCHEMA_NAME(tr.schema_id), tr.name, fk.name, fk.object_id
FROM sys.foreign_keys fk
JOIN sys.tables tp ON tp.object_id = fk.parent_object_id
JOIN sys.tables tr ON tr.object_id = fk.referenced_object_id
WHERE tp.name IN (N'AreasTbl', N'ArichivedOrdersTbl', N'AwayReasonTbl', N'ClientUsageHistoryTbl', N'ClosureDatesTbl', N'ContactTypesTbl', N'EquipConditionsTbl', N'EquipTypesTbl', N'HolidayClosuresTbl', N'InvoiceTypesTbl', N'ItemPackagingsTbl', N'ItemPrepTypesTbl', N'ItemUnitsTbl', N'LogTbl', N'OrderList', N'OrdersTbl_Apr26_2008', N'PaymentTermsTbl', N'PeopleTbl', N'PredictedOrdersTbl', N'PriceLevelsTbl', N'RecurranceTypesTbl', N'RepairFaultsTbl', N'RepairStatusesTbl', N'SectionTypesTbl', N'SendCheckupEmailTextsTbl', N'tmpOrdersReplyTbl', N'TotalCountTrackerTbl', N'TransactionTypesTbl', N'UsageAveTbl', N'UsageTblByDate', N'VisitLogTbl', N'WeekDaysTbl', N'_ClientUsageTbl', N'SentRemindersLogTbl', N'ContactsAccInfoTbl', N'AreaPrepDaysTbl', N'ContactsAwayPeriodTbl', N'ContactsItemUsageTbl', N'ContactsTbl', N'ContactsItemSvcSummaryTbl', N'ContactsItemsPredictedTbl', N'ContactTrackedServiceItemsTbl', N'ItemGroupsTbl', N'ItemServiceTypesTbl', N'ItemsTbl', N'NextPrepDateByAreasTbl', N'RepairsTbl', N'SysDataTbl', N'TempCoffeecheckupCustomerTbl', N'TempCoffeecheckupItemsTbl', N'TempOrdersHeaderTbl', N'TempOrdersLinesTbl', N'TempOrdersTbl', N'TrackedServiceItemsTbl', N'UsedItemGroupsTbl') AND (fk.is_not_trusted = 1 OR fk.is_disabled = 1);
OPEN fk_orphans;
FETCH NEXT FROM fk_orphans INTO @ps, @pt, @rs, @rt, @fkn, @fkId;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build multi-column join predicate for this FK
    SELECT @pred = STUFF((
        SELECT ' AND t.' + QUOTENAME(pc.name) + ' = p.' + QUOTENAME(rc.name)
        FROM sys.foreign_key_columns fkc
        JOIN sys.columns pc ON pc.object_id = fkc.parent_object_id AND pc.column_id = fkc.parent_column_id
        JOIN sys.columns rc ON rc.object_id = fkc.referenced_object_id AND rc.column_id = fkc.referenced_column_id
        WHERE fkc.constraint_object_id = @fkId
        ORDER BY fkc.constraint_column_id
        FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 5, '');
    DECLARE @pt2 nvarchar(300) = QUOTENAME(@ps) + N'.' + QUOTENAME(@pt);
    DECLARE @rt2 nvarchar(300) = QUOTENAME(@rs) + N'.' + QUOTENAME(@rt);
    SET @sql = N'PRINT ''ORPHAN CHECK [' + REPLACE(@fkn, '''', '''''') + N'] on ' + @pt2 + N' -> ' + @rt2 + N'''; ' +
              N'SELECT COUNT(*) AS OrphanCount FROM ' + @pt2 + N' t WHERE NOT EXISTS (SELECT 1 FROM ' + @rt2 + N' p WHERE ' + @pred + N'); ' +
              N'SELECT TOP 5 t.* FROM ' + @pt2 + N' t WHERE NOT EXISTS (SELECT 1 FROM ' + @rt2 + N' p WHERE ' + @pred + N') ORDER BY NEWID();';
    EXEC sp_executesql @sql;
    FETCH NEXT FROM fk_orphans INTO @ps, @pt, @rs, @rt, @fkn, @fkId;
END
CLOSE fk_orphans; DEALLOCATE fk_orphans;
GO

