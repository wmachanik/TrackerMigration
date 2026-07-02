-- AUTO-GENERATED UNNORMALIZED DATA MIGRATION SCRIPT
-- This script migrates only non-normalized (copy/rename) tables.
-- For normalized tables (Orders, Recurring), use DataMigration_NORMALIZED.sql or the '!' menu command.

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

-- CityTbl -> AreasTbl
-- Mapping: columnsCount=4
--   ID -> AreaID
--   City -> Area
--   RoastingDay -> PrepDayOfWeekID
--   DeliveryDelay -> DeliveryDelay
IF OBJECT_ID(N'AccessSrc.CityTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [AreasTbl] ([AreaID], [Area], [PrepDayOfWeekID], [DeliveryDelay]) SELECT NULLIF([ID], N'''') AS [AreaID], NULLIF([City], N'''') AS [Area], NULLIF([RoastingDay], N'''') AS [PrepDayOfWeekID], NULLIF([DeliveryDelay], N'''') AS [DeliveryDelay] FROM [AccessSrc].[CityTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [AreasTbl] ON;
        INSERT INTO [AreasTbl]
        (
            [AreaID], [Area], [PrepDayOfWeekID], [DeliveryDelay]
        )
        SELECT
            NULLIF([ID], N'') AS [AreaID], NULLIF([City], N'') AS [Area], NULLIF([RoastingDay], N'') AS [PrepDayOfWeekID], NULLIF([DeliveryDelay], N'') AS [DeliveryDelay]
        FROM [AccessSrc].[CityTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [AreasTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'AreasTbl'))
            DBCC CHECKIDENT (N'AreasTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [AreasTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [AreasTbl] from ' + N'[AccessSrc].[CityTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'AreasTbl') IS NOT NULL SET IDENTITY_INSERT [AreasTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [AreasTbl] from ' + N'[AccessSrc].[CityTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [AreasTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CityTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [AreasTbl] ([AreaID], [Area], [PrepDayOfWeekID], [DeliveryDelay]) SELECT NULLIF([ID], N'''') AS [AreaID], NULLIF([City], N'''') AS [Area], NULLIF([RoastingDay], N'''') AS [PrepDayOfWeekID], NULLIF([DeliveryDelay], N'''') AS [DeliveryDelay] FROM [CityTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [AreasTbl] ON;
        INSERT INTO [AreasTbl]
        (
            [AreaID], [Area], [PrepDayOfWeekID], [DeliveryDelay]
        )
        SELECT
            NULLIF([ID], N'') AS [AreaID], NULLIF([City], N'') AS [Area], NULLIF([RoastingDay], N'') AS [PrepDayOfWeekID], NULLIF([DeliveryDelay], N'') AS [DeliveryDelay]
        FROM [CityTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [AreasTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'AreasTbl'))
            DBCC CHECKIDENT (N'AreasTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [AreasTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [AreasTbl] from ' + N'[CityTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'AreasTbl') IS NOT NULL SET IDENTITY_INSERT [AreasTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [AreasTbl] from ' + N'[CityTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [AreasTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ArichivedOrdersTbl -> ArichivedOrdersTbl
-- Mapping: columnsCount=11
--   OrderID -> OrderID
--   CustomerId -> CustomerId
--   OrderDate -> OrderDate
--   RoastDate -> RoastDate
--   ItemTypeID -> ItemTypeID
--   QuantityOrdered -> QuantityOrdered
--   RequiredByDate -> RequiredByDate
--   ToBeDeliveredBy -> ToBeDeliveredBy
--   Confirmed -> Confirmed
--   Done -> Done
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.ArichivedOrdersTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [ArichivedOrdersTbl] ([OrderID], [CustomerId], [OrderDate], [RoastDate], [ItemTypeID], [QuantityOrdered], [RequiredByDate], [ToBeDeliveredBy], [Confirmed], [Done], [Notes]) SELECT NULLIF([OrderID], N'''') AS [OrderID], NULLIF([CustomerId], N'''') AS [CustomerId], CAST(CASE WHEN NULLIF([OrderDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'''') AS [ItemTypeID], NULLIF([QuantityOrdered], N'''') AS [QuantityOrdered], CAST(CASE WHEN NULLIF([RequiredByDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Requir ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [ArichivedOrdersTbl]
        (
            [OrderID], [CustomerId], [OrderDate], [RoastDate], [ItemTypeID], [QuantityOrdered], [RequiredByDate], [ToBeDeliveredBy], [Confirmed], [Done], [Notes]
        )
        SELECT
            NULLIF([OrderID], N'') AS [OrderID], NULLIF([CustomerId], N'') AS [CustomerId], CAST(CASE WHEN NULLIF([OrderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'') AS [ItemTypeID], NULLIF([QuantityOrdered], N'') AS [QuantityOrdered], CAST(CASE WHEN NULLIF([RequiredByDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RequiredByDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RequiredByDate], NULLIF([ToBeDeliveredBy], N'') AS [ToBeDeliveredBy], CASE WHEN NULLIF([Confirmed], N'') IS NULL THEN NULL WHEN NULLIF([Confirmed], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Confirmed], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Confirmed], N'')) END AS [Confirmed], CASE WHEN NULLIF([Done], N'') IS NULL THEN NULL WHEN NULLIF([Done], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Done], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Done], N'')) END AS [Done], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[ArichivedOrdersTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [ArichivedOrdersTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ArichivedOrdersTbl] from ' + N'[AccessSrc].[ArichivedOrdersTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [ArichivedOrdersTbl] from ' + N'[AccessSrc].[ArichivedOrdersTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ArichivedOrdersTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [ArichivedOrdersTbl]: missing source [AccessSrc].[ArichivedOrdersTbl]';
END
GO

-- AwayReasonTbl -> AwayReasonTbl
-- Mapping: columnsCount=2
--   AwayReasonID -> AwayReasonID
--   ReasonDesc -> ReasonDesc
IF OBJECT_ID(N'AccessSrc.AwayReasonTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [AwayReasonTbl] ([AwayReasonID], [ReasonDesc]) SELECT NULLIF([AwayReasonID], N'''') AS [AwayReasonID], NULLIF([ReasonDesc], N'''') AS [ReasonDesc] FROM [AccessSrc].[AwayReasonTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [AwayReasonTbl] ON;
        INSERT INTO [AwayReasonTbl]
        (
            [AwayReasonID], [ReasonDesc]
        )
        SELECT
            NULLIF([AwayReasonID], N'') AS [AwayReasonID], NULLIF([ReasonDesc], N'') AS [ReasonDesc]
        FROM [AccessSrc].[AwayReasonTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [AwayReasonTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'AwayReasonTbl'))
            DBCC CHECKIDENT (N'AwayReasonTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [AwayReasonTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [AwayReasonTbl] from ' + N'[AccessSrc].[AwayReasonTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'AwayReasonTbl') IS NOT NULL SET IDENTITY_INSERT [AwayReasonTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [AwayReasonTbl] from ' + N'[AccessSrc].[AwayReasonTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [AwayReasonTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [AwayReasonTbl]: missing source [AccessSrc].[AwayReasonTbl]';
END
GO

-- ClientUsageHistoryTbl -> ClientUsageHistoryTbl
-- Mapping: columnsCount=13
--   HistoryID -> HistoryID
--   CustomerId -> CustomerId
--   ItemDate -> ItemDate
--   LastCupCount -> LastCupCount
--   NextCoffeeBy -> NextCoffeeBy
--   NextCleanOn -> NextCleanOn
--   NextFilterEst -> NextFilterEst
--   NextDescaleEst -> NextDescaleEst
--   NextServiceEst -> NextServiceEst
--   DailyConsumption -> DailyConsumption
--   FilterAveCount -> FilterAveCount
--   DescaleAveCount -> DescaleAveCount
--   ServiceAveCount -> ServiceAveCount
IF OBJECT_ID(N'AccessSrc.ClientUsageHistoryTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [ClientUsageHistoryTbl] ([HistoryID], [CustomerId], [ItemDate], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount]) SELECT NULLIF([HistoryID], N'''') AS [HistoryID], NULLIF([CustomerId], N'''') AS [CustomerId], CAST(CASE WHEN NULLIF([ItemDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ItemDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ItemDate], NULLIF([LastCupCount], N'''') AS [LastCupCount], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], CAST(CASE WHEN NULLIF([NextCleanOn], N'''') IS N ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [ClientUsageHistoryTbl]
        (
            [HistoryID], [CustomerId], [ItemDate], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount]
        )
        SELECT
            NULLIF([HistoryID], N'') AS [HistoryID], NULLIF([CustomerId], N'') AS [CustomerId], CAST(CASE WHEN NULLIF([ItemDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ItemDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([ItemDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ItemDate], NULLIF([LastCupCount], N'') AS [LastCupCount], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], CAST(CASE WHEN NULLIF([NextCleanOn], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCleanOn], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCleanOn], CAST(CASE WHEN NULLIF([NextFilterEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextFilterEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextFilterEst], CAST(CASE WHEN NULLIF([NextDescaleEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextDescaleEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextDescaleEst], CAST(CASE WHEN NULLIF([NextServiceEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextServiceEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextServiceEst], NULLIF([DailyConsumption], N'') AS [DailyConsumption], NULLIF([FilterAveCount], N'') AS [FilterAveCount], NULLIF([DescaleAveCount], N'') AS [DescaleAveCount], NULLIF([ServiceAveCount], N'') AS [ServiceAveCount]
        FROM [AccessSrc].[ClientUsageHistoryTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [ClientUsageHistoryTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ClientUsageHistoryTbl] from ' + N'[AccessSrc].[ClientUsageHistoryTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [ClientUsageHistoryTbl] from ' + N'[AccessSrc].[ClientUsageHistoryTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ClientUsageHistoryTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [ClientUsageHistoryTbl]: missing source [AccessSrc].[ClientUsageHistoryTbl]';
END
GO

-- ClosureDatesTbl -> ClosureDatesTbl
-- Mapping: columnsCount=5
--   ID -> ClosureDateID
--   DateClosed -> DateClosed
--   DateReopen -> DateReopen
--   NextRoastDate -> NextPrepDate
--   Comments -> Comments
IF OBJECT_ID(N'AccessSrc.ClosureDatesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ClosureDatesTbl] ([ClosureDateID], [DateClosed], [DateReopen], [NextPrepDate], [Comments]) SELECT NULLIF([ID], N'''') AS [ClosureDateID], CAST(CASE WHEN NULLIF([DateClosed], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateClosed], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateClosed], CAST(CASE WHEN NULLIF([DateReopen], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateReopen], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateReopen], CAST(CASE WHEN NULLIF([NextRoastDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextRoastDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ClosureDatesTbl] ON;
        INSERT INTO [ClosureDatesTbl]
        (
            [ClosureDateID], [DateClosed], [DateReopen], [NextPrepDate], [Comments]
        )
        SELECT
            NULLIF([ID], N'') AS [ClosureDateID], CAST(CASE WHEN NULLIF([DateClosed], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateClosed], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateClosed], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateClosed], CAST(CASE WHEN NULLIF([DateReopen], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateReopen], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateReopen], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateReopen], CAST(CASE WHEN NULLIF([NextRoastDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextRoastDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextRoastDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextPrepDate], NULLIF([Comments], N'') AS [Comments]
        FROM [AccessSrc].[ClosureDatesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ClosureDatesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ClosureDatesTbl'))
            DBCC CHECKIDENT (N'ClosureDatesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ClosureDatesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ClosureDatesTbl] from ' + N'[AccessSrc].[ClosureDatesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ClosureDatesTbl') IS NOT NULL SET IDENTITY_INSERT [ClosureDatesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ClosureDatesTbl] from ' + N'[AccessSrc].[ClosureDatesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ClosureDatesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [ClosureDatesTbl]: missing source [AccessSrc].[ClosureDatesTbl]';
END
GO

-- CustomerTypeTbl -> ContactTypesTbl
-- Mapping: columnsCount=3
--   CustTypeID -> ContactTypeID
--   CustTypeDesc -> ContactTypeDesc
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.CustomerTypeTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactTypesTbl] ([ContactTypeID], [ContactTypeDesc], [Notes]) SELECT NULLIF([CustTypeID], N'''') AS [ContactTypeID], NULLIF([CustTypeDesc], N'''') AS [ContactTypeDesc], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[CustomerTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactTypesTbl] ON;
        INSERT INTO [ContactTypesTbl]
        (
            [ContactTypeID], [ContactTypeDesc], [Notes]
        )
        SELECT
            NULLIF([CustTypeID], N'') AS [ContactTypeID], NULLIF([CustTypeDesc], N'') AS [ContactTypeDesc], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[CustomerTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactTypesTbl'))
            DBCC CHECKIDENT (N'ContactTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactTypesTbl] from ' + N'[AccessSrc].[CustomerTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ContactTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactTypesTbl] from ' + N'[AccessSrc].[CustomerTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CustomerTypeTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactTypesTbl] ([ContactTypeID], [ContactTypeDesc], [Notes]) SELECT NULLIF([CustTypeID], N'''') AS [ContactTypeID], NULLIF([CustTypeDesc], N'''') AS [ContactTypeDesc], NULLIF([Notes], N'''') AS [Notes] FROM [CustomerTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactTypesTbl] ON;
        INSERT INTO [ContactTypesTbl]
        (
            [ContactTypeID], [ContactTypeDesc], [Notes]
        )
        SELECT
            NULLIF([CustTypeID], N'') AS [ContactTypeID], NULLIF([CustTypeDesc], N'') AS [ContactTypeDesc], NULLIF([Notes], N'') AS [Notes]
        FROM [CustomerTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactTypesTbl'))
            DBCC CHECKIDENT (N'ContactTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactTypesTbl] from ' + N'[CustomerTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ContactTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactTypesTbl] from ' + N'[CustomerTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- MachineConditionsTbl -> EquipConditionsTbl
-- Mapping: columnsCount=4
--   MachineConditionID -> EquipConditionID
--   ConditionDesc -> ConditionDesc
--   SortOrder -> SortOrder
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.MachineConditionsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [EquipConditionsTbl] ([EquipConditionID], [ConditionDesc], [SortOrder], [Notes]) SELECT NULLIF([MachineConditionID], N'''') AS [EquipConditionID], NULLIF([ConditionDesc], N'''') AS [ConditionDesc], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[MachineConditionsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [EquipConditionsTbl] ON;
        INSERT INTO [EquipConditionsTbl]
        (
            [EquipConditionID], [ConditionDesc], [SortOrder], [Notes]
        )
        SELECT
            NULLIF([MachineConditionID], N'') AS [EquipConditionID], NULLIF([ConditionDesc], N'') AS [ConditionDesc], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[MachineConditionsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [EquipConditionsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'EquipConditionsTbl'))
            DBCC CHECKIDENT (N'EquipConditionsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [EquipConditionsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [EquipConditionsTbl] from ' + N'[AccessSrc].[MachineConditionsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'EquipConditionsTbl') IS NOT NULL SET IDENTITY_INSERT [EquipConditionsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [EquipConditionsTbl] from ' + N'[AccessSrc].[MachineConditionsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [EquipConditionsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.MachineConditionsTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [EquipConditionsTbl] ([EquipConditionID], [ConditionDesc], [SortOrder], [Notes]) SELECT NULLIF([MachineConditionID], N'''') AS [EquipConditionID], NULLIF([ConditionDesc], N'''') AS [ConditionDesc], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([Notes], N'''') AS [Notes] FROM [MachineConditionsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [EquipConditionsTbl] ON;
        INSERT INTO [EquipConditionsTbl]
        (
            [EquipConditionID], [ConditionDesc], [SortOrder], [Notes]
        )
        SELECT
            NULLIF([MachineConditionID], N'') AS [EquipConditionID], NULLIF([ConditionDesc], N'') AS [ConditionDesc], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([Notes], N'') AS [Notes]
        FROM [MachineConditionsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [EquipConditionsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'EquipConditionsTbl'))
            DBCC CHECKIDENT (N'EquipConditionsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [EquipConditionsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [EquipConditionsTbl] from ' + N'[MachineConditionsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'EquipConditionsTbl') IS NOT NULL SET IDENTITY_INSERT [EquipConditionsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [EquipConditionsTbl] from ' + N'[MachineConditionsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [EquipConditionsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- EquipTypeTbl -> EquipTypesTbl
-- Mapping: columnsCount=3
--   EquipTypeId -> EquipTypeID
--   EquipTypeName -> EquipTypeName
--   EquipTypeDesc -> EquipTypeDesc
IF OBJECT_ID(N'AccessSrc.EquipTypeTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [EquipTypesTbl] ([EquipTypeID], [EquipTypeName], [EquipTypeDesc]) SELECT NULLIF([EquipTypeId], N'''') AS [EquipTypeID], NULLIF([EquipTypeName], N'''') AS [EquipTypeName], NULLIF([EquipTypeDesc], N'''') AS [EquipTypeDesc] FROM [AccessSrc].[EquipTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [EquipTypesTbl] ON;
        INSERT INTO [EquipTypesTbl]
        (
            [EquipTypeID], [EquipTypeName], [EquipTypeDesc]
        )
        SELECT
            NULLIF([EquipTypeId], N'') AS [EquipTypeID], NULLIF([EquipTypeName], N'') AS [EquipTypeName], NULLIF([EquipTypeDesc], N'') AS [EquipTypeDesc]
        FROM [AccessSrc].[EquipTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [EquipTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'EquipTypesTbl'))
            DBCC CHECKIDENT (N'EquipTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [EquipTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [EquipTypesTbl] from ' + N'[AccessSrc].[EquipTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'EquipTypesTbl') IS NOT NULL SET IDENTITY_INSERT [EquipTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [EquipTypesTbl] from ' + N'[AccessSrc].[EquipTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [EquipTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.EquipTypeTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [EquipTypesTbl] ([EquipTypeID], [EquipTypeName], [EquipTypeDesc]) SELECT NULLIF([EquipTypeId], N'''') AS [EquipTypeID], NULLIF([EquipTypeName], N'''') AS [EquipTypeName], NULLIF([EquipTypeDesc], N'''') AS [EquipTypeDesc] FROM [EquipTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [EquipTypesTbl] ON;
        INSERT INTO [EquipTypesTbl]
        (
            [EquipTypeID], [EquipTypeName], [EquipTypeDesc]
        )
        SELECT
            NULLIF([EquipTypeId], N'') AS [EquipTypeID], NULLIF([EquipTypeName], N'') AS [EquipTypeName], NULLIF([EquipTypeDesc], N'') AS [EquipTypeDesc]
        FROM [EquipTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [EquipTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'EquipTypesTbl'))
            DBCC CHECKIDENT (N'EquipTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [EquipTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [EquipTypesTbl] from ' + N'[EquipTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'EquipTypesTbl') IS NOT NULL SET IDENTITY_INSERT [EquipTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [EquipTypesTbl] from ' + N'[EquipTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [EquipTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- HolidayClosureTbl -> HolidayClosuresTbl
-- Mapping: columnsCount=7
--   ID -> HolidayClosureID
--   ClosureDate -> ClosureDate
--   DaysClosed -> DaysClosed
--   AppliesToPrep -> AppliesToPrep
--   AppliesToDelivery -> AppliesToDelivery
--   ShiftStrategy -> ShiftStrategy
--   Description -> Description
IF OBJECT_ID(N'AccessSrc.HolidayClosureTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [HolidayClosuresTbl] ([HolidayClosureID], [ClosureDate], [DaysClosed], [AppliesToPrep], [AppliesToDelivery], [ShiftStrategy], [Description]) SELECT NULLIF([ID], N'''') AS [HolidayClosureID], CAST(CASE WHEN NULLIF([ClosureDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ClosureDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ClosureDate], NULLIF([DaysClosed], N'''') AS [DaysClosed], NULLIF([AppliesToPrep], N'''') AS [AppliesToPrep], NULLIF([AppliesToDelivery], N'''') AS [AppliesToDelivery], NULLIF([ShiftStrategy], N'''') AS [ShiftStrategy], NULLIF([Description], N'''') AS [Description] FROM [AccessSrc].[HolidayClosureTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [HolidayClosuresTbl] ON;
        INSERT INTO [HolidayClosuresTbl]
        (
            [HolidayClosureID], [ClosureDate], [DaysClosed], [AppliesToPrep], [AppliesToDelivery], [ShiftStrategy], [Description]
        )
        SELECT
            NULLIF([ID], N'') AS [HolidayClosureID], CAST(CASE WHEN NULLIF([ClosureDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ClosureDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ClosureDate], NULLIF([DaysClosed], N'') AS [DaysClosed], NULLIF([AppliesToPrep], N'') AS [AppliesToPrep], NULLIF([AppliesToDelivery], N'') AS [AppliesToDelivery], NULLIF([ShiftStrategy], N'') AS [ShiftStrategy], NULLIF([Description], N'') AS [Description]
        FROM [AccessSrc].[HolidayClosureTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [HolidayClosuresTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'HolidayClosuresTbl'))
            DBCC CHECKIDENT (N'HolidayClosuresTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [HolidayClosuresTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [HolidayClosuresTbl] from ' + N'[AccessSrc].[HolidayClosureTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'HolidayClosuresTbl') IS NOT NULL SET IDENTITY_INSERT [HolidayClosuresTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [HolidayClosuresTbl] from ' + N'[AccessSrc].[HolidayClosureTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [HolidayClosuresTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.HolidayClosureTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [HolidayClosuresTbl] ([HolidayClosureID], [ClosureDate], [DaysClosed], [AppliesToPrep], [AppliesToDelivery], [ShiftStrategy], [Description]) SELECT NULLIF([ID], N'''') AS [HolidayClosureID], CAST(CASE WHEN NULLIF([ClosureDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ClosureDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ClosureDate], NULLIF([DaysClosed], N'''') AS [DaysClosed], NULLIF([AppliesToPrep], N'''') AS [AppliesToPrep], NULLIF([AppliesToDelivery], N'''') AS [AppliesToDelivery], NULLIF([ShiftStrategy], N'''') AS [ShiftStrategy], NULLIF([Description], N'''') AS [Description] FROM [HolidayClosureTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [HolidayClosuresTbl] ON;
        INSERT INTO [HolidayClosuresTbl]
        (
            [HolidayClosureID], [ClosureDate], [DaysClosed], [AppliesToPrep], [AppliesToDelivery], [ShiftStrategy], [Description]
        )
        SELECT
            NULLIF([ID], N'') AS [HolidayClosureID], CAST(CASE WHEN NULLIF([ClosureDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([ClosureDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([ClosureDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [ClosureDate], NULLIF([DaysClosed], N'') AS [DaysClosed], NULLIF([AppliesToPrep], N'') AS [AppliesToPrep], NULLIF([AppliesToDelivery], N'') AS [AppliesToDelivery], NULLIF([ShiftStrategy], N'') AS [ShiftStrategy], NULLIF([Description], N'') AS [Description]
        FROM [HolidayClosureTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [HolidayClosuresTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'HolidayClosuresTbl'))
            DBCC CHECKIDENT (N'HolidayClosuresTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [HolidayClosuresTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [HolidayClosuresTbl] from ' + N'[HolidayClosureTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'HolidayClosuresTbl') IS NOT NULL SET IDENTITY_INSERT [HolidayClosuresTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [HolidayClosuresTbl] from ' + N'[HolidayClosureTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [HolidayClosuresTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- InvoiceTypeTbl -> InvoiceTypesTbl
-- Mapping: columnsCount=4
--   InvoiceTypeID -> InvoiceTypeID
--   InvoiceTypeDesc -> InvoiceTypeDesc
--   Enabled -> Enabled
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.InvoiceTypeTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [InvoiceTypesTbl] ([InvoiceTypeID], [InvoiceTypeDesc], [Enabled], [Notes]) SELECT NULLIF([InvoiceTypeID], N'''') AS [InvoiceTypeID], NULLIF([InvoiceTypeDesc], N'''') AS [InvoiceTypeDesc], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[InvoiceTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [InvoiceTypesTbl] ON;
        INSERT INTO [InvoiceTypesTbl]
        (
            [InvoiceTypeID], [InvoiceTypeDesc], [Enabled], [Notes]
        )
        SELECT
            NULLIF([InvoiceTypeID], N'') AS [InvoiceTypeID], NULLIF([InvoiceTypeDesc], N'') AS [InvoiceTypeDesc], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[InvoiceTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [InvoiceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'InvoiceTypesTbl'))
            DBCC CHECKIDENT (N'InvoiceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [InvoiceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [InvoiceTypesTbl] from ' + N'[AccessSrc].[InvoiceTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'InvoiceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [InvoiceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [InvoiceTypesTbl] from ' + N'[AccessSrc].[InvoiceTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [InvoiceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.InvoiceTypeTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [InvoiceTypesTbl] ([InvoiceTypeID], [InvoiceTypeDesc], [Enabled], [Notes]) SELECT NULLIF([InvoiceTypeID], N'''') AS [InvoiceTypeID], NULLIF([InvoiceTypeDesc], N'''') AS [InvoiceTypeDesc], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [InvoiceTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [InvoiceTypesTbl] ON;
        INSERT INTO [InvoiceTypesTbl]
        (
            [InvoiceTypeID], [InvoiceTypeDesc], [Enabled], [Notes]
        )
        SELECT
            NULLIF([InvoiceTypeID], N'') AS [InvoiceTypeID], NULLIF([InvoiceTypeDesc], N'') AS [InvoiceTypeDesc], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [InvoiceTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [InvoiceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'InvoiceTypesTbl'))
            DBCC CHECKIDENT (N'InvoiceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [InvoiceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [InvoiceTypesTbl] from ' + N'[InvoiceTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'InvoiceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [InvoiceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [InvoiceTypesTbl] from ' + N'[InvoiceTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [InvoiceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- PackagingTbl -> ItemPackagingsTbl
-- Mapping: columnsCount=6
--   PackagingID -> ItemPackagingID
--   Description -> ItemPrepDescription
--   AdditionalNotes -> AdditionalNotes
--   Symbol -> Symbol
--   Colour -> Colour
--   BGColour -> BGColour
IF OBJECT_ID(N'AccessSrc.PackagingTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemPackagingsTbl] ([ItemPackagingID], [ItemPrepDescription], [AdditionalNotes], [Symbol], [Colour], [BGColour]) SELECT NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([Description], N'''') AS [ItemPrepDescription], NULLIF([AdditionalNotes], N'''') AS [AdditionalNotes], NULLIF([Symbol], N'''') AS [Symbol], NULLIF([Colour], N'''') AS [Colour], NULLIF([BGColour], N'''') AS [BGColour] FROM [AccessSrc].[PackagingTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemPackagingsTbl] ON;
        INSERT INTO [ItemPackagingsTbl]
        (
            [ItemPackagingID], [ItemPrepDescription], [AdditionalNotes], [Symbol], [Colour], [BGColour]
        )
        SELECT
            NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([Description], N'') AS [ItemPrepDescription], NULLIF([AdditionalNotes], N'') AS [AdditionalNotes], NULLIF([Symbol], N'') AS [Symbol], NULLIF([Colour], N'') AS [Colour], NULLIF([BGColour], N'') AS [BGColour]
        FROM [AccessSrc].[PackagingTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemPackagingsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemPackagingsTbl'))
            DBCC CHECKIDENT (N'ItemPackagingsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemPackagingsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemPackagingsTbl] from ' + N'[AccessSrc].[PackagingTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemPackagingsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemPackagingsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemPackagingsTbl] from ' + N'[AccessSrc].[PackagingTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemPackagingsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.PackagingTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemPackagingsTbl] ([ItemPackagingID], [ItemPrepDescription], [AdditionalNotes], [Symbol], [Colour], [BGColour]) SELECT NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([Description], N'''') AS [ItemPrepDescription], NULLIF([AdditionalNotes], N'''') AS [AdditionalNotes], NULLIF([Symbol], N'''') AS [Symbol], NULLIF([Colour], N'''') AS [Colour], NULLIF([BGColour], N'''') AS [BGColour] FROM [PackagingTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemPackagingsTbl] ON;
        INSERT INTO [ItemPackagingsTbl]
        (
            [ItemPackagingID], [ItemPrepDescription], [AdditionalNotes], [Symbol], [Colour], [BGColour]
        )
        SELECT
            NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([Description], N'') AS [ItemPrepDescription], NULLIF([AdditionalNotes], N'') AS [AdditionalNotes], NULLIF([Symbol], N'') AS [Symbol], NULLIF([Colour], N'') AS [Colour], NULLIF([BGColour], N'') AS [BGColour]
        FROM [PackagingTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemPackagingsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemPackagingsTbl'))
            DBCC CHECKIDENT (N'ItemPackagingsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemPackagingsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemPackagingsTbl] from ' + N'[PackagingTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemPackagingsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemPackagingsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemPackagingsTbl] from ' + N'[PackagingTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemPackagingsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- PrepTypesTbl -> ItemPrepTypesTbl
-- Mapping: columnsCount=3
--   PrepID -> ItemPrepID
--   PrepType -> ItemPrepType
--   IdentifyingChar -> IdentifyingChar
IF OBJECT_ID(N'AccessSrc.PrepTypesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemPrepTypesTbl] ([ItemPrepID], [ItemPrepType], [IdentifyingChar]) SELECT NULLIF([PrepID], N'''') AS [ItemPrepID], NULLIF([PrepType], N'''') AS [ItemPrepType], NULLIF([IdentifyingChar], N'''') AS [IdentifyingChar] FROM [AccessSrc].[PrepTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemPrepTypesTbl] ON;
        INSERT INTO [ItemPrepTypesTbl]
        (
            [ItemPrepID], [ItemPrepType], [IdentifyingChar]
        )
        SELECT
            NULLIF([PrepID], N'') AS [ItemPrepID], NULLIF([PrepType], N'') AS [ItemPrepType], NULLIF([IdentifyingChar], N'') AS [IdentifyingChar]
        FROM [AccessSrc].[PrepTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemPrepTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemPrepTypesTbl'))
            DBCC CHECKIDENT (N'ItemPrepTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemPrepTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemPrepTypesTbl] from ' + N'[AccessSrc].[PrepTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemPrepTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ItemPrepTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemPrepTypesTbl] from ' + N'[AccessSrc].[PrepTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemPrepTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.PrepTypesTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemPrepTypesTbl] ([ItemPrepID], [ItemPrepType], [IdentifyingChar]) SELECT NULLIF([PrepID], N'''') AS [ItemPrepID], NULLIF([PrepType], N'''') AS [ItemPrepType], NULLIF([IdentifyingChar], N'''') AS [IdentifyingChar] FROM [PrepTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemPrepTypesTbl] ON;
        INSERT INTO [ItemPrepTypesTbl]
        (
            [ItemPrepID], [ItemPrepType], [IdentifyingChar]
        )
        SELECT
            NULLIF([PrepID], N'') AS [ItemPrepID], NULLIF([PrepType], N'') AS [ItemPrepType], NULLIF([IdentifyingChar], N'') AS [IdentifyingChar]
        FROM [PrepTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemPrepTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemPrepTypesTbl'))
            DBCC CHECKIDENT (N'ItemPrepTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemPrepTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemPrepTypesTbl] from ' + N'[PrepTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemPrepTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ItemPrepTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemPrepTypesTbl] from ' + N'[PrepTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemPrepTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ItemUnitsTbl -> ItemUnitsTbl
-- Mapping: columnsCount=3
--   ItemUnitID -> ItemUnitID
--   UnitOfMeasure -> UnitOfMeasure
--   UnitDescription -> UnitDescription
IF OBJECT_ID(N'AccessSrc.ItemUnitsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemUnitsTbl] ([ItemUnitID], [UnitOfMeasure], [UnitDescription]) SELECT NULLIF([ItemUnitID], N'''') AS [ItemUnitID], NULLIF([UnitOfMeasure], N'''') AS [UnitOfMeasure], NULLIF([UnitDescription], N'''') AS [UnitDescription] FROM [AccessSrc].[ItemUnitsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemUnitsTbl] ON;
        INSERT INTO [ItemUnitsTbl]
        (
            [ItemUnitID], [UnitOfMeasure], [UnitDescription]
        )
        SELECT
            NULLIF([ItemUnitID], N'') AS [ItemUnitID], NULLIF([UnitOfMeasure], N'') AS [UnitOfMeasure], NULLIF([UnitDescription], N'') AS [UnitDescription]
        FROM [AccessSrc].[ItemUnitsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemUnitsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemUnitsTbl'))
            DBCC CHECKIDENT (N'ItemUnitsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemUnitsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemUnitsTbl] from ' + N'[AccessSrc].[ItemUnitsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemUnitsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemUnitsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemUnitsTbl] from ' + N'[AccessSrc].[ItemUnitsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemUnitsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [ItemUnitsTbl]: missing source [AccessSrc].[ItemUnitsTbl]';
END
GO

-- LogTbl -> LogTbl
-- Mapping: columnsCount=8
--   LogID -> LogID
--   DateAdded -> DateAdded
--   UserID -> UserID
--   SectionID -> SectionID
--   TranactionTypeID -> TranactionTypeID
--   CustomerID -> CustomerID
--   Details -> Details
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.LogTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [LogTbl] ([LogID], [DateAdded], [UserID], [SectionID], [TranactionTypeID], [CustomerID], [Details], [Notes]) SELECT NULLIF([LogID], N'''') AS [LogID], CAST(CASE WHEN NULLIF([DateAdded], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateAdded], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateAdded], NULLIF([UserID], N'''') AS [UserID], NULLIF([SectionID], N'''') AS [SectionID], NULLIF([TranactionTypeID], N'''') AS [TranactionTypeID], NULLIF([CustomerID], N'''') AS [CustomerID], NULLIF([Details], N'''') AS [Details], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[LogTbl];';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [LogTbl]
        (
            [LogID], [DateAdded], [UserID], [SectionID], [TranactionTypeID], [CustomerID], [Details], [Notes]
        )
        SELECT
            NULLIF([LogID], N'') AS [LogID], CAST(CASE WHEN NULLIF([DateAdded], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateAdded], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateAdded], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateAdded], NULLIF([UserID], N'') AS [UserID], NULLIF([SectionID], N'') AS [SectionID], NULLIF([TranactionTypeID], N'') AS [TranactionTypeID], NULLIF([CustomerID], N'') AS [CustomerID], NULLIF([Details], N'') AS [Details], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[LogTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [LogTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [LogTbl] from ' + N'[AccessSrc].[LogTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [LogTbl] from ' + N'[AccessSrc].[LogTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [LogTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [LogTbl]: missing source [AccessSrc].[LogTbl]';
END
GO

-- OrderList -> OrderList
-- Mapping: columnsCount=25
--   ID -> ID
--   Cleints -> Cleints
--   Cln Tb -> Cln Tb
--   Decal -> Decal
--   Filter -> Filter
--   Sidama -> Sidama
--   Switch -> Switch
--   Terranova -> Terranova
--   Alpino -> Alpino
--   Yirga -> Yirga
--   Marango -> Marango
--   Limu -> Limu
--   Harrar -> Harrar
--   Mandheling -> Mandheling
--   Timana -> Timana
--   Marcala -> Marcala
--   Antigua -> Antigua
--   Decaf -> Decaf
--   La Piram -> La Piram
--   Asorgan -> Asorgan
--   Los Idol -> Los Idol
--   No order -> No order
--   Day -> Day
--   done -> done
--   Time -> Time
IF OBJECT_ID(N'AccessSrc.OrderList') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [OrderList] ([ID], [Cleints], [Cln Tb], [Decal], [Filter], [Sidama], [Switch], [Terranova], [Alpino], [Yirga], [Marango], [Limu], [Harrar], [Mandheling], [Timana], [Marcala], [Antigua], [Decaf], [La Piram], [Asorgan], [Los Idol], [No order], [Day], [done], [Time]) SELECT NULLIF([ID], N'''') AS [ID], NULLIF([Cleints], N'''') AS [Cleints], NULLIF([Cln Tb], N'''') AS [Cln Tb], NULLIF([Decal], N'''') AS [Decal], NULLIF([Filter], N'''') AS [Filter], NULLIF([Sidama], N'''') AS [Sidama], NULLIF([Switch], N'''') AS [Switch], NULLIF([Terranova], N'''') AS [Terranova], NULLIF([Alpino], N'''') AS [Alpino], NULLIF([Yirga], N'''') AS [Yirga], NULLIF([Marango], N'''') AS [Marango], NULLIF([Limu], N'''') AS [Limu], NULLIF([Harrar], N'''') AS [Harrar], NULLIF([Mandheling], N'''') AS [Mandheling], NULLIF([Timana], N'''') AS [Timana], NULLIF([Marcala], N'''') AS [Marcala], NULLIF([Antigua], N'''') AS [Antigua], NULLIF([Decaf], N'''') AS [Decaf], NULLIF([La Piram], N'''') AS [La Piram], NULLIF([Asorgan], N'''') AS [Asorgan], NULLIF([Los Idol], N'''') AS [Los Idol], NULLIF([No order], N'''') AS [No order], NULLIF([Day], N'''') AS [Day], CASE WHEN NULLIF([done], N'''') IS NULL THEN NULL WHEN NULLIF([done], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([done], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([done], N'''')) END AS [done], CAST(CASE WHEN NULLIF([Time], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Time], N'''')))) = 0 THEN NULL ELSE COALES ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [OrderList]
        (
            [ID], [Cleints], [Cln Tb], [Decal], [Filter], [Sidama], [Switch], [Terranova], [Alpino], [Yirga], [Marango], [Limu], [Harrar], [Mandheling], [Timana], [Marcala], [Antigua], [Decaf], [La Piram], [Asorgan], [Los Idol], [No order], [Day], [done], [Time]
        )
        SELECT
            NULLIF([ID], N'') AS [ID], NULLIF([Cleints], N'') AS [Cleints], NULLIF([Cln Tb], N'') AS [Cln Tb], NULLIF([Decal], N'') AS [Decal], NULLIF([Filter], N'') AS [Filter], NULLIF([Sidama], N'') AS [Sidama], NULLIF([Switch], N'') AS [Switch], NULLIF([Terranova], N'') AS [Terranova], NULLIF([Alpino], N'') AS [Alpino], NULLIF([Yirga], N'') AS [Yirga], NULLIF([Marango], N'') AS [Marango], NULLIF([Limu], N'') AS [Limu], NULLIF([Harrar], N'') AS [Harrar], NULLIF([Mandheling], N'') AS [Mandheling], NULLIF([Timana], N'') AS [Timana], NULLIF([Marcala], N'') AS [Marcala], NULLIF([Antigua], N'') AS [Antigua], NULLIF([Decaf], N'') AS [Decaf], NULLIF([La Piram], N'') AS [La Piram], NULLIF([Asorgan], N'') AS [Asorgan], NULLIF([Los Idol], N'') AS [Los Idol], NULLIF([No order], N'') AS [No order], NULLIF([Day], N'') AS [Day], CASE WHEN NULLIF([done], N'') IS NULL THEN NULL WHEN NULLIF([done], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([done], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([done], N'')) END AS [done], CAST(CASE WHEN NULLIF([Time], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Time], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Time], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([Time], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([Time], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([Time], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([Time], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([Time], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [Time]
        FROM [AccessSrc].[OrderList];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [OrderList] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [OrderList] from ' + N'[AccessSrc].[OrderList]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [OrderList] from ' + N'[AccessSrc].[OrderList]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [OrderList] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [OrderList]: missing source [AccessSrc].[OrderList]';
END
GO

-- OrdersTbl_Apr26_2008 -> OrdersTbl_Apr26_2008
-- Mapping: columnsCount=11
--   OrderID -> OrderID
--   CustomerId -> CustomerId
--   OrderDate -> OrderDate
--   RoastDate -> RoastDate
--   ItemTypeID -> ItemTypeID
--   QuantityOrdered -> QuantityOrdered
--   RequiredByDate -> RequiredByDate
--   ToBeDeliveredBy -> ToBeDeliveredBy
--   Confirmed -> Confirmed
--   Done -> Done
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.OrdersTbl_Apr26_2008') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [OrdersTbl_Apr26_2008] ([OrderID], [CustomerId], [OrderDate], [RoastDate], [ItemTypeID], [QuantityOrdered], [RequiredByDate], [ToBeDeliveredBy], [Confirmed], [Done], [Notes]) SELECT NULLIF([OrderID], N'''') AS [OrderID], NULLIF([CustomerId], N'''') AS [CustomerId], CAST(CASE WHEN NULLIF([OrderDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'''') AS [ItemTypeID], NULLIF([QuantityOrdered], N'''') AS [QuantityOrdered], CAST(CASE WHEN NULLIF([RequiredByDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Requ ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [OrdersTbl_Apr26_2008]
        (
            [OrderID], [CustomerId], [OrderDate], [RoastDate], [ItemTypeID], [QuantityOrdered], [RequiredByDate], [ToBeDeliveredBy], [Confirmed], [Done], [Notes]
        )
        SELECT
            NULLIF([OrderID], N'') AS [OrderID], NULLIF([CustomerId], N'') AS [CustomerId], CAST(CASE WHEN NULLIF([OrderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'') AS [ItemTypeID], NULLIF([QuantityOrdered], N'') AS [QuantityOrdered], CAST(CASE WHEN NULLIF([RequiredByDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RequiredByDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RequiredByDate], NULLIF([ToBeDeliveredBy], N'') AS [ToBeDeliveredBy], CASE WHEN NULLIF([Confirmed], N'') IS NULL THEN NULL WHEN NULLIF([Confirmed], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Confirmed], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Confirmed], N'')) END AS [Confirmed], CASE WHEN NULLIF([Done], N'') IS NULL THEN NULL WHEN NULLIF([Done], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Done], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Done], N'')) END AS [Done], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[OrdersTbl_Apr26_2008];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [OrdersTbl_Apr26_2008] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [OrdersTbl_Apr26_2008] from ' + N'[AccessSrc].[OrdersTbl_Apr26_2008]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [OrdersTbl_Apr26_2008] from ' + N'[AccessSrc].[OrdersTbl_Apr26_2008]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [OrdersTbl_Apr26_2008] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [OrdersTbl_Apr26_2008]: missing source [AccessSrc].[OrdersTbl_Apr26_2008]';
END
GO

-- PaymentTermsTbl -> PaymentTermsTbl
-- Mapping: columnsCount=7
--   PaymentTermID -> PaymentTermID
--   PaymentTermDesc -> PaymentTermDesc
--   PaymentDays -> PaymentDays
--   DayOfMonth -> DayOfMonth
--   UseDays -> UseDays
--   Enabled -> Enabled
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.PaymentTermsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [PaymentTermsTbl] ([PaymentTermID], [PaymentTermDesc], [PaymentDays], [DayOfMonth], [UseDays], [Enabled], [Notes]) SELECT NULLIF([PaymentTermID], N'''') AS [PaymentTermID], NULLIF([PaymentTermDesc], N'''') AS [PaymentTermDesc], NULLIF([PaymentDays], N'''') AS [PaymentDays], NULLIF([DayOfMonth], N'''') AS [DayOfMonth], NULLIF([UseDays], N'''') AS [UseDays], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[PaymentTermsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [PaymentTermsTbl] ON;
        INSERT INTO [PaymentTermsTbl]
        (
            [PaymentTermID], [PaymentTermDesc], [PaymentDays], [DayOfMonth], [UseDays], [Enabled], [Notes]
        )
        SELECT
            NULLIF([PaymentTermID], N'') AS [PaymentTermID], NULLIF([PaymentTermDesc], N'') AS [PaymentTermDesc], NULLIF([PaymentDays], N'') AS [PaymentDays], NULLIF([DayOfMonth], N'') AS [DayOfMonth], NULLIF([UseDays], N'') AS [UseDays], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[PaymentTermsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [PaymentTermsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'PaymentTermsTbl'))
            DBCC CHECKIDENT (N'PaymentTermsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [PaymentTermsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [PaymentTermsTbl] from ' + N'[AccessSrc].[PaymentTermsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'PaymentTermsTbl') IS NOT NULL SET IDENTITY_INSERT [PaymentTermsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [PaymentTermsTbl] from ' + N'[AccessSrc].[PaymentTermsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [PaymentTermsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [PaymentTermsTbl]: missing source [AccessSrc].[PaymentTermsTbl]';
END
GO

-- PersonsTbl -> PeopleTbl
-- Mapping: columnsCount=6
--   PersonID -> PersonID
--   Person -> Person
--   Abreviation -> Abbreviation
--   Enabled -> Enabled
--   NormalDeliveryDoW -> NormalDeliveryDoW
--   SecurityUsername -> SecurityUsername
IF OBJECT_ID(N'AccessSrc.PersonsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [PeopleTbl] ([PersonID], [Person], [Abbreviation], [Enabled], [NormalDeliveryDoW], [SecurityUsername]) SELECT NULLIF([PersonID], N'''') AS [PersonID], NULLIF([Person], N'''') AS [Person], NULLIF([Abreviation], N'''') AS [Abbreviation], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([NormalDeliveryDoW], N'''') AS [NormalDeliveryDoW], NULLIF([SecurityUsername], N'''') AS [SecurityUsername] FROM [AccessSrc].[PersonsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [PeopleTbl] ON;
        INSERT INTO [PeopleTbl]
        (
            [PersonID], [Person], [Abbreviation], [Enabled], [NormalDeliveryDoW], [SecurityUsername]
        )
        SELECT
            NULLIF([PersonID], N'') AS [PersonID], NULLIF([Person], N'') AS [Person], NULLIF([Abreviation], N'') AS [Abbreviation], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([NormalDeliveryDoW], N'') AS [NormalDeliveryDoW], NULLIF([SecurityUsername], N'') AS [SecurityUsername]
        FROM [AccessSrc].[PersonsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [PeopleTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'PeopleTbl'))
            DBCC CHECKIDENT (N'PeopleTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [PeopleTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [PeopleTbl] from ' + N'[AccessSrc].[PersonsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'PeopleTbl') IS NOT NULL SET IDENTITY_INSERT [PeopleTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [PeopleTbl] from ' + N'[AccessSrc].[PersonsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [PeopleTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.PersonsTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [PeopleTbl] ([PersonID], [Person], [Abbreviation], [Enabled], [NormalDeliveryDoW], [SecurityUsername]) SELECT NULLIF([PersonID], N'''') AS [PersonID], NULLIF([Person], N'''') AS [Person], NULLIF([Abreviation], N'''') AS [Abbreviation], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([NormalDeliveryDoW], N'''') AS [NormalDeliveryDoW], NULLIF([SecurityUsername], N'''') AS [SecurityUsername] FROM [PersonsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [PeopleTbl] ON;
        INSERT INTO [PeopleTbl]
        (
            [PersonID], [Person], [Abbreviation], [Enabled], [NormalDeliveryDoW], [SecurityUsername]
        )
        SELECT
            NULLIF([PersonID], N'') AS [PersonID], NULLIF([Person], N'') AS [Person], NULLIF([Abreviation], N'') AS [Abbreviation], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([NormalDeliveryDoW], N'') AS [NormalDeliveryDoW], NULLIF([SecurityUsername], N'') AS [SecurityUsername]
        FROM [PersonsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [PeopleTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'PeopleTbl'))
            DBCC CHECKIDENT (N'PeopleTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [PeopleTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [PeopleTbl] from ' + N'[PersonsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'PeopleTbl') IS NOT NULL SET IDENTITY_INSERT [PeopleTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [PeopleTbl] from ' + N'[PersonsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [PeopleTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- PredictedOrdersTbl -> PredictedOrdersTbl
-- Mapping: columnsCount=11
--   PredictedOrderID -> PredictedOrderID
--   Pinned -> Pinned
--   ContactID -> ContactID
--   PrepDate -> PrepDate
--   ItemId -> ItemId
--   PrepTypeID -> PrepTypeID
--   PackagingID -> PackagingID
--   Quantity -> Quantity
--   DeliveryDate -> DeliveryDate
--   DeliveryPersonID -> DeliveryPersonID
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.PredictedOrdersTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [PredictedOrdersTbl] ([PredictedOrderID], [Pinned], [ContactID], [PrepDate], [ItemId], [PrepTypeID], [PackagingID], [Quantity], [DeliveryDate], [DeliveryPersonID], [Notes]) SELECT NULLIF([PredictedOrderID], N'''') AS [PredictedOrderID], NULLIF([Pinned], N'''') AS [Pinned], NULLIF([ContactID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([PrepDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PrepDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PrepDate], NULLIF([ItemId], N'''') AS [ItemId], NULLIF([PrepTypeID], N'''') AS [PrepTypeID], NULLIF([PackagingID], N'''') AS [PackagingID], NULLIF([Quantity], N'''') AS [Quantity], CAST(CASE WHEN NULLIF([DeliveryDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'''')), CAST(NULL A ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [PredictedOrdersTbl]
        (
            [PredictedOrderID], [Pinned], [ContactID], [PrepDate], [ItemId], [PrepTypeID], [PackagingID], [Quantity], [DeliveryDate], [DeliveryPersonID], [Notes]
        )
        SELECT
            NULLIF([PredictedOrderID], N'') AS [PredictedOrderID], NULLIF([Pinned], N'') AS [Pinned], NULLIF([ContactID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([PrepDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PrepDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([PrepDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PrepDate], NULLIF([ItemId], N'') AS [ItemId], NULLIF([PrepTypeID], N'') AS [PrepTypeID], NULLIF([PackagingID], N'') AS [PackagingID], NULLIF([Quantity], N'') AS [Quantity], CAST(CASE WHEN NULLIF([DeliveryDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([DeliveryPersonID], N'') AS [DeliveryPersonID], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[PredictedOrdersTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [PredictedOrdersTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [PredictedOrdersTbl] from ' + N'[AccessSrc].[PredictedOrdersTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [PredictedOrdersTbl] from ' + N'[AccessSrc].[PredictedOrdersTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [PredictedOrdersTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [PredictedOrdersTbl]: missing source [AccessSrc].[PredictedOrdersTbl]';
END
GO

-- PriceLevelsTbl -> PriceLevelsTbl
-- Mapping: columnsCount=5
--   PriceLevelID -> PriceLevelID
--   PriceLevelDesc -> PriceLevelDesc
--   PricingFactor -> PricingFactor
--   Enabled -> Enabled
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.PriceLevelsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [PriceLevelsTbl] ([PriceLevelID], [PriceLevelDesc], [PricingFactor], [Enabled], [Notes]) SELECT NULLIF([PriceLevelID], N'''') AS [PriceLevelID], NULLIF([PriceLevelDesc], N'''') AS [PriceLevelDesc], NULLIF([PricingFactor], N'''') AS [PricingFactor], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[PriceLevelsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [PriceLevelsTbl] ON;
        INSERT INTO [PriceLevelsTbl]
        (
            [PriceLevelID], [PriceLevelDesc], [PricingFactor], [Enabled], [Notes]
        )
        SELECT
            NULLIF([PriceLevelID], N'') AS [PriceLevelID], NULLIF([PriceLevelDesc], N'') AS [PriceLevelDesc], NULLIF([PricingFactor], N'') AS [PricingFactor], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[PriceLevelsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [PriceLevelsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'PriceLevelsTbl'))
            DBCC CHECKIDENT (N'PriceLevelsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [PriceLevelsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [PriceLevelsTbl] from ' + N'[AccessSrc].[PriceLevelsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'PriceLevelsTbl') IS NOT NULL SET IDENTITY_INSERT [PriceLevelsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [PriceLevelsTbl] from ' + N'[AccessSrc].[PriceLevelsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [PriceLevelsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [PriceLevelsTbl]: missing source [AccessSrc].[PriceLevelsTbl]';
END
GO

-- ReoccuranceTypeTbl -> RecurranceTypesTbl
-- Mapping: columnsCount=2
--   ID -> RecurringTypeID
--   Type -> RecurringTypeDesc
IF OBJECT_ID(N'AccessSrc.ReoccuranceTypeTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [RecurranceTypesTbl] ([RecurringTypeID], [RecurringTypeDesc]) SELECT NULLIF([ID], N'''') AS [RecurringTypeID], NULLIF([Type], N'''') AS [RecurringTypeDesc] FROM [AccessSrc].[ReoccuranceTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [RecurranceTypesTbl] ON;
        INSERT INTO [RecurranceTypesTbl]
        (
            [RecurringTypeID], [RecurringTypeDesc]
        )
        SELECT
            NULLIF([ID], N'') AS [RecurringTypeID], NULLIF([Type], N'') AS [RecurringTypeDesc]
        FROM [AccessSrc].[ReoccuranceTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [RecurranceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'RecurranceTypesTbl'))
            DBCC CHECKIDENT (N'RecurranceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [RecurranceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [RecurranceTypesTbl] from ' + N'[AccessSrc].[ReoccuranceTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'RecurranceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [RecurranceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [RecurranceTypesTbl] from ' + N'[AccessSrc].[ReoccuranceTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [RecurranceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ReoccuranceTypeTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [RecurranceTypesTbl] ([RecurringTypeID], [RecurringTypeDesc]) SELECT NULLIF([ID], N'''') AS [RecurringTypeID], NULLIF([Type], N'''') AS [RecurringTypeDesc] FROM [ReoccuranceTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [RecurranceTypesTbl] ON;
        INSERT INTO [RecurranceTypesTbl]
        (
            [RecurringTypeID], [RecurringTypeDesc]
        )
        SELECT
            NULLIF([ID], N'') AS [RecurringTypeID], NULLIF([Type], N'') AS [RecurringTypeDesc]
        FROM [ReoccuranceTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [RecurranceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'RecurranceTypesTbl'))
            DBCC CHECKIDENT (N'RecurranceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [RecurranceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [RecurranceTypesTbl] from ' + N'[ReoccuranceTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'RecurranceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [RecurranceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [RecurranceTypesTbl] from ' + N'[ReoccuranceTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [RecurranceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- RepairFaultsTbl -> RepairFaultsTbl
-- Mapping: columnsCount=4
--   RepairFaultID -> RepairFaultID
--   RepairFaultDesc -> RepairFaultDesc
--   SortOrder -> SortOrder
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.RepairFaultsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [RepairFaultsTbl] ([RepairFaultID], [RepairFaultDesc], [SortOrder], [Notes]) SELECT NULLIF([RepairFaultID], N'''') AS [RepairFaultID], NULLIF([RepairFaultDesc], N'''') AS [RepairFaultDesc], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[RepairFaultsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [RepairFaultsTbl] ON;
        INSERT INTO [RepairFaultsTbl]
        (
            [RepairFaultID], [RepairFaultDesc], [SortOrder], [Notes]
        )
        SELECT
            NULLIF([RepairFaultID], N'') AS [RepairFaultID], NULLIF([RepairFaultDesc], N'') AS [RepairFaultDesc], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[RepairFaultsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [RepairFaultsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'RepairFaultsTbl'))
            DBCC CHECKIDENT (N'RepairFaultsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [RepairFaultsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [RepairFaultsTbl] from ' + N'[AccessSrc].[RepairFaultsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'RepairFaultsTbl') IS NOT NULL SET IDENTITY_INSERT [RepairFaultsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [RepairFaultsTbl] from ' + N'[AccessSrc].[RepairFaultsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [RepairFaultsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [RepairFaultsTbl]: missing source [AccessSrc].[RepairFaultsTbl]';
END
GO

-- RepairStatusesTbl -> RepairStatusesTbl
-- Mapping: columnsCount=6
--   RepairStatusID -> RepairStatusID
--   RepairStatusDesc -> RepairStatusDesc
--   EmailClient -> EmailContact
--   SortOrder -> SortOrder
--   Notes -> Notes
--   StatusNote -> StatusNote
IF OBJECT_ID(N'AccessSrc.RepairStatusesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [RepairStatusesTbl] ([RepairStatusID], [RepairStatusDesc], [EmailContact], [SortOrder], [Notes], [StatusNote]) SELECT NULLIF([RepairStatusID], N'''') AS [RepairStatusID], NULLIF([RepairStatusDesc], N'''') AS [RepairStatusDesc], NULLIF([EmailClient], N'''') AS [EmailContact], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([Notes], N'''') AS [Notes], NULLIF([StatusNote], N'''') AS [StatusNote] FROM [AccessSrc].[RepairStatusesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [RepairStatusesTbl] ON;
        INSERT INTO [RepairStatusesTbl]
        (
            [RepairStatusID], [RepairStatusDesc], [EmailContact], [SortOrder], [Notes], [StatusNote]
        )
        SELECT
            NULLIF([RepairStatusID], N'') AS [RepairStatusID], NULLIF([RepairStatusDesc], N'') AS [RepairStatusDesc], NULLIF([EmailClient], N'') AS [EmailContact], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([Notes], N'') AS [Notes], NULLIF([StatusNote], N'') AS [StatusNote]
        FROM [AccessSrc].[RepairStatusesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [RepairStatusesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'RepairStatusesTbl'))
            DBCC CHECKIDENT (N'RepairStatusesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [RepairStatusesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [RepairStatusesTbl] from ' + N'[AccessSrc].[RepairStatusesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'RepairStatusesTbl') IS NOT NULL SET IDENTITY_INSERT [RepairStatusesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [RepairStatusesTbl] from ' + N'[AccessSrc].[RepairStatusesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [RepairStatusesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [RepairStatusesTbl]: missing source [AccessSrc].[RepairStatusesTbl]';
END
GO

-- SectionTypesTbl -> SectionTypesTbl
-- Mapping: columnsCount=3
--   SectionID -> SectionID
--   SectionType -> SectionType
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.SectionTypesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [SectionTypesTbl] ([SectionID], [SectionType], [Notes]) SELECT NULLIF([SectionID], N'''') AS [SectionID], NULLIF([SectionType], N'''') AS [SectionType], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[SectionTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [SectionTypesTbl] ON;
        INSERT INTO [SectionTypesTbl]
        (
            [SectionID], [SectionType], [Notes]
        )
        SELECT
            NULLIF([SectionID], N'') AS [SectionID], NULLIF([SectionType], N'') AS [SectionType], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[SectionTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [SectionTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'SectionTypesTbl'))
            DBCC CHECKIDENT (N'SectionTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [SectionTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [SectionTypesTbl] from ' + N'[AccessSrc].[SectionTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'SectionTypesTbl') IS NOT NULL SET IDENTITY_INSERT [SectionTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [SectionTypesTbl] from ' + N'[AccessSrc].[SectionTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [SectionTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [SectionTypesTbl]: missing source [AccessSrc].[SectionTypesTbl]';
END
GO

-- SendCheckEmailTextsTbl -> SendCheckupEmailTextsTbl
-- Mapping: columnsCount=6
--   SCEMTID -> SCEMTID
--   Header -> HeaderText
--   Body -> BodyText
--   Footer -> FooterText
--   DateLastChange -> DateLastChange
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.SendCheckEmailTextsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [SendCheckupEmailTextsTbl] ([SCEMTID], [HeaderText], [BodyText], [FooterText], [DateLastChange], [Notes]) SELECT NULLIF([SCEMTID], N'''') AS [SCEMTID], NULLIF([Header], N'''') AS [HeaderText], NULLIF([Body], N'''') AS [BodyText], NULLIF([Footer], N'''') AS [FooterText], CAST(CASE WHEN NULLIF([DateLastChange], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastChange], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastChange], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[SendCheckEmailTextsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] ON;
        INSERT INTO [SendCheckupEmailTextsTbl]
        (
            [SCEMTID], [HeaderText], [BodyText], [FooterText], [DateLastChange], [Notes]
        )
        SELECT
            NULLIF([SCEMTID], N'') AS [SCEMTID], NULLIF([Header], N'') AS [HeaderText], NULLIF([Body], N'') AS [BodyText], NULLIF([Footer], N'') AS [FooterText], CAST(CASE WHEN NULLIF([DateLastChange], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastChange], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastChange], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[SendCheckEmailTextsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'SendCheckupEmailTextsTbl'))
            DBCC CHECKIDENT (N'SendCheckupEmailTextsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [SendCheckupEmailTextsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [SendCheckupEmailTextsTbl] from ' + N'[AccessSrc].[SendCheckEmailTextsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'SendCheckupEmailTextsTbl') IS NOT NULL SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [SendCheckupEmailTextsTbl] from ' + N'[AccessSrc].[SendCheckEmailTextsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [SendCheckupEmailTextsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.SendCheckEmailTextsTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [SendCheckupEmailTextsTbl] ([SCEMTID], [HeaderText], [BodyText], [FooterText], [DateLastChange], [Notes]) SELECT NULLIF([SCEMTID], N'''') AS [SCEMTID], NULLIF([Header], N'''') AS [HeaderText], NULLIF([Body], N'''') AS [BodyText], NULLIF([Footer], N'''') AS [FooterText], CAST(CASE WHEN NULLIF([DateLastChange], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastChange], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastChange], NULLIF([Notes], N'''') AS [Notes] FROM [SendCheckEmailTextsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] ON;
        INSERT INTO [SendCheckupEmailTextsTbl]
        (
            [SCEMTID], [HeaderText], [BodyText], [FooterText], [DateLastChange], [Notes]
        )
        SELECT
            NULLIF([SCEMTID], N'') AS [SCEMTID], NULLIF([Header], N'') AS [HeaderText], NULLIF([Body], N'') AS [BodyText], NULLIF([Footer], N'') AS [FooterText], CAST(CASE WHEN NULLIF([DateLastChange], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastChange], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastChange], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastChange], NULLIF([Notes], N'') AS [Notes]
        FROM [SendCheckEmailTextsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'SendCheckupEmailTextsTbl'))
            DBCC CHECKIDENT (N'SendCheckupEmailTextsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [SendCheckupEmailTextsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [SendCheckupEmailTextsTbl] from ' + N'[SendCheckEmailTextsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'SendCheckupEmailTextsTbl') IS NOT NULL SET IDENTITY_INSERT [SendCheckupEmailTextsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [SendCheckupEmailTextsTbl] from ' + N'[SendCheckEmailTextsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [SendCheckupEmailTextsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- tmpOrdersReplyTbl -> tmpOrdersReplyTbl
-- Mapping: columnsCount=17
--   ID -> ID
--   CustomerId -> CustomerId
--   First Name -> First Name
--   email -> email
--   ThisWeekPlease -> ThisWeekPlease
--   NextCoffeeBy -> NextCoffeeBy
--   Item1 -> Item1
--   Item1Qty -> Item1Qty
--   Item2 -> Item2
--   Item2Qty -> Item2Qty
--   Item3 -> Item3
--   Item3Qty -> Item3Qty
--   Item4 -> Item4
--   Item4Qty -> Item4Qty
--   Item5 -> Item5
--   Item5Qty -> Item5Qty
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.tmpOrdersReplyTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [tmpOrdersReplyTbl] ([ID], [CustomerId], [First Name], [email], [ThisWeekPlease], [NextCoffeeBy], [Item1], [Item1Qty], [Item2], [Item2Qty], [Item3], [Item3Qty], [Item4], [Item4Qty], [Item5], [Item5Qty], [Notes]) SELECT NULLIF([ID], N'''') AS [ID], NULLIF([CustomerId], N'''') AS [CustomerId], NULLIF([First Name], N'''') AS [First Name], NULLIF([email], N'''') AS [email], NULLIF([ThisWeekPlease], N'''') AS [ThisWeekPlease], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], NULLIF([Item1], N'''') AS [Item1], NULLIF([Item1Qty], N'''') AS [Item1Qty], NULLIF([Item2], N'''') AS [Item2], NULLIF([Item2Qty], N'''') AS [Item2Qty], NULLIF([Item3], N'''') AS [Item3], NULLIF([Item3Qty], N'''') AS [Item3Qty], NULLIF([Item4], N'''') AS [Item4], NULLIF([Item4Qty], N'''') AS [Item4Qty], NULLIF([Item5], N'''') AS [Item5], NULLIF([Item5Qty], N'''') AS [Item5Qty], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[tmpOrdersReplyTbl];';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [tmpOrdersReplyTbl]
        (
            [ID], [CustomerId], [First Name], [email], [ThisWeekPlease], [NextCoffeeBy], [Item1], [Item1Qty], [Item2], [Item2Qty], [Item3], [Item3Qty], [Item4], [Item4Qty], [Item5], [Item5Qty], [Notes]
        )
        SELECT
            NULLIF([ID], N'') AS [ID], NULLIF([CustomerId], N'') AS [CustomerId], NULLIF([First Name], N'') AS [First Name], NULLIF([email], N'') AS [email], NULLIF([ThisWeekPlease], N'') AS [ThisWeekPlease], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], NULLIF([Item1], N'') AS [Item1], NULLIF([Item1Qty], N'') AS [Item1Qty], NULLIF([Item2], N'') AS [Item2], NULLIF([Item2Qty], N'') AS [Item2Qty], NULLIF([Item3], N'') AS [Item3], NULLIF([Item3Qty], N'') AS [Item3Qty], NULLIF([Item4], N'') AS [Item4], NULLIF([Item4Qty], N'') AS [Item4Qty], NULLIF([Item5], N'') AS [Item5], NULLIF([Item5Qty], N'') AS [Item5Qty], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[tmpOrdersReplyTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [tmpOrdersReplyTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [tmpOrdersReplyTbl] from ' + N'[AccessSrc].[tmpOrdersReplyTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [tmpOrdersReplyTbl] from ' + N'[AccessSrc].[tmpOrdersReplyTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [tmpOrdersReplyTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [tmpOrdersReplyTbl]: missing source [AccessSrc].[tmpOrdersReplyTbl]';
END
GO

-- TotalCountTrackerTbl -> TotalCountTrackerTbl
-- Mapping: columnsCount=4
--   ID -> TotalCounterTrackerID
--   CountDate -> CountDate
--   TotalCount -> TotalCount
--   Comments -> Comments
IF OBJECT_ID(N'AccessSrc.TotalCountTrackerTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TotalCountTrackerTbl] ([TotalCounterTrackerID], [CountDate], [TotalCount], [Comments]) SELECT NULLIF([ID], N'''') AS [TotalCounterTrackerID], CAST(CASE WHEN NULLIF([CountDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([CountDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [CountDate], NULLIF([TotalCount], N'''') AS [TotalCount], NULLIF([Comments], N'''') AS [Comments] FROM [AccessSrc].[TotalCountTrackerTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TotalCountTrackerTbl] ON;
        INSERT INTO [TotalCountTrackerTbl]
        (
            [TotalCounterTrackerID], [CountDate], [TotalCount], [Comments]
        )
        SELECT
            NULLIF([ID], N'') AS [TotalCounterTrackerID], CAST(CASE WHEN NULLIF([CountDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([CountDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([CountDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [CountDate], NULLIF([TotalCount], N'') AS [TotalCount], NULLIF([Comments], N'') AS [Comments]
        FROM [AccessSrc].[TotalCountTrackerTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TotalCountTrackerTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TotalCountTrackerTbl'))
            DBCC CHECKIDENT (N'TotalCountTrackerTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TotalCountTrackerTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TotalCountTrackerTbl] from ' + N'[AccessSrc].[TotalCountTrackerTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TotalCountTrackerTbl') IS NOT NULL SET IDENTITY_INSERT [TotalCountTrackerTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TotalCountTrackerTbl] from ' + N'[AccessSrc].[TotalCountTrackerTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TotalCountTrackerTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TotalCountTrackerTbl]: missing source [AccessSrc].[TotalCountTrackerTbl]';
END
GO

-- TransactionTypesTbl -> TransactionTypesTbl
-- Mapping: columnsCount=3
--   TransactionID -> TransactionID
--   TransactionType -> TransactionType
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.TransactionTypesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TransactionTypesTbl] ([TransactionID], [TransactionType], [Notes]) SELECT NULLIF([TransactionID], N'''') AS [TransactionID], NULLIF([TransactionType], N'''') AS [TransactionType], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[TransactionTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TransactionTypesTbl] ON;
        INSERT INTO [TransactionTypesTbl]
        (
            [TransactionID], [TransactionType], [Notes]
        )
        SELECT
            NULLIF([TransactionID], N'') AS [TransactionID], NULLIF([TransactionType], N'') AS [TransactionType], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[TransactionTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TransactionTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TransactionTypesTbl'))
            DBCC CHECKIDENT (N'TransactionTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TransactionTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TransactionTypesTbl] from ' + N'[AccessSrc].[TransactionTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TransactionTypesTbl') IS NOT NULL SET IDENTITY_INSERT [TransactionTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TransactionTypesTbl] from ' + N'[AccessSrc].[TransactionTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TransactionTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TransactionTypesTbl]: missing source [AccessSrc].[TransactionTypesTbl]';
END
GO

-- UsageAveTbl -> UsageAveTbl
-- Mapping: columnsCount=14
--   ClientId -> ClientId
--   CoffeeCycle -> CoffeeCycle
--   CoffeeProvided -> CoffeeProvided
--   PreferedCoffeeId -> PreferedCoffeeId
--   LastOrderedDate -> LastOrderedDate
--   EstReorderDate -> EstReorderDate
--   CupsPerDaysConsumed -> CupsPerDaysConsumed
--   LastCleanDate -> LastCleanDate
--   EstCleanDate -> EstCleanDate
--   LastFilterDate -> LastFilterDate
--   EstFilterDate -> EstFilterDate
--   LastDescaleDate -> LastDescaleDate
--   EstDescaleDate -> EstDescaleDate
--   FitlerOnlyClient -> FitlerOnlyClient
IF OBJECT_ID(N'AccessSrc.UsageAveTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [UsageAveTbl] ([ClientId], [CoffeeCycle], [CoffeeProvided], [PreferedCoffeeId], [LastOrderedDate], [EstReorderDate], [CupsPerDaysConsumed], [LastCleanDate], [EstCleanDate], [LastFilterDate], [EstFilterDate], [LastDescaleDate], [EstDescaleDate], [FitlerOnlyClient]) SELECT NULLIF([ClientId], N'''') AS [ClientId], NULLIF([CoffeeCycle], N'''') AS [CoffeeCycle], NULLIF([CoffeeProvided], N'''') AS [CoffeeProvided], NULLIF([PreferedCoffeeId], N'''') AS [PreferedCoffeeId], CAST(CASE WHEN NULLIF([LastOrderedDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastOrderedDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastOrderedDate], CAST(CASE WHEN NULLIF([EstReorderDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([EstReorderDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''''), 101), T ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [UsageAveTbl]
        (
            [ClientId], [CoffeeCycle], [CoffeeProvided], [PreferedCoffeeId], [LastOrderedDate], [EstReorderDate], [CupsPerDaysConsumed], [LastCleanDate], [EstCleanDate], [LastFilterDate], [EstFilterDate], [LastDescaleDate], [EstDescaleDate], [FitlerOnlyClient]
        )
        SELECT
            NULLIF([ClientId], N'') AS [ClientId], NULLIF([CoffeeCycle], N'') AS [CoffeeCycle], NULLIF([CoffeeProvided], N'') AS [CoffeeProvided], NULLIF([PreferedCoffeeId], N'') AS [PreferedCoffeeId], CAST(CASE WHEN NULLIF([LastOrderedDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastOrderedDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastOrderedDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastOrderedDate], CAST(CASE WHEN NULLIF([EstReorderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([EstReorderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([EstReorderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [EstReorderDate], NULLIF([CupsPerDaysConsumed], N'') AS [CupsPerDaysConsumed], CAST(CASE WHEN NULLIF([LastCleanDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastCleanDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastCleanDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastCleanDate], CAST(CASE WHEN NULLIF([EstCleanDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([EstCleanDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([EstCleanDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [EstCleanDate], CAST(CASE WHEN NULLIF([LastFilterDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastFilterDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastFilterDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastFilterDate], CAST(CASE WHEN NULLIF([EstFilterDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([EstFilterDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([EstFilterDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [EstFilterDate], CAST(CASE WHEN NULLIF([LastDescaleDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastDescaleDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastDescaleDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastDescaleDate], CAST(CASE WHEN NULLIF([EstDescaleDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([EstDescaleDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([EstDescaleDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [EstDescaleDate], NULLIF([FitlerOnlyClient], N'') AS [FitlerOnlyClient]
        FROM [AccessSrc].[UsageAveTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [UsageAveTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [UsageAveTbl] from ' + N'[AccessSrc].[UsageAveTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [UsageAveTbl] from ' + N'[AccessSrc].[UsageAveTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [UsageAveTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [UsageAveTbl]: missing source [AccessSrc].[UsageAveTbl]';
END
GO

-- UsageTblByDate -> UsageTblByDate
-- Mapping: columnsCount=9
--   UsaageID -> UsaageID
--   ClientID -> ClientID
--   Date -> Date
--   CupCount -> CupCount
--   CoffeeProvded -> CoffeeProvded
--   MachineCleaned -> MachineCleaned
--   FilterProvided -> FilterProvided
--   MachineDescaled -> MachineDescaled
--   CountCheckOnly -> CountCheckOnly
IF OBJECT_ID(N'AccessSrc.UsageTblByDate') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [UsageTblByDate] ([UsaageID], [ClientID], [Date], [CupCount], [CoffeeProvded], [MachineCleaned], [FilterProvided], [MachineDescaled], [CountCheckOnly]) SELECT NULLIF([UsaageID], N'''') AS [UsaageID], NULLIF([ClientID], N'''') AS [ClientID], CAST(CASE WHEN NULLIF([Date], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [Date], NULLIF([CupCount], N'''') AS [CupCount], NULLIF([CoffeeProvded], N'''') AS [CoffeeProvded], NULLIF([MachineCleaned], N'''') AS [MachineCleaned], NULLIF([FilterProvided], N'''') AS [FilterProvided], NULLIF([MachineDescaled], N'''') AS [MachineDescaled], NULLIF([CountCheckOnly], N'''') AS [CountCheckOnly] FROM [AccessSrc].[UsageTblByDate];';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [UsageTblByDate]
        (
            [UsaageID], [ClientID], [Date], [CupCount], [CoffeeProvded], [MachineCleaned], [FilterProvided], [MachineDescaled], [CountCheckOnly]
        )
        SELECT
            NULLIF([UsaageID], N'') AS [UsaageID], NULLIF([ClientID], N'') AS [ClientID], CAST(CASE WHEN NULLIF([Date], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [Date], NULLIF([CupCount], N'') AS [CupCount], NULLIF([CoffeeProvded], N'') AS [CoffeeProvded], NULLIF([MachineCleaned], N'') AS [MachineCleaned], NULLIF([FilterProvided], N'') AS [FilterProvided], NULLIF([MachineDescaled], N'') AS [MachineDescaled], NULLIF([CountCheckOnly], N'') AS [CountCheckOnly]
        FROM [AccessSrc].[UsageTblByDate];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [UsageTblByDate] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [UsageTblByDate] from ' + N'[AccessSrc].[UsageTblByDate]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [UsageTblByDate] from ' + N'[AccessSrc].[UsageTblByDate]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [UsageTblByDate] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [UsageTblByDate]: missing source [AccessSrc].[UsageTblByDate]';
END
GO

-- VisitLogTbl -> VisitLogTbl
-- Mapping: columnsCount=10
--   ID -> ID
--   Client -> Client
--   VisitDate -> VisitDate
--   CupsMade -> CupsMade
--   Cleaned -> Cleaned
--   Descaled -> Descaled
--   CoffeeQty -> CoffeeQty
--   CoffeeTypeProvided -> CoffeeTypeProvided
--   InvRef -> InvRef
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.VisitLogTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [VisitLogTbl] ([ID], [Client], [VisitDate], [CupsMade], [Cleaned], [Descaled], [CoffeeQty], [CoffeeTypeProvided], [InvRef], [Notes]) SELECT NULLIF([ID], N'''') AS [ID], NULLIF([Client], N'''') AS [Client], CAST(CASE WHEN NULLIF([VisitDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([VisitDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [VisitDate], NULLIF([CupsMade], N'''') AS [CupsMade], NULLIF([Cleaned], N'''') AS [Cleaned], NULLIF([Descaled], N'''') AS [Descaled], NULLIF([CoffeeQty], N'''') AS [CoffeeQty], NULLIF([CoffeeTypeProvided], N'''') AS [CoffeeTypeProvided], NULLIF([InvRef], N'''') AS [InvRef], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[VisitLogTbl];';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [VisitLogTbl]
        (
            [ID], [Client], [VisitDate], [CupsMade], [Cleaned], [Descaled], [CoffeeQty], [CoffeeTypeProvided], [InvRef], [Notes]
        )
        SELECT
            NULLIF([ID], N'') AS [ID], NULLIF([Client], N'') AS [Client], CAST(CASE WHEN NULLIF([VisitDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([VisitDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([VisitDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [VisitDate], NULLIF([CupsMade], N'') AS [CupsMade], NULLIF([Cleaned], N'') AS [Cleaned], NULLIF([Descaled], N'') AS [Descaled], NULLIF([CoffeeQty], N'') AS [CoffeeQty], NULLIF([CoffeeTypeProvided], N'') AS [CoffeeTypeProvided], NULLIF([InvRef], N'') AS [InvRef], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[VisitLogTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [VisitLogTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [VisitLogTbl] from ' + N'[AccessSrc].[VisitLogTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [VisitLogTbl] from ' + N'[AccessSrc].[VisitLogTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [VisitLogTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [VisitLogTbl]: missing source [AccessSrc].[VisitLogTbl]';
END
GO

-- WeekDaysTbl -> WeekDaysTbl
-- Mapping: columnsCount=2
--   WeekDaysID -> WeekDaysID
--   WeekDayName -> WeekDayName
IF OBJECT_ID(N'AccessSrc.WeekDaysTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [WeekDaysTbl] ([WeekDaysID], [WeekDayName]) SELECT NULLIF([WeekDaysID], N'''') AS [WeekDaysID], NULLIF([WeekDayName], N'''') AS [WeekDayName] FROM [AccessSrc].[WeekDaysTbl];';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [WeekDaysTbl]
        (
            [WeekDaysID], [WeekDayName]
        )
        SELECT
            NULLIF([WeekDaysID], N'') AS [WeekDaysID], NULLIF([WeekDayName], N'') AS [WeekDayName]
        FROM [AccessSrc].[WeekDaysTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [WeekDaysTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [WeekDaysTbl] from ' + N'[AccessSrc].[WeekDaysTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [WeekDaysTbl] from ' + N'[AccessSrc].[WeekDaysTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [WeekDaysTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [WeekDaysTbl]: missing source [AccessSrc].[WeekDaysTbl]';
END
GO

-- _ClientUsageTbl -> _ClientUsageTbl
-- Mapping: columnsCount=11
--   CustomerId -> CustomerId
--   LastCupCount -> LastCupCount
--   NextCoffeeBy -> NextCoffeeBy
--   NextCleanOn -> NextCleanOn
--   NextFilterEst -> NextFilterEst
--   NextDescaleEst -> NextDescaleEst
--   NextServiceEst -> NextServiceEst
--   DailyConsumption -> DailyConsumption
--   FilterAveCount -> FilterAveCount
--   DescaleAveCount -> DescaleAveCount
--   ServiceAveCount -> ServiceAveCount
IF OBJECT_ID(N'AccessSrc._ClientUsageTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [_ClientUsageTbl] ([CustomerId], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount]) SELECT NULLIF([CustomerId], N'''') AS [CustomerId], NULLIF([LastCupCount], N'''') AS [LastCupCount], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], CAST(CASE WHEN NULLIF([NextCleanOn], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCleanOn], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCleanOn], CAST(CASE WHEN NULLIF([NextFilterEst], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextFilterEs ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [_ClientUsageTbl]
        (
            [CustomerId], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount]
        )
        SELECT
            NULLIF([CustomerId], N'') AS [CustomerId], NULLIF([LastCupCount], N'') AS [LastCupCount], CAST(CASE WHEN NULLIF([NextCoffeeBy], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCoffeeBy], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCoffeeBy], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCoffeeBy], CAST(CASE WHEN NULLIF([NextCleanOn], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextCleanOn], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextCleanOn], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextCleanOn], CAST(CASE WHEN NULLIF([NextFilterEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextFilterEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextFilterEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextFilterEst], CAST(CASE WHEN NULLIF([NextDescaleEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextDescaleEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextDescaleEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextDescaleEst], CAST(CASE WHEN NULLIF([NextServiceEst], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextServiceEst], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextServiceEst], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextServiceEst], NULLIF([DailyConsumption], N'') AS [DailyConsumption], NULLIF([FilterAveCount], N'') AS [FilterAveCount], NULLIF([DescaleAveCount], N'') AS [DescaleAveCount], NULLIF([ServiceAveCount], N'') AS [ServiceAveCount]
        FROM [AccessSrc].[_ClientUsageTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [_ClientUsageTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [_ClientUsageTbl] from ' + N'[AccessSrc].[_ClientUsageTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [_ClientUsageTbl] from ' + N'[AccessSrc].[_ClientUsageTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [_ClientUsageTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [_ClientUsageTbl]: missing source [AccessSrc].[_ClientUsageTbl]';
END
GO

-- SentRemindersLogTbl -> SentRemindersLogTbl
-- Mapping: columnsCount=7
--   ReminderID -> ReminderID
--   CustomerID -> ContactID
--   DateSentReminder -> DateSentReminder
--   NextPrepDate -> NextPrepDate
--   ReminderSent -> ReminderSent
--   HadAutoFulfilItem -> HadAutoFulfilItem
--   HadReoccurItems -> HadRecurrItems
IF OBJECT_ID(N'AccessSrc.SentRemindersLogTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [SentRemindersLogTbl] ([ReminderID], [ContactID], [DateSentReminder], [NextPrepDate], [ReminderSent], [HadAutoFulfilItem], [HadRecurrItems]) SELECT NULLIF([ReminderID], N'''') AS [ReminderID], NULLIF([CustomerID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([DateSentReminder], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateSentReminder], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateSentReminder], CAST(CASE WHEN NULLIF([NextPrepDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextPrepDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextPrepDate], CASE WHEN NULLIF([ReminderSent], N'''') IS NULL THEN NULL WHEN NULLIF([ReminderSent], N'''') IN (N''1'', N''-1'', N''true'', N''TR ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [SentRemindersLogTbl] ON;
        INSERT INTO [SentRemindersLogTbl]
        (
            [ReminderID], [ContactID], [DateSentReminder], [NextPrepDate], [ReminderSent], [HadAutoFulfilItem], [HadRecurrItems]
        )
        SELECT
            NULLIF([ReminderID], N'') AS [ReminderID], NULLIF([CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([DateSentReminder], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateSentReminder], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateSentReminder], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateSentReminder], CAST(CASE WHEN NULLIF([NextPrepDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextPrepDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextPrepDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextPrepDate], CASE WHEN NULLIF([ReminderSent], N'') IS NULL THEN NULL WHEN NULLIF([ReminderSent], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([ReminderSent], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([ReminderSent], N'')) END AS [ReminderSent], NULLIF([HadAutoFulfilItem], N'') AS [HadAutoFulfilItem], NULLIF([HadReoccurItems], N'') AS [HadRecurrItems]
        FROM [AccessSrc].[SentRemindersLogTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [SentRemindersLogTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'SentRemindersLogTbl'))
            DBCC CHECKIDENT (N'SentRemindersLogTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [SentRemindersLogTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [SentRemindersLogTbl] from ' + N'[AccessSrc].[SentRemindersLogTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'SentRemindersLogTbl') IS NOT NULL SET IDENTITY_INSERT [SentRemindersLogTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [SentRemindersLogTbl] from ' + N'[AccessSrc].[SentRemindersLogTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [SentRemindersLogTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [SentRemindersLogTbl]: missing source [AccessSrc].[SentRemindersLogTbl]';
END
GO

-- CustomersAccInfoTbl -> ContactsAccInfoTbl
-- Mapping: columnsCount=30
--   CustomersAccInfoID -> ContactsAccInfoID
--   CustomerID -> ContactID
--   RequiresPurchOrder -> RequiresPurchOrder
--   CustomerVATNo -> ContactVATNo
--   BillAddr1 -> BillAddr1
--   BillAddr2 -> BillAddr2
--   BillAddr3 -> BillAddr3
--   BillAddr4 -> BillAddr4
--   BillAddr5 -> BillAddr5
--   ShipAddr1 -> ShipAddr1
--   ShipAddr2 -> ShipAddr2
--   ShipAddr3 -> ShipAddr3
--   ShipAddr4 -> ShipAddr4
--   ShipAddr5 -> ShipAddr5
--   AccEmail -> AccEmail
--   AltAccEmail -> AltAccEmail
--   PaymentTermID -> PaymentTermID
--   Limit -> Limit
--   FullCoName -> FullCoName
--   AccFirstName -> AccFirstName
--   AccLastName -> AccLastName
--   AltAccFirstName -> AltAccFirstName
--   AltAccLastName -> AltAccLastName
--   PriceLevelID -> PriceLevelID
--   InvoiceTypeID -> InvoiceTypeID
--   RegNo -> RegNo
--   BankAccNo -> BankAccNo
--   BankBranch -> BankBranch
--   Enabled -> Enabled
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.CustomersAccInfoTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsAccInfoTbl] ([ContactsAccInfoID], [ContactID], [RequiresPurchOrder], [ContactVATNo], [BillAddr1], [BillAddr2], [BillAddr3], [BillAddr4], [BillAddr5], [ShipAddr1], [ShipAddr2], [ShipAddr3], [ShipAddr4], [ShipAddr5], [AccEmail], [AltAccEmail], [PaymentTermID], [Limit], [FullCoName], [AccFirstName], [AccLastName], [AltAccFirstName], [AltAccLastName], [PriceLevelID], [InvoiceTypeID], [RegNo], [BankAccNo], [BankBranch], [Enabled], [Notes]) SELECT NULLIF([CustomersAccInfoID], N'''') AS [ContactsAccInfoID], NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([RequiresPurchOrder], N'''') AS [RequiresPurchOrder], NULLIF([CustomerVATNo], N'''') AS [ContactVATNo], NULLIF([BillAddr1], N'''') AS [BillAddr1], NULLIF([BillAddr2], N'''') AS [BillAddr2], NULLIF([BillAddr3], N'''') AS [BillAddr3], NULLIF([BillAddr4], N'''') AS [BillAddr4], NULLIF([BillAddr5], N'''') AS [BillAddr5], NULLIF([ShipAddr1], N'''') AS [ShipAddr1], NULLIF([ShipAddr2], N'''') AS [ShipAddr2], NULLIF([ShipAddr3], N'''') AS [ShipAddr3], NULLIF([ShipAddr4], N'''') AS [ShipAddr4], NULLIF([ShipAddr5], N'''') AS [ShipAddr5], NULLIF([AccEmail], N'''') AS [AccEmail], NULLIF([AltAccEmail], N'''') AS [AltAccEmail], NULLIF([PaymentTermID], N'''') AS [PaymentTermID], NULLIF([Limit], N'''') AS [Limit], NULLIF([FullCoName], N'''') AS [FullCoName], NULLIF([AccFirstName], N'''') AS [AccFirstName], NULLIF([AccLastName], N'''') AS [AccLastName], NULLIF([AltAccFirstName], N'''') AS [AltAccFirstName], NULLIF([AltAccLastName], N'''') AS [AltAccLastName], NULLIF([Pri ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsAccInfoTbl] ON;
        INSERT INTO [ContactsAccInfoTbl]
        (
            [ContactsAccInfoID], [ContactID], [RequiresPurchOrder], [ContactVATNo], [BillAddr1], [BillAddr2], [BillAddr3], [BillAddr4], [BillAddr5], [ShipAddr1], [ShipAddr2], [ShipAddr3], [ShipAddr4], [ShipAddr5], [AccEmail], [AltAccEmail], [PaymentTermID], [Limit], [FullCoName], [AccFirstName], [AccLastName], [AltAccFirstName], [AltAccLastName], [PriceLevelID], [InvoiceTypeID], [RegNo], [BankAccNo], [BankBranch], [Enabled], [Notes]
        )
        SELECT
            NULLIF([CustomersAccInfoID], N'') AS [ContactsAccInfoID], NULLIF([CustomerID], N'') AS [ContactID], NULLIF([RequiresPurchOrder], N'') AS [RequiresPurchOrder], NULLIF([CustomerVATNo], N'') AS [ContactVATNo], NULLIF([BillAddr1], N'') AS [BillAddr1], NULLIF([BillAddr2], N'') AS [BillAddr2], NULLIF([BillAddr3], N'') AS [BillAddr3], NULLIF([BillAddr4], N'') AS [BillAddr4], NULLIF([BillAddr5], N'') AS [BillAddr5], NULLIF([ShipAddr1], N'') AS [ShipAddr1], NULLIF([ShipAddr2], N'') AS [ShipAddr2], NULLIF([ShipAddr3], N'') AS [ShipAddr3], NULLIF([ShipAddr4], N'') AS [ShipAddr4], NULLIF([ShipAddr5], N'') AS [ShipAddr5], NULLIF([AccEmail], N'') AS [AccEmail], NULLIF([AltAccEmail], N'') AS [AltAccEmail], NULLIF([PaymentTermID], N'') AS [PaymentTermID], NULLIF([Limit], N'') AS [Limit], NULLIF([FullCoName], N'') AS [FullCoName], NULLIF([AccFirstName], N'') AS [AccFirstName], NULLIF([AccLastName], N'') AS [AccLastName], NULLIF([AltAccFirstName], N'') AS [AltAccFirstName], NULLIF([AltAccLastName], N'') AS [AltAccLastName], NULLIF([PriceLevelID], N'') AS [PriceLevelID], NULLIF([InvoiceTypeID], N'') AS [InvoiceTypeID], NULLIF([RegNo], N'') AS [RegNo], NULLIF([BankAccNo], N'') AS [BankAccNo], NULLIF([BankBranch], N'') AS [BankBranch], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[CustomersAccInfoTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsAccInfoTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsAccInfoTbl'))
            DBCC CHECKIDENT (N'ContactsAccInfoTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsAccInfoTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsAccInfoTbl] from ' + N'[AccessSrc].[CustomersAccInfoTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsAccInfoTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsAccInfoTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsAccInfoTbl] from ' + N'[AccessSrc].[CustomersAccInfoTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsAccInfoTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CustomersAccInfoTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsAccInfoTbl] ([ContactsAccInfoID], [ContactID], [RequiresPurchOrder], [ContactVATNo], [BillAddr1], [BillAddr2], [BillAddr3], [BillAddr4], [BillAddr5], [ShipAddr1], [ShipAddr2], [ShipAddr3], [ShipAddr4], [ShipAddr5], [AccEmail], [AltAccEmail], [PaymentTermID], [Limit], [FullCoName], [AccFirstName], [AccLastName], [AltAccFirstName], [AltAccLastName], [PriceLevelID], [InvoiceTypeID], [RegNo], [BankAccNo], [BankBranch], [Enabled], [Notes]) SELECT NULLIF([CustomersAccInfoID], N'''') AS [ContactsAccInfoID], NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([RequiresPurchOrder], N'''') AS [RequiresPurchOrder], NULLIF([CustomerVATNo], N'''') AS [ContactVATNo], NULLIF([BillAddr1], N'''') AS [BillAddr1], NULLIF([BillAddr2], N'''') AS [BillAddr2], NULLIF([BillAddr3], N'''') AS [BillAddr3], NULLIF([BillAddr4], N'''') AS [BillAddr4], NULLIF([BillAddr5], N'''') AS [BillAddr5], NULLIF([ShipAddr1], N'''') AS [ShipAddr1], NULLIF([ShipAddr2], N'''') AS [ShipAddr2], NULLIF([ShipAddr3], N'''') AS [ShipAddr3], NULLIF([ShipAddr4], N'''') AS [ShipAddr4], NULLIF([ShipAddr5], N'''') AS [ShipAddr5], NULLIF([AccEmail], N'''') AS [AccEmail], NULLIF([AltAccEmail], N'''') AS [AltAccEmail], NULLIF([PaymentTermID], N'''') AS [PaymentTermID], NULLIF([Limit], N'''') AS [Limit], NULLIF([FullCoName], N'''') AS [FullCoName], NULLIF([AccFirstName], N'''') AS [AccFirstName], NULLIF([AccLastName], N'''') AS [AccLastName], NULLIF([AltAccFirstName], N'''') AS [AltAccFirstName], NULLIF([AltAccLastName], N'''') AS [AltAccLastName], NULLIF([Pri ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsAccInfoTbl] ON;
        INSERT INTO [ContactsAccInfoTbl]
        (
            [ContactsAccInfoID], [ContactID], [RequiresPurchOrder], [ContactVATNo], [BillAddr1], [BillAddr2], [BillAddr3], [BillAddr4], [BillAddr5], [ShipAddr1], [ShipAddr2], [ShipAddr3], [ShipAddr4], [ShipAddr5], [AccEmail], [AltAccEmail], [PaymentTermID], [Limit], [FullCoName], [AccFirstName], [AccLastName], [AltAccFirstName], [AltAccLastName], [PriceLevelID], [InvoiceTypeID], [RegNo], [BankAccNo], [BankBranch], [Enabled], [Notes]
        )
        SELECT
            NULLIF([CustomersAccInfoID], N'') AS [ContactsAccInfoID], NULLIF([CustomerID], N'') AS [ContactID], NULLIF([RequiresPurchOrder], N'') AS [RequiresPurchOrder], NULLIF([CustomerVATNo], N'') AS [ContactVATNo], NULLIF([BillAddr1], N'') AS [BillAddr1], NULLIF([BillAddr2], N'') AS [BillAddr2], NULLIF([BillAddr3], N'') AS [BillAddr3], NULLIF([BillAddr4], N'') AS [BillAddr4], NULLIF([BillAddr5], N'') AS [BillAddr5], NULLIF([ShipAddr1], N'') AS [ShipAddr1], NULLIF([ShipAddr2], N'') AS [ShipAddr2], NULLIF([ShipAddr3], N'') AS [ShipAddr3], NULLIF([ShipAddr4], N'') AS [ShipAddr4], NULLIF([ShipAddr5], N'') AS [ShipAddr5], NULLIF([AccEmail], N'') AS [AccEmail], NULLIF([AltAccEmail], N'') AS [AltAccEmail], NULLIF([PaymentTermID], N'') AS [PaymentTermID], NULLIF([Limit], N'') AS [Limit], NULLIF([FullCoName], N'') AS [FullCoName], NULLIF([AccFirstName], N'') AS [AccFirstName], NULLIF([AccLastName], N'') AS [AccLastName], NULLIF([AltAccFirstName], N'') AS [AltAccFirstName], NULLIF([AltAccLastName], N'') AS [AltAccLastName], NULLIF([PriceLevelID], N'') AS [PriceLevelID], NULLIF([InvoiceTypeID], N'') AS [InvoiceTypeID], NULLIF([RegNo], N'') AS [RegNo], NULLIF([BankAccNo], N'') AS [BankAccNo], NULLIF([BankBranch], N'') AS [BankBranch], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [CustomersAccInfoTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsAccInfoTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsAccInfoTbl'))
            DBCC CHECKIDENT (N'ContactsAccInfoTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsAccInfoTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsAccInfoTbl] from ' + N'[CustomersAccInfoTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsAccInfoTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsAccInfoTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsAccInfoTbl] from ' + N'[CustomersAccInfoTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsAccInfoTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- CityPrepDaysTbl -> AreaPrepDaysTbl
-- Mapping: columnsCount=5
--   CityPrepDaysID -> AreaPrepDaysID
--   CityID -> AreaID
--   PrepDayOfWeekID -> PrepDayOfWeekID
--   DeliveryDelayDays -> DeliveryDelayDays
--   DeliveryOrder -> DeliveryOrder
IF OBJECT_ID(N'AccessSrc.CityPrepDaysTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [AreaPrepDaysTbl] ([AreaPrepDaysID], [AreaID], [PrepDayOfWeekID], [DeliveryDelayDays], [DeliveryOrder]) SELECT NULLIF([CityPrepDaysID], N'''') AS [AreaPrepDaysID], NULLIF([CityID], N'''') AS [AreaID], NULLIF([PrepDayOfWeekID], N'''') AS [PrepDayOfWeekID], NULLIF([DeliveryDelayDays], N'''') AS [DeliveryDelayDays], NULLIF([DeliveryOrder], N'''') AS [DeliveryOrder] FROM [AccessSrc].[CityPrepDaysTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [AreaPrepDaysTbl] ON;
        INSERT INTO [AreaPrepDaysTbl]
        (
            [AreaPrepDaysID], [AreaID], [PrepDayOfWeekID], [DeliveryDelayDays], [DeliveryOrder]
        )
        SELECT
            NULLIF([CityPrepDaysID], N'') AS [AreaPrepDaysID], NULLIF([CityID], N'') AS [AreaID], NULLIF([PrepDayOfWeekID], N'') AS [PrepDayOfWeekID], NULLIF([DeliveryDelayDays], N'') AS [DeliveryDelayDays], NULLIF([DeliveryOrder], N'') AS [DeliveryOrder]
        FROM [AccessSrc].[CityPrepDaysTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [AreaPrepDaysTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'AreaPrepDaysTbl'))
            DBCC CHECKIDENT (N'AreaPrepDaysTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [AreaPrepDaysTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [AreaPrepDaysTbl] from ' + N'[AccessSrc].[CityPrepDaysTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'AreaPrepDaysTbl') IS NOT NULL SET IDENTITY_INSERT [AreaPrepDaysTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [AreaPrepDaysTbl] from ' + N'[AccessSrc].[CityPrepDaysTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [AreaPrepDaysTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CityPrepDaysTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [AreaPrepDaysTbl] ([AreaPrepDaysID], [AreaID], [PrepDayOfWeekID], [DeliveryDelayDays], [DeliveryOrder]) SELECT NULLIF([CityPrepDaysID], N'''') AS [AreaPrepDaysID], NULLIF([CityID], N'''') AS [AreaID], NULLIF([PrepDayOfWeekID], N'''') AS [PrepDayOfWeekID], NULLIF([DeliveryDelayDays], N'''') AS [DeliveryDelayDays], NULLIF([DeliveryOrder], N'''') AS [DeliveryOrder] FROM [CityPrepDaysTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [AreaPrepDaysTbl] ON;
        INSERT INTO [AreaPrepDaysTbl]
        (
            [AreaPrepDaysID], [AreaID], [PrepDayOfWeekID], [DeliveryDelayDays], [DeliveryOrder]
        )
        SELECT
            NULLIF([CityPrepDaysID], N'') AS [AreaPrepDaysID], NULLIF([CityID], N'') AS [AreaID], NULLIF([PrepDayOfWeekID], N'') AS [PrepDayOfWeekID], NULLIF([DeliveryDelayDays], N'') AS [DeliveryDelayDays], NULLIF([DeliveryOrder], N'') AS [DeliveryOrder]
        FROM [CityPrepDaysTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [AreaPrepDaysTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'AreaPrepDaysTbl'))
            DBCC CHECKIDENT (N'AreaPrepDaysTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [AreaPrepDaysTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [AreaPrepDaysTbl] from ' + N'[CityPrepDaysTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'AreaPrepDaysTbl') IS NOT NULL SET IDENTITY_INSERT [AreaPrepDaysTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [AreaPrepDaysTbl] from ' + N'[CityPrepDaysTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [AreaPrepDaysTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ClientAwayPeriodTbl -> ContactsAwayPeriodTbl
-- Mapping: columnsCount=5
--   AwayPeriodID -> AwayPeriodID
--   ClientID -> ContactID
--   AwayStartDate -> AwayStartDate
--   AwayEndDate -> AwayEndDate
--   ReasonID -> ReasonID
IF OBJECT_ID(N'AccessSrc.ClientAwayPeriodTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsAwayPeriodTbl] ([AwayPeriodID], [ContactID], [AwayStartDate], [AwayEndDate], [ReasonID]) SELECT NULLIF([AwayPeriodID], N'''') AS [AwayPeriodID], NULLIF([ClientID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([AwayStartDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayStartDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayStartDate], CAST(CASE WHEN NULLIF([AwayEndDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayEndDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayEndDate], NULLIF([ReasonID], N'''') AS [ReasonID] FROM [AccessSrc].[ClientAwayPeriodTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsAwayPeriodTbl] ON;
        INSERT INTO [ContactsAwayPeriodTbl]
        (
            [AwayPeriodID], [ContactID], [AwayStartDate], [AwayEndDate], [ReasonID]
        )
        SELECT
            NULLIF([AwayPeriodID], N'') AS [AwayPeriodID], NULLIF([ClientID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([AwayStartDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayStartDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayStartDate], CAST(CASE WHEN NULLIF([AwayEndDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayEndDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayEndDate], NULLIF([ReasonID], N'') AS [ReasonID]
        FROM [AccessSrc].[ClientAwayPeriodTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsAwayPeriodTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsAwayPeriodTbl'))
            DBCC CHECKIDENT (N'ContactsAwayPeriodTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsAwayPeriodTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsAwayPeriodTbl] from ' + N'[AccessSrc].[ClientAwayPeriodTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsAwayPeriodTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsAwayPeriodTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsAwayPeriodTbl] from ' + N'[AccessSrc].[ClientAwayPeriodTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsAwayPeriodTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ClientAwayPeriodTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsAwayPeriodTbl] ([AwayPeriodID], [ContactID], [AwayStartDate], [AwayEndDate], [ReasonID]) SELECT NULLIF([AwayPeriodID], N'''') AS [AwayPeriodID], NULLIF([ClientID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([AwayStartDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayStartDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayStartDate], CAST(CASE WHEN NULLIF([AwayEndDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayEndDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayEndDate], NULLIF([ReasonID], N'''') AS [ReasonID] FROM [ClientAwayPeriodTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsAwayPeriodTbl] ON;
        INSERT INTO [ContactsAwayPeriodTbl]
        (
            [AwayPeriodID], [ContactID], [AwayStartDate], [AwayEndDate], [ReasonID]
        )
        SELECT
            NULLIF([AwayPeriodID], N'') AS [AwayPeriodID], NULLIF([ClientID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([AwayStartDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayStartDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayStartDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayStartDate], CAST(CASE WHEN NULLIF([AwayEndDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([AwayEndDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([AwayEndDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [AwayEndDate], NULLIF([ReasonID], N'') AS [ReasonID]
        FROM [ClientAwayPeriodTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsAwayPeriodTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsAwayPeriodTbl'))
            DBCC CHECKIDENT (N'ContactsAwayPeriodTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsAwayPeriodTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsAwayPeriodTbl] from ' + N'[ClientAwayPeriodTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsAwayPeriodTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsAwayPeriodTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsAwayPeriodTbl] from ' + N'[ClientAwayPeriodTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsAwayPeriodTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ItemUsageTbl -> ContactsItemUsageTbl
-- Mapping: columnsCount=8
--   ClientUsageLineNo -> ContactItemUsageLineNo
--   CustomerID -> ContactID
--   Date -> DeliveryDate
--   ItemProvided -> ItemProvidedID
--   AmountProvided -> QtyProvided
--   PrepTypeID -> ItemPrepTypeID
--   PackagingID -> ItemPackagingID
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.ItemUsageTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsItemUsageTbl] ([ContactItemUsageLineNo], [ContactID], [DeliveryDate], [ItemProvidedID], [QtyProvided], [ItemPrepTypeID], [ItemPackagingID], [Notes]) SELECT NULLIF([ClientUsageLineNo], N'''') AS [ContactItemUsageLineNo], NULLIF([CustomerID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([Date], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([ItemProvided], N'''') AS [ItemProvidedID], NULLIF([AmountProvided], N'''') AS [QtyProvided], NULLIF([PrepTypeID], N'''') AS [ItemPrepTypeID], NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[ItemUsageTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsItemUsageTbl] ON;
        INSERT INTO [ContactsItemUsageTbl]
        (
            [ContactItemUsageLineNo], [ContactID], [DeliveryDate], [ItemProvidedID], [QtyProvided], [ItemPrepTypeID], [ItemPackagingID], [Notes]
        )
        SELECT
            NULLIF([ClientUsageLineNo], N'') AS [ContactItemUsageLineNo], NULLIF([CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([Date], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([ItemProvided], N'') AS [ItemProvidedID], NULLIF([AmountProvided], N'') AS [QtyProvided], NULLIF([PrepTypeID], N'') AS [ItemPrepTypeID], NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[ItemUsageTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsItemUsageTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsItemUsageTbl'))
            DBCC CHECKIDENT (N'ContactsItemUsageTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemUsageTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemUsageTbl] from ' + N'[AccessSrc].[ItemUsageTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsItemUsageTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsItemUsageTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsItemUsageTbl] from ' + N'[AccessSrc].[ItemUsageTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemUsageTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ItemUsageTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsItemUsageTbl] ([ContactItemUsageLineNo], [ContactID], [DeliveryDate], [ItemProvidedID], [QtyProvided], [ItemPrepTypeID], [ItemPackagingID], [Notes]) SELECT NULLIF([ClientUsageLineNo], N'''') AS [ContactItemUsageLineNo], NULLIF([CustomerID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([Date], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([ItemProvided], N'''') AS [ItemProvidedID], NULLIF([AmountProvided], N'''') AS [QtyProvided], NULLIF([PrepTypeID], N'''') AS [ItemPrepTypeID], NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([Notes], N'''') AS [Notes] FROM [ItemUsageTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsItemUsageTbl] ON;
        INSERT INTO [ContactsItemUsageTbl]
        (
            [ContactItemUsageLineNo], [ContactID], [DeliveryDate], [ItemProvidedID], [QtyProvided], [ItemPrepTypeID], [ItemPackagingID], [Notes]
        )
        SELECT
            NULLIF([ClientUsageLineNo], N'') AS [ContactItemUsageLineNo], NULLIF([CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([Date], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([Date], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([Date], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([Date], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([ItemProvided], N'') AS [ItemProvidedID], NULLIF([AmountProvided], N'') AS [QtyProvided], NULLIF([PrepTypeID], N'') AS [ItemPrepTypeID], NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([Notes], N'') AS [Notes]
        FROM [ItemUsageTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsItemUsageTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsItemUsageTbl'))
            DBCC CHECKIDENT (N'ContactsItemUsageTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemUsageTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemUsageTbl] from ' + N'[ItemUsageTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsItemUsageTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsItemUsageTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsItemUsageTbl] from ' + N'[ItemUsageTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemUsageTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- CustomersTbl -> ContactsTbl
-- Mapping: columnsCount=42
--   CustomerID -> ContactID
--   CompanyName -> CompanyName
--   ContactTitle -> ContactTitle
--   ContactFirstName -> ContactFirstName
--   ContactLastName -> ContactLastName
--   ContactAltFirstName -> ContactAltFirstName
--   ContactAltLastName -> ContactAltLastName
--   Department -> Department
--   BillingAddress -> BillingAddress
--   City -> Area
--   StateOrProvince -> StateOrProvince
--   PostalCode -> PostalCode
--   Country/Region -> Country/Region
--   PhoneNumber -> PhoneNumber
--   Extension -> Extension
--   FaxNumber -> FaxNumber
--   CellNumber -> CellNumber
--   EmailAddress -> EmailAddress
--   AltEmailAddress -> AltEmailAddress
--   ContractNo -> ContractNo
--   CustomerTypeID -> ContactTypeID
--   EquipType -> EquipTypeID
--   CoffeePreference -> ItemPrefID
--   PriPrefQty -> PriPrefQty
--   PrefPrepTypeID -> PrefItemPrepTypeID
--   PrefPackagingID -> PrefItemPackagingID
--   SecondaryPreference -> SecondaryItemPrefID
--   SecPrefQty -> SecPrefQty
--   TypicallySecToo -> TypicallySecToo
--   PreferedAgent -> PreferedAgentID
--   SalesAgentID -> SalesAgentID
--   MachineSN -> EquipentSN
--   UsesFilter -> UsesFilter
--   autofulfill -> AutoFulfill
--   enabled -> Enabled
--   PredictionDisabled -> PredictionDisabled
--   AlwaysSendChkUp -> AlwaysSendChkUp
--   NormallyResponds -> NormallyResponds
--   ReminderCount -> ReminderCount
--   Notes -> Notes
--   SendDeliveryConfirmation -> SendDeliveryConfirmation
--   LastDateSentReminder -> LastDateSentReminder
IF OBJECT_ID(N'AccessSrc.CustomersTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsTbl] ([ContactID], [CompanyName], [ContactTitle], [ContactFirstName], [ContactLastName], [ContactAltFirstName], [ContactAltLastName], [Department], [BillingAddress], [Area], [StateOrProvince], [PostalCode], [Country/Region], [PhoneNumber], [Extension], [FaxNumber], [CellNumber], [EmailAddress], [AltEmailAddress], [ContractNo], [ContactTypeID], [EquipTypeID], [ItemPrefID], [PriPrefQty], [PrefItemPrepTypeID], [PrefItemPackagingID], [SecondaryItemPrefID], [SecPrefQty], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [EquipentSN], [UsesFilter], [AutoFulfill], [Enabled], [PredictionDisabled], [AlwaysSendChkUp], [NormallyResponds], [ReminderCount], [Notes], [SendDeliveryConfirmation], [LastDateSentReminder]) SELECT NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([CompanyName], N'''') AS [CompanyName], NULLIF([ContactTitle], N'''') AS [ContactTitle], NULLIF([ContactFirstName], N'''') AS [ContactFirstName], NULLIF([ContactLastName], N'''') AS [ContactLastName], NULLIF([ContactAltFirstName], N'''') AS [ContactAltFirstName], NULLIF([ContactAltLastName], N'''') AS [ContactAltLastName], NULLIF([Department], N'''') AS [Department], NULLIF([BillingAddress], N'''') AS [BillingAddress], NULLIF([City], N'''') AS [Area], NULLIF([StateOrProvince], N'''') AS [StateOrProvince], NULLIF([PostalCode], N'''') AS [PostalCode], NULLIF([Country/Region], N'''') AS [Country/Region], NULLIF([PhoneNumber], N'''') AS [PhoneNumber], NULLIF([Extension], N'''') AS [Extension], NULLIF([FaxNumber], N'''') AS [FaxNu ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsTbl] ON;
        INSERT INTO [ContactsTbl]
        (
            [ContactID], [CompanyName], [ContactTitle], [ContactFirstName], [ContactLastName], [ContactAltFirstName], [ContactAltLastName], [Department], [BillingAddress], [Area], [StateOrProvince], [PostalCode], [Country/Region], [PhoneNumber], [Extension], [FaxNumber], [CellNumber], [EmailAddress], [AltEmailAddress], [ContractNo], [ContactTypeID], [EquipTypeID], [ItemPrefID], [PriPrefQty], [PrefItemPrepTypeID], [PrefItemPackagingID], [SecondaryItemPrefID], [SecPrefQty], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [EquipentSN], [UsesFilter], [AutoFulfill], [Enabled], [PredictionDisabled], [AlwaysSendChkUp], [NormallyResponds], [ReminderCount], [Notes], [SendDeliveryConfirmation], [LastDateSentReminder]
        )
        SELECT
            NULLIF([CustomerID], N'') AS [ContactID], NULLIF([CompanyName], N'') AS [CompanyName], NULLIF([ContactTitle], N'') AS [ContactTitle], NULLIF([ContactFirstName], N'') AS [ContactFirstName], NULLIF([ContactLastName], N'') AS [ContactLastName], NULLIF([ContactAltFirstName], N'') AS [ContactAltFirstName], NULLIF([ContactAltLastName], N'') AS [ContactAltLastName], NULLIF([Department], N'') AS [Department], NULLIF([BillingAddress], N'') AS [BillingAddress], NULLIF([City], N'') AS [Area], NULLIF([StateOrProvince], N'') AS [StateOrProvince], NULLIF([PostalCode], N'') AS [PostalCode], NULLIF([Country/Region], N'') AS [Country/Region], NULLIF([PhoneNumber], N'') AS [PhoneNumber], NULLIF([Extension], N'') AS [Extension], NULLIF([FaxNumber], N'') AS [FaxNumber], NULLIF([CellNumber], N'') AS [CellNumber], NULLIF([EmailAddress], N'') AS [EmailAddress], NULLIF([AltEmailAddress], N'') AS [AltEmailAddress], NULLIF([ContractNo], N'') AS [ContractNo], NULLIF([CustomerTypeID], N'') AS [ContactTypeID], NULLIF([EquipType], N'') AS [EquipTypeID], NULLIF([CoffeePreference], N'') AS [ItemPrefID], NULLIF([PriPrefQty], N'') AS [PriPrefQty], NULLIF([PrefPrepTypeID], N'') AS [PrefItemPrepTypeID], NULLIF([PrefPackagingID], N'') AS [PrefItemPackagingID], NULLIF([SecondaryPreference], N'') AS [SecondaryItemPrefID], NULLIF([SecPrefQty], N'') AS [SecPrefQty], CASE WHEN NULLIF([TypicallySecToo], N'') IS NULL THEN NULL WHEN NULLIF([TypicallySecToo], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([TypicallySecToo], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([TypicallySecToo], N'')) END AS [TypicallySecToo], NULLIF([PreferedAgent], N'') AS [PreferedAgentID], NULLIF([SalesAgentID], N'') AS [SalesAgentID], NULLIF([MachineSN], N'') AS [EquipentSN], CASE WHEN NULLIF([UsesFilter], N'') IS NULL THEN NULL WHEN NULLIF([UsesFilter], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([UsesFilter], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([UsesFilter], N'')) END AS [UsesFilter], CASE WHEN NULLIF([autofulfill], N'') IS NULL THEN NULL WHEN NULLIF([autofulfill], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([autofulfill], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([autofulfill], N'')) END AS [AutoFulfill], CASE WHEN NULLIF([enabled], N'') IS NULL THEN NULL WHEN NULLIF([enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([enabled], N'')) END AS [Enabled], NULLIF([PredictionDisabled], N'') AS [PredictionDisabled], NULLIF([AlwaysSendChkUp], N'') AS [AlwaysSendChkUp], NULLIF([NormallyResponds], N'') AS [NormallyResponds], NULLIF([ReminderCount], N'') AS [ReminderCount], NULLIF([Notes], N'') AS [Notes], CASE WHEN NULLIF([SendDeliveryConfirmation], N'') IS NULL THEN NULL WHEN NULLIF([SendDeliveryConfirmation], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([SendDeliveryConfirmation], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([SendDeliveryConfirmation], N'')) END AS [SendDeliveryConfirmation], CAST(CASE WHEN NULLIF([LastDateSentReminder], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastDateSentReminder], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastDateSentReminder]
        FROM [AccessSrc].[CustomersTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsTbl'))
            DBCC CHECKIDENT (N'ContactsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsTbl] from ' + N'[AccessSrc].[CustomersTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsTbl] from ' + N'[AccessSrc].[CustomersTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CustomersTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsTbl] ([ContactID], [CompanyName], [ContactTitle], [ContactFirstName], [ContactLastName], [ContactAltFirstName], [ContactAltLastName], [Department], [BillingAddress], [Area], [StateOrProvince], [PostalCode], [Country/Region], [PhoneNumber], [Extension], [FaxNumber], [CellNumber], [EmailAddress], [AltEmailAddress], [ContractNo], [ContactTypeID], [EquipTypeID], [ItemPrefID], [PriPrefQty], [PrefItemPrepTypeID], [PrefItemPackagingID], [SecondaryItemPrefID], [SecPrefQty], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [EquipentSN], [UsesFilter], [AutoFulfill], [Enabled], [PredictionDisabled], [AlwaysSendChkUp], [NormallyResponds], [ReminderCount], [Notes], [SendDeliveryConfirmation], [LastDateSentReminder]) SELECT NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([CompanyName], N'''') AS [CompanyName], NULLIF([ContactTitle], N'''') AS [ContactTitle], NULLIF([ContactFirstName], N'''') AS [ContactFirstName], NULLIF([ContactLastName], N'''') AS [ContactLastName], NULLIF([ContactAltFirstName], N'''') AS [ContactAltFirstName], NULLIF([ContactAltLastName], N'''') AS [ContactAltLastName], NULLIF([Department], N'''') AS [Department], NULLIF([BillingAddress], N'''') AS [BillingAddress], NULLIF([City], N'''') AS [Area], NULLIF([StateOrProvince], N'''') AS [StateOrProvince], NULLIF([PostalCode], N'''') AS [PostalCode], NULLIF([Country/Region], N'''') AS [Country/Region], NULLIF([PhoneNumber], N'''') AS [PhoneNumber], NULLIF([Extension], N'''') AS [Extension], NULLIF([FaxNumber], N'''') AS [FaxNu ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsTbl] ON;
        INSERT INTO [ContactsTbl]
        (
            [ContactID], [CompanyName], [ContactTitle], [ContactFirstName], [ContactLastName], [ContactAltFirstName], [ContactAltLastName], [Department], [BillingAddress], [Area], [StateOrProvince], [PostalCode], [Country/Region], [PhoneNumber], [Extension], [FaxNumber], [CellNumber], [EmailAddress], [AltEmailAddress], [ContractNo], [ContactTypeID], [EquipTypeID], [ItemPrefID], [PriPrefQty], [PrefItemPrepTypeID], [PrefItemPackagingID], [SecondaryItemPrefID], [SecPrefQty], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [EquipentSN], [UsesFilter], [AutoFulfill], [Enabled], [PredictionDisabled], [AlwaysSendChkUp], [NormallyResponds], [ReminderCount], [Notes], [SendDeliveryConfirmation], [LastDateSentReminder]
        )
        SELECT
            NULLIF([CustomerID], N'') AS [ContactID], NULLIF([CompanyName], N'') AS [CompanyName], NULLIF([ContactTitle], N'') AS [ContactTitle], NULLIF([ContactFirstName], N'') AS [ContactFirstName], NULLIF([ContactLastName], N'') AS [ContactLastName], NULLIF([ContactAltFirstName], N'') AS [ContactAltFirstName], NULLIF([ContactAltLastName], N'') AS [ContactAltLastName], NULLIF([Department], N'') AS [Department], NULLIF([BillingAddress], N'') AS [BillingAddress], NULLIF([City], N'') AS [Area], NULLIF([StateOrProvince], N'') AS [StateOrProvince], NULLIF([PostalCode], N'') AS [PostalCode], NULLIF([Country/Region], N'') AS [Country/Region], NULLIF([PhoneNumber], N'') AS [PhoneNumber], NULLIF([Extension], N'') AS [Extension], NULLIF([FaxNumber], N'') AS [FaxNumber], NULLIF([CellNumber], N'') AS [CellNumber], NULLIF([EmailAddress], N'') AS [EmailAddress], NULLIF([AltEmailAddress], N'') AS [AltEmailAddress], NULLIF([ContractNo], N'') AS [ContractNo], NULLIF([CustomerTypeID], N'') AS [ContactTypeID], NULLIF([EquipType], N'') AS [EquipTypeID], NULLIF([CoffeePreference], N'') AS [ItemPrefID], NULLIF([PriPrefQty], N'') AS [PriPrefQty], NULLIF([PrefPrepTypeID], N'') AS [PrefItemPrepTypeID], NULLIF([PrefPackagingID], N'') AS [PrefItemPackagingID], NULLIF([SecondaryPreference], N'') AS [SecondaryItemPrefID], NULLIF([SecPrefQty], N'') AS [SecPrefQty], CASE WHEN NULLIF([TypicallySecToo], N'') IS NULL THEN NULL WHEN NULLIF([TypicallySecToo], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([TypicallySecToo], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([TypicallySecToo], N'')) END AS [TypicallySecToo], NULLIF([PreferedAgent], N'') AS [PreferedAgentID], NULLIF([SalesAgentID], N'') AS [SalesAgentID], NULLIF([MachineSN], N'') AS [EquipentSN], CASE WHEN NULLIF([UsesFilter], N'') IS NULL THEN NULL WHEN NULLIF([UsesFilter], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([UsesFilter], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([UsesFilter], N'')) END AS [UsesFilter], CASE WHEN NULLIF([autofulfill], N'') IS NULL THEN NULL WHEN NULLIF([autofulfill], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([autofulfill], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([autofulfill], N'')) END AS [AutoFulfill], CASE WHEN NULLIF([enabled], N'') IS NULL THEN NULL WHEN NULLIF([enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([enabled], N'')) END AS [Enabled], NULLIF([PredictionDisabled], N'') AS [PredictionDisabled], NULLIF([AlwaysSendChkUp], N'') AS [AlwaysSendChkUp], NULLIF([NormallyResponds], N'') AS [NormallyResponds], NULLIF([ReminderCount], N'') AS [ReminderCount], NULLIF([Notes], N'') AS [Notes], CASE WHEN NULLIF([SendDeliveryConfirmation], N'') IS NULL THEN NULL WHEN NULLIF([SendDeliveryConfirmation], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([SendDeliveryConfirmation], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([SendDeliveryConfirmation], N'')) END AS [SendDeliveryConfirmation], CAST(CASE WHEN NULLIF([LastDateSentReminder], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastDateSentReminder], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastDateSentReminder], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastDateSentReminder]
        FROM [CustomersTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsTbl'))
            DBCC CHECKIDENT (N'ContactsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsTbl] from ' + N'[CustomersTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsTbl] from ' + N'[CustomersTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ClientUsageLinesTbl -> ContactsItemSvcSummaryTbl
-- Mapping: columnsCount=7
--   ClientUsageLineNo -> ContactsItemSvcSummaryId
--   CustomerID -> ContactID
--   Date -> UsageDate
--   CupCount -> CupCount
--   ServiceTypeId -> ItemServiceTypeID
--   Qty -> Qty
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.ClientUsageLinesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsItemSvcSummaryTbl] with dates (only valid ContactIDs)';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] ON;
        INSERT INTO [ContactsItemSvcSummaryTbl]
        (
            [ContactsItemSvcSummaryId], [ContactID], [UsageDate], [CupCount], [ItemServiceTypeID], [Qty], [Notes]
        )
        SELECT
            NULLIF(src.[ClientUsageLineNo], N'') AS [ContactsItemSvcSummaryId], NULLIF(src.[CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF(src.[Date], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF(src.[Date], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 127), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 126), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 121), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 103), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 101), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDate], NULLIF(src.[CupCount], N'') AS [CupCount], NULLIF(src.[ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF(src.[Qty], N'') AS [Qty], NULLIF(src.[Notes], N'') AS [Notes]
        FROM [AccessSrc].[ClientUsageLinesTbl] src
        INNER JOIN ContactsTbl c ON c.ContactID = src.CustomerID  -- Only migrate valid ContactIDs
        WHERE src.CustomerID IS NOT NULL;
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsItemSvcSummaryTbl'))
            DBCC CHECKIDENT (N'ContactsItemSvcSummaryTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemSvcSummaryTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemSvcSummaryTbl] from ' + N'[AccessSrc].[ClientUsageLinesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsItemSvcSummaryTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsItemSvcSummaryTbl] from ' + N'[AccessSrc].[ClientUsageLinesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemSvcSummaryTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ClientUsageLinesTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactsItemSvcSummaryTbl] with dates (only valid ContactIDs)';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] ON;
        INSERT INTO [ContactsItemSvcSummaryTbl]
        (
            [ContactsItemSvcSummaryId], [ContactID], [UsageDate], [CupCount], [ItemServiceTypeID], [Qty], [Notes]
        )
        SELECT
            NULLIF(src.[ClientUsageLineNo], N'') AS [ContactsItemSvcSummaryId], NULLIF(src.[CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF(src.[Date], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF(src.[Date], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 127), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 126), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 121), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 103), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N''), 101), TRY_CONVERT(datetime2(7), NULLIF(src.[Date], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDate], NULLIF(src.[CupCount], N'') AS [CupCount], NULLIF(src.[ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF(src.[Qty], N'') AS [Qty], NULLIF(src.[Notes], N'') AS [Notes]
        FROM [ClientUsageLinesTbl] src
        INNER JOIN ContactsTbl c ON c.ContactID = src.CustomerID  -- Only migrate valid ContactIDs
        WHERE src.CustomerID IS NOT NULL;
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactsItemSvcSummaryTbl'))
            DBCC CHECKIDENT (N'ContactsItemSvcSummaryTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemSvcSummaryTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemSvcSummaryTbl] from ' + N'[ClientUsageLinesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactsItemSvcSummaryTbl') IS NOT NULL SET IDENTITY_INSERT [ContactsItemSvcSummaryTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactsItemSvcSummaryTbl] from ' + N'[ClientUsageLinesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemSvcSummaryTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ClientUsageTbl -> ContactsItemsPredictedTbl
-- Mapping: columnsCount=12
--   CustomerId -> ContactID
--   LastCupCount -> LastCupCount
--   NextCoffeeBy -> NextCoffeeBy
--   NextCleanOn -> NextCleanOn
--   NextFilterEst -> NextFilterEst
--   NextDescaleEst -> NextDescaleEst
--   NextServiceEst -> NextServiceEst
--   DailyConsumption -> DailyConsumption
--   FilterAveCount -> FilterAveCount
--   DescaleAveCount -> DescaleAveCount
--   ServiceAveCount -> ServiceAveCount
--   CleanAveCount -> CleanAveCount
IF OBJECT_ID(N'AccessSrc.ClientUsageTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [ContactsItemsPredictedTbl] with dates (only valid ContactIDs)';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [ContactsItemsPredictedTbl]
        (
            [ContactID], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount], [CleanAveCount]
        )
        SELECT
            NULLIF(src.[CustomerId], N'') AS [ContactID], NULLIF(src.[LastCupCount], N'') AS [LastCupCount], CAST(src.[NextCoffeeBy] AS DATE) AS [NextCoffeeBy], CAST(src.[NextCleanOn] AS DATE) AS [NextCleanOn], CAST(src.[NextFilterEst] AS DATE) AS [NextFilterEst], CAST(src.[NextDescaleEst] AS DATE) AS [NextDescaleEst], CAST(src.[NextServiceEst] AS DATE) AS [NextServiceEst], NULLIF(src.[DailyConsumption], N'') AS [DailyConsumption], NULLIF(src.[FilterAveCount], N'') AS [FilterAveCount], NULLIF(src.[DescaleAveCount], N'') AS [DescaleAveCount], NULLIF(src.[ServiceAveCount], N'') AS [ServiceAveCount], NULLIF(src.[CleanAveCount], N'') AS [CleanAveCount]
        FROM [AccessSrc].[ClientUsageTbl] src
        INNER JOIN ContactsTbl c ON c.ContactID = src.CustomerId  -- Only migrate valid ContactIDs
        WHERE src.CustomerId IS NOT NULL;
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemsPredictedTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemsPredictedTbl] from ' + N'[AccessSrc].[ClientUsageTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [ContactsItemsPredictedTbl] from ' + N'[AccessSrc].[ClientUsageTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemsPredictedTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ClientUsageTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=OFF):';
    PRINT N'INSERT INTO [ContactsItemsPredictedTbl] with dates (only valid ContactIDs)';
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO [ContactsItemsPredictedTbl]
        (
            [ContactID], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount], [CleanAveCount]
        )
        SELECT
            NULLIF(src.[CustomerId], N'') AS [ContactID], NULLIF(src.[LastCupCount], N'') AS [LastCupCount], CAST(src.[NextCoffeeBy] AS DATE) AS [NextCoffeeBy], CAST(src.[NextCleanOn] AS DATE) AS [NextCleanOn], CAST(src.[NextFilterEst] AS DATE) AS [NextFilterEst], CAST(src.[NextDescaleEst] AS DATE) AS [NextDescaleEst], CAST(src.[NextServiceEst] AS DATE) AS [NextServiceEst], NULLIF(src.[DailyConsumption], N'') AS [DailyConsumption], NULLIF(src.[FilterAveCount], N'') AS [FilterAveCount], NULLIF(src.[DescaleAveCount], N'') AS [DescaleAveCount], NULLIF(src.[ServiceAveCount], N'') AS [ServiceAveCount], NULLIF(src.[CleanAveCount], N'') AS [CleanAveCount]
        FROM [ClientUsageTbl] src
        INNER JOIN ContactsTbl c ON c.ContactID = src.CustomerId  -- Only migrate valid ContactIDs
        WHERE src.CustomerId IS NOT NULL;
        DECLARE @rowsInserted int = @@ROWCOUNT;
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactsItemsPredictedTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactsItemsPredictedTbl] from ' + N'[ClientUsageTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT 'ERROR migrate [ContactsItemsPredictedTbl] from ' + N'[ClientUsageTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactsItemsPredictedTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- CustomerTrackedServiceItemsTbl -> ContactTrackedServiceItemsTbl
-- Mapping: columnsCount=4
--   CustomerTrackedServiceItemsID -> ContactTrackedServiceItemsID
--   CustomerTypeID -> ContactTypeID
--   ServiceTypeID -> ItemServiceTypeID
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.CustomerTrackedServiceItemsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactTrackedServiceItemsTbl] ([ContactTrackedServiceItemsID], [ContactTypeID], [ItemServiceTypeID], [Notes]) SELECT NULLIF([CustomerTrackedServiceItemsID], N'''') AS [ContactTrackedServiceItemsID], NULLIF([CustomerTypeID], N'''') AS [ContactTypeID], NULLIF([ServiceTypeID], N'''') AS [ItemServiceTypeID], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[CustomerTrackedServiceItemsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] ON;
        INSERT INTO [ContactTrackedServiceItemsTbl]
        (
            [ContactTrackedServiceItemsID], [ContactTypeID], [ItemServiceTypeID], [Notes]
        )
        SELECT
            NULLIF([CustomerTrackedServiceItemsID], N'') AS [ContactTrackedServiceItemsID], NULLIF([CustomerTypeID], N'') AS [ContactTypeID], NULLIF([ServiceTypeID], N'') AS [ItemServiceTypeID], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[CustomerTrackedServiceItemsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactTrackedServiceItemsTbl'))
            DBCC CHECKIDENT (N'ContactTrackedServiceItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactTrackedServiceItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactTrackedServiceItemsTbl] from ' + N'[AccessSrc].[CustomerTrackedServiceItemsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactTrackedServiceItemsTbl') IS NOT NULL SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactTrackedServiceItemsTbl] from ' + N'[AccessSrc].[CustomerTrackedServiceItemsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactTrackedServiceItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.CustomerTrackedServiceItemsTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ContactTrackedServiceItemsTbl] ([ContactTrackedServiceItemsID], [ContactTypeID], [ItemServiceTypeID], [Notes]) SELECT NULLIF([CustomerTrackedServiceItemsID], N'''') AS [ContactTrackedServiceItemsID], NULLIF([CustomerTypeID], N'''') AS [ContactTypeID], NULLIF([ServiceTypeID], N'''') AS [ItemServiceTypeID], NULLIF([Notes], N'''') AS [Notes] FROM [CustomerTrackedServiceItemsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] ON;
        INSERT INTO [ContactTrackedServiceItemsTbl]
        (
            [ContactTrackedServiceItemsID], [ContactTypeID], [ItemServiceTypeID], [Notes]
        )
        SELECT
            NULLIF([CustomerTrackedServiceItemsID], N'') AS [ContactTrackedServiceItemsID], NULLIF([CustomerTypeID], N'') AS [ContactTypeID], NULLIF([ServiceTypeID], N'') AS [ItemServiceTypeID], NULLIF([Notes], N'') AS [Notes]
        FROM [CustomerTrackedServiceItemsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ContactTrackedServiceItemsTbl'))
            DBCC CHECKIDENT (N'ContactTrackedServiceItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ContactTrackedServiceItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ContactTrackedServiceItemsTbl] from ' + N'[CustomerTrackedServiceItemsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ContactTrackedServiceItemsTbl') IS NOT NULL SET IDENTITY_INSERT [ContactTrackedServiceItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ContactTrackedServiceItemsTbl] from ' + N'[CustomerTrackedServiceItemsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ContactTrackedServiceItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ItemGroupTbl -> ItemGroupsTbl
-- Mapping: columnsCount=6
--   ItemGroupID -> ItemGroupID
--   GroupItemTypeID -> GroupReferenceItemID
--   ItemTypeID -> ItemID
--   ItemTypeSortPos -> ItemSortPos
--   Enabled -> Enabled
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.ItemGroupTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemGroupsTbl] ([ItemGroupID], [GroupReferenceItemID], [ItemID], [ItemSortPos], [Enabled], [Notes]) SELECT NULLIF([ItemGroupID], N'''') AS [ItemGroupID], NULLIF([GroupItemTypeID], N'''') AS [GroupReferenceItemID], NULLIF([ItemTypeID], N'''') AS [ItemID], NULLIF([ItemTypeSortPos], N'''') AS [ItemSortPos], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[ItemGroupTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemGroupsTbl] ON;
        INSERT INTO [ItemGroupsTbl]
        (
            [ItemGroupID], [GroupReferenceItemID], [ItemID], [ItemSortPos], [Enabled], [Notes]
        )
        SELECT
            NULLIF([ItemGroupID], N'') AS [ItemGroupID], NULLIF([GroupItemTypeID], N'') AS [GroupReferenceItemID], NULLIF([ItemTypeID], N'') AS [ItemID], NULLIF([ItemTypeSortPos], N'') AS [ItemSortPos], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[ItemGroupTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemGroupsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemGroupsTbl'))
            DBCC CHECKIDENT (N'ItemGroupsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemGroupsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemGroupsTbl] from ' + N'[AccessSrc].[ItemGroupTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemGroupsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemGroupsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemGroupsTbl] from ' + N'[AccessSrc].[ItemGroupTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemGroupsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ItemGroupTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemGroupsTbl] ([ItemGroupID], [GroupReferenceItemID], [ItemID], [ItemSortPos], [Enabled], [Notes]) SELECT NULLIF([ItemGroupID], N'''') AS [ItemGroupID], NULLIF([GroupItemTypeID], N'''') AS [GroupReferenceItemID], NULLIF([ItemTypeID], N'''') AS [ItemID], NULLIF([ItemTypeSortPos], N'''') AS [ItemSortPos], CASE WHEN NULLIF([Enabled], N'''') IS NULL THEN NULL WHEN NULLIF([Enabled], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([Enabled], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'''')) END AS [Enabled], NULLIF([Notes], N'''') AS [Notes] FROM [ItemGroupTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemGroupsTbl] ON;
        INSERT INTO [ItemGroupsTbl]
        (
            [ItemGroupID], [GroupReferenceItemID], [ItemID], [ItemSortPos], [Enabled], [Notes]
        )
        SELECT
            NULLIF([ItemGroupID], N'') AS [ItemGroupID], NULLIF([GroupItemTypeID], N'') AS [GroupReferenceItemID], NULLIF([ItemTypeID], N'') AS [ItemID], NULLIF([ItemTypeSortPos], N'') AS [ItemSortPos], CASE WHEN NULLIF([Enabled], N'') IS NULL THEN NULL WHEN NULLIF([Enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Enabled], N'')) END AS [Enabled], NULLIF([Notes], N'') AS [Notes]
        FROM [ItemGroupTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemGroupsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemGroupsTbl'))
            DBCC CHECKIDENT (N'ItemGroupsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemGroupsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemGroupsTbl] from ' + N'[ItemGroupTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemGroupsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemGroupsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemGroupsTbl] from ' + N'[ItemGroupTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemGroupsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ServiceTypesTbl -> ItemServiceTypesTbl
-- Mapping: columnsCount=5
--   ServiceTypeId -> ItemServiceTypeID
--   ServiceType -> ItemServiceType
--   Description -> Description
--   PackagingID -> ItemPackagingID
--   PrepTypeID -> ItemPrepTypeID
IF OBJECT_ID(N'AccessSrc.ServiceTypesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemServiceTypesTbl] ([ItemServiceTypeID], [ItemServiceType], [Description], [ItemPackagingID], [ItemPrepTypeID]) SELECT NULLIF([ServiceTypeId], N'''') AS [ItemServiceTypeID], NULLIF([ServiceType], N'''') AS [ItemServiceType], NULLIF([Description], N'''') AS [Description], NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([PrepTypeID], N'''') AS [ItemPrepTypeID] FROM [AccessSrc].[ServiceTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemServiceTypesTbl] ON;
        INSERT INTO [ItemServiceTypesTbl]
        (
            [ItemServiceTypeID], [ItemServiceType], [Description], [ItemPackagingID], [ItemPrepTypeID]
        )
        SELECT
            NULLIF([ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF([ServiceType], N'') AS [ItemServiceType], NULLIF([Description], N'') AS [Description], NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([PrepTypeID], N'') AS [ItemPrepTypeID]
        FROM [AccessSrc].[ServiceTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemServiceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemServiceTypesTbl'))
            DBCC CHECKIDENT (N'ItemServiceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemServiceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemServiceTypesTbl] from ' + N'[AccessSrc].[ServiceTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemServiceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ItemServiceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemServiceTypesTbl] from ' + N'[AccessSrc].[ServiceTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemServiceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ServiceTypesTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemServiceTypesTbl] ([ItemServiceTypeID], [ItemServiceType], [Description], [ItemPackagingID], [ItemPrepTypeID]) SELECT NULLIF([ServiceTypeId], N'''') AS [ItemServiceTypeID], NULLIF([ServiceType], N'''') AS [ItemServiceType], NULLIF([Description], N'''') AS [Description], NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([PrepTypeID], N'''') AS [ItemPrepTypeID] FROM [ServiceTypesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemServiceTypesTbl] ON;
        INSERT INTO [ItemServiceTypesTbl]
        (
            [ItemServiceTypeID], [ItemServiceType], [Description], [ItemPackagingID], [ItemPrepTypeID]
        )
        SELECT
            NULLIF([ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF([ServiceType], N'') AS [ItemServiceType], NULLIF([Description], N'') AS [Description], NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([PrepTypeID], N'') AS [ItemPrepTypeID]
        FROM [ServiceTypesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemServiceTypesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemServiceTypesTbl'))
            DBCC CHECKIDENT (N'ItemServiceTypesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemServiceTypesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemServiceTypesTbl] from ' + N'[ServiceTypesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemServiceTypesTbl') IS NOT NULL SET IDENTITY_INSERT [ItemServiceTypesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemServiceTypesTbl] from ' + N'[ServiceTypesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemServiceTypesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- ItemTypeTbl -> ItemsTbl
-- Mapping: columnsCount=13
--   ItemTypeID -> ItemID
--   SKU -> SKU
--   ItemDesc -> ItemDesc
--   ItemEnabled -> ItemEnabled
--   ItemsCharacteritics -> ItemsCharacteritics
--   ItemDetail -> ItemDetail
--   ServiceTypeId -> ItemServiceTypeID
--   ReplacementID -> ReplacementItemID
--   ItemShortName -> ItemShortName
--   SortOrder -> SortOrder
--   UnitsPerQty -> UnitsPerQty
--   ItemUnitID -> ItemUnitID
--   BasePrice -> BasePrice
IF OBJECT_ID(N'AccessSrc.ItemTypeTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemsTbl] ([ItemID], [SKU], [ItemDesc], [ItemEnabled], [ItemsCharacteritics], [ItemDetail], [ItemServiceTypeID], [ReplacementItemID], [ItemShortName], [SortOrder], [UnitsPerQty], [ItemUnitID], [BasePrice]) SELECT NULLIF([ItemTypeID], N'''') AS [ItemID], NULLIF([SKU], N'''') AS [SKU], NULLIF([ItemDesc], N'''') AS [ItemDesc], NULLIF([ItemEnabled], N'''') AS [ItemEnabled], NULLIF([ItemsCharacteritics], N'''') AS [ItemsCharacteritics], NULLIF([ItemDetail], N'''') AS [ItemDetail], NULLIF([ServiceTypeId], N'''') AS [ItemServiceTypeID], NULLIF([ReplacementID], N'''') AS [ReplacementItemID], NULLIF([ItemShortName], N'''') AS [ItemShortName], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([UnitsPerQty], N'''') AS [UnitsPerQty], NULLIF([ItemUnitID], N'''') AS [ItemUnitID], NULLIF([BasePrice], N'''') AS [BasePrice] FROM [AccessSrc].[ItemTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemsTbl] ON;
        INSERT INTO [ItemsTbl]
        (
            [ItemID], [SKU], [ItemDesc], [ItemEnabled], [ItemsCharacteritics], [ItemDetail], [ItemServiceTypeID], [ReplacementItemID], [ItemShortName], [SortOrder], [UnitsPerQty], [ItemUnitID], [BasePrice]
        )
        SELECT
            NULLIF([ItemTypeID], N'') AS [ItemID], NULLIF([SKU], N'') AS [SKU], NULLIF([ItemDesc], N'') AS [ItemDesc], NULLIF([ItemEnabled], N'') AS [ItemEnabled], NULLIF([ItemsCharacteritics], N'') AS [ItemsCharacteritics], NULLIF([ItemDetail], N'') AS [ItemDetail], NULLIF([ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF([ReplacementID], N'') AS [ReplacementItemID], NULLIF([ItemShortName], N'') AS [ItemShortName], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([UnitsPerQty], N'') AS [UnitsPerQty], NULLIF([ItemUnitID], N'') AS [ItemUnitID], NULLIF([BasePrice], N'') AS [BasePrice]
        FROM [AccessSrc].[ItemTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemsTbl'))
            DBCC CHECKIDENT (N'ItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemsTbl] from ' + N'[AccessSrc].[ItemTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemsTbl] from ' + N'[AccessSrc].[ItemTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.ItemTypeTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [ItemsTbl] ([ItemID], [SKU], [ItemDesc], [ItemEnabled], [ItemsCharacteritics], [ItemDetail], [ItemServiceTypeID], [ReplacementItemID], [ItemShortName], [SortOrder], [UnitsPerQty], [ItemUnitID], [BasePrice]) SELECT NULLIF([ItemTypeID], N'''') AS [ItemID], NULLIF([SKU], N'''') AS [SKU], NULLIF([ItemDesc], N'''') AS [ItemDesc], NULLIF([ItemEnabled], N'''') AS [ItemEnabled], NULLIF([ItemsCharacteritics], N'''') AS [ItemsCharacteritics], NULLIF([ItemDetail], N'''') AS [ItemDetail], NULLIF([ServiceTypeId], N'''') AS [ItemServiceTypeID], NULLIF([ReplacementID], N'''') AS [ReplacementItemID], NULLIF([ItemShortName], N'''') AS [ItemShortName], NULLIF([SortOrder], N'''') AS [SortOrder], NULLIF([UnitsPerQty], N'''') AS [UnitsPerQty], NULLIF([ItemUnitID], N'''') AS [ItemUnitID], NULLIF([BasePrice], N'''') AS [BasePrice] FROM [ItemTypeTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [ItemsTbl] ON;
        INSERT INTO [ItemsTbl]
        (
            [ItemID], [SKU], [ItemDesc], [ItemEnabled], [ItemsCharacteritics], [ItemDetail], [ItemServiceTypeID], [ReplacementItemID], [ItemShortName], [SortOrder], [UnitsPerQty], [ItemUnitID], [BasePrice]
        )
        SELECT
            NULLIF([ItemTypeID], N'') AS [ItemID], NULLIF([SKU], N'') AS [SKU], NULLIF([ItemDesc], N'') AS [ItemDesc], NULLIF([ItemEnabled], N'') AS [ItemEnabled], NULLIF([ItemsCharacteritics], N'') AS [ItemsCharacteritics], NULLIF([ItemDetail], N'') AS [ItemDetail], NULLIF([ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF([ReplacementID], N'') AS [ReplacementItemID], NULLIF([ItemShortName], N'') AS [ItemShortName], NULLIF([SortOrder], N'') AS [SortOrder], NULLIF([UnitsPerQty], N'') AS [UnitsPerQty], NULLIF([ItemUnitID], N'') AS [ItemUnitID], NULLIF([BasePrice], N'') AS [BasePrice]
        FROM [ItemTypeTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [ItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'ItemsTbl'))
            DBCC CHECKIDENT (N'ItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [ItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [ItemsTbl] from ' + N'[ItemTypeTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'ItemsTbl') IS NOT NULL SET IDENTITY_INSERT [ItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [ItemsTbl] from ' + N'[ItemTypeTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [ItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- NextRoastDateByCityTbl -> NextPrepDateByAreasTbl
-- Mapping: columnsCount=7
--   NextRoastDayID -> NextPrepDayID
--   CityID -> AreaID
--   PreperationDate -> PreperationDate
--   DeliveryDate -> DeliveryDate
--   DeliveryOrder -> DeliveryOrder
--   NextPreperationDate -> NextPrepDate
--   NextDeliveryDate -> NextDeliveryDate
IF OBJECT_ID(N'AccessSrc.NextRoastDateByCityTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [NextPrepDateByAreasTbl] ([NextPrepDayID], [AreaID], [PreperationDate], [DeliveryDate], [DeliveryOrder], [NextPrepDate], [NextDeliveryDate]) SELECT NULLIF([NextRoastDayID], N'''') AS [NextPrepDayID], NULLIF([CityID], N'''') AS [AreaID], CAST(CASE WHEN NULLIF([PreperationDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PreperationDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PreperationDate], CAST(CASE WHEN NULLIF([DeliveryDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([DeliveryOrder], N'''') AS [DeliveryOrder], CAST(CASE WHEN NULLIF([NextPreperationDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NU ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [NextPrepDateByAreasTbl] ON;
        INSERT INTO [NextPrepDateByAreasTbl]
        (
            [NextPrepDayID], [AreaID], [PreperationDate], [DeliveryDate], [DeliveryOrder], [NextPrepDate], [NextDeliveryDate]
        )
        SELECT
            NULLIF([NextRoastDayID], N'') AS [NextPrepDayID], NULLIF([CityID], N'') AS [AreaID], CAST(CASE WHEN NULLIF([PreperationDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PreperationDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PreperationDate], CAST(CASE WHEN NULLIF([DeliveryDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([DeliveryOrder], N'') AS [DeliveryOrder], CAST(CASE WHEN NULLIF([NextPreperationDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextPreperationDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextPrepDate], CAST(CASE WHEN NULLIF([NextDeliveryDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextDeliveryDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextDeliveryDate]
        FROM [AccessSrc].[NextRoastDateByCityTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [NextPrepDateByAreasTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'NextPrepDateByAreasTbl'))
            DBCC CHECKIDENT (N'NextPrepDateByAreasTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [NextPrepDateByAreasTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [NextPrepDateByAreasTbl] from ' + N'[AccessSrc].[NextRoastDateByCityTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'NextPrepDateByAreasTbl') IS NOT NULL SET IDENTITY_INSERT [NextPrepDateByAreasTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [NextPrepDateByAreasTbl] from ' + N'[AccessSrc].[NextRoastDateByCityTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [NextPrepDateByAreasTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.NextRoastDateByCityTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [NextPrepDateByAreasTbl] ([NextPrepDayID], [AreaID], [PreperationDate], [DeliveryDate], [DeliveryOrder], [NextPrepDate], [NextDeliveryDate]) SELECT NULLIF([NextRoastDayID], N'''') AS [NextPrepDayID], NULLIF([CityID], N'''') AS [AreaID], CAST(CASE WHEN NULLIF([PreperationDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PreperationDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PreperationDate], CAST(CASE WHEN NULLIF([DeliveryDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([DeliveryOrder], N'''') AS [DeliveryOrder], CAST(CASE WHEN NULLIF([NextPreperationDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NU ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [NextPrepDateByAreasTbl] ON;
        INSERT INTO [NextPrepDateByAreasTbl]
        (
            [NextPrepDayID], [AreaID], [PreperationDate], [DeliveryDate], [DeliveryOrder], [NextPrepDate], [NextDeliveryDate]
        )
        SELECT
            NULLIF([NextRoastDayID], N'') AS [NextPrepDayID], NULLIF([CityID], N'') AS [AreaID], CAST(CASE WHEN NULLIF([PreperationDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([PreperationDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([PreperationDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [PreperationDate], CAST(CASE WHEN NULLIF([DeliveryDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DeliveryDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DeliveryDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DeliveryDate], NULLIF([DeliveryOrder], N'') AS [DeliveryOrder], CAST(CASE WHEN NULLIF([NextPreperationDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextPreperationDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextPreperationDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextPrepDate], CAST(CASE WHEN NULLIF([NextDeliveryDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([NextDeliveryDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([NextDeliveryDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [NextDeliveryDate]
        FROM [NextRoastDateByCityTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [NextPrepDateByAreasTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'NextPrepDateByAreasTbl'))
            DBCC CHECKIDENT (N'NextPrepDateByAreasTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [NextPrepDateByAreasTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [NextPrepDateByAreasTbl] from ' + N'[NextRoastDateByCityTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'NextPrepDateByAreasTbl') IS NOT NULL SET IDENTITY_INSERT [NextPrepDateByAreasTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [NextPrepDateByAreasTbl] from ' + N'[NextRoastDateByCityTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [NextPrepDateByAreasTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- RepairsTbl -> RepairsTbl
-- Mapping: columnsCount=22
--   RepairID -> RepairID
--   CustomerID -> ContactID
--   ContactName -> ContactName
--   ContactEmail -> ContactEmail
--   JobCardNumber -> JobCardNumber
--   DateLogged -> DateLogged
--   LastStatusChange -> LastStatusChange
--   MachineTypeID -> EquipTypeID
--   MachineSerialNumber -> EquipSerialNumber
--   SwopOutMachineID -> SwopOutMachineID
--   MachineConditionID -> EquipConditionID
--   TakenFrother -> TakenFrother
--   TakenBeanLid -> TakenBeanLid
--   TakenWaterLid -> TakenWaterLid
--   BrokenFrother -> BrokenFrother
--   BrokenBeanLid -> BrokenBeanLid
--   BrokenWaterLid -> BrokenWaterLid
--   RepairFaultID -> RepairFaultID
--   RepairFaultDesc -> RepairFaultDesc
--   RepairStatusID -> RepairStatusID
--   RelatedOrderID -> RelatedOrderID
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.RepairsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [RepairsTbl] ([RepairID], [ContactID], [ContactName], [ContactEmail], [JobCardNumber], [DateLogged], [LastStatusChange], [EquipTypeID], [EquipSerialNumber], [SwopOutMachineID], [EquipConditionID], [TakenFrother], [TakenBeanLid], [TakenWaterLid], [BrokenFrother], [BrokenBeanLid], [BrokenWaterLid], [RepairFaultID], [RepairFaultDesc], [RepairStatusID], [RelatedOrderID], [Notes]) SELECT NULLIF([RepairID], N'''') AS [RepairID], NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([ContactName], N'''') AS [ContactName], NULLIF([ContactEmail], N'''') AS [ContactEmail], NULLIF([JobCardNumber], N'''') AS [JobCardNumber], CAST(CASE WHEN NULLIF([DateLogged], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLogged], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLogged], CAST(CASE WHEN NULLIF([LastStatusChange], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastStatusChange], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''''), 121), TRY_CONVERT(date ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [RepairsTbl] ON;
        INSERT INTO [RepairsTbl]
        (
            [RepairID], [ContactID], [ContactName], [ContactEmail], [JobCardNumber], [DateLogged], [LastStatusChange], [EquipTypeID], [EquipSerialNumber], [SwopOutMachineID], [EquipConditionID], [TakenFrother], [TakenBeanLid], [TakenWaterLid], [BrokenFrother], [BrokenBeanLid], [BrokenWaterLid], [RepairFaultID], [RepairFaultDesc], [RepairStatusID], [RelatedOrderID], [Notes]
        )
        SELECT
            NULLIF([RepairID], N'') AS [RepairID], NULLIF([CustomerID], N'') AS [ContactID], NULLIF([ContactName], N'') AS [ContactName], NULLIF([ContactEmail], N'') AS [ContactEmail], NULLIF([JobCardNumber], N'') AS [JobCardNumber], CAST(CASE WHEN NULLIF([DateLogged], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLogged], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLogged], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLogged], CAST(CASE WHEN NULLIF([LastStatusChange], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastStatusChange], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastStatusChange], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastStatusChange], NULLIF([MachineTypeID], N'') AS [EquipTypeID], NULLIF([MachineSerialNumber], N'') AS [EquipSerialNumber], NULLIF([SwopOutMachineID], N'') AS [SwopOutMachineID], NULLIF([MachineConditionID], N'') AS [EquipConditionID], NULLIF([TakenFrother], N'') AS [TakenFrother], NULLIF([TakenBeanLid], N'') AS [TakenBeanLid], NULLIF([TakenWaterLid], N'') AS [TakenWaterLid], NULLIF([BrokenFrother], N'') AS [BrokenFrother], NULLIF([BrokenBeanLid], N'') AS [BrokenBeanLid], NULLIF([BrokenWaterLid], N'') AS [BrokenWaterLid], NULLIF([RepairFaultID], N'') AS [RepairFaultID], NULLIF([RepairFaultDesc], N'') AS [RepairFaultDesc], NULLIF([RepairStatusID], N'') AS [RepairStatusID], NULLIF([RelatedOrderID], N'') AS [RelatedOrderID], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[RepairsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [RepairsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'RepairsTbl'))
            DBCC CHECKIDENT (N'RepairsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [RepairsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [RepairsTbl] from ' + N'[AccessSrc].[RepairsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'RepairsTbl') IS NOT NULL SET IDENTITY_INSERT [RepairsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [RepairsTbl] from ' + N'[AccessSrc].[RepairsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [RepairsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [RepairsTbl]: missing source [AccessSrc].[RepairsTbl]';
END
GO

-- SysDataTbl -> SysDataTbl
-- Mapping: columnsCount=7
--   ID -> ID
--   LastReoccurringDate -> LastReoccurringDate
--   DoReoccuringOrders -> DoReoccuringOrders
--   DateLastPrepDateCalcd -> DateLastPrepDateCalcd
--   MinReminderDate -> MinReminderDate
--   GroupItemTypeID -> GroupReferenceItemID
--   InternalCustomerIds -> InternalContactIDs
IF OBJECT_ID(N'AccessSrc.SysDataTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [SysDataTbl] ([ID], [LastReoccurringDate], [DoReoccuringOrders], [DateLastPrepDateCalcd], [MinReminderDate], [GroupReferenceItemID], [InternalContactIDs]) SELECT NULLIF([ID], N'''') AS [ID], CAST(CASE WHEN NULLIF([LastReoccurringDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastReoccurringDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastReoccurringDate], NULLIF([DoReoccuringOrders], N'''') AS [DoReoccuringOrders], CAST(CASE WHEN NULLIF([DateLastPrepDateCalcd], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastPrepDateCalcd], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastPrepDateCalc ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [SysDataTbl] ON;
        INSERT INTO [SysDataTbl]
        (
            [ID], [LastReoccurringDate], [DoReoccuringOrders], [DateLastPrepDateCalcd], [MinReminderDate], [GroupReferenceItemID], [InternalContactIDs]
        )
        SELECT
            NULLIF([ID], N'') AS [ID], CAST(CASE WHEN NULLIF([LastReoccurringDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastReoccurringDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastReoccurringDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastReoccurringDate], NULLIF([DoReoccuringOrders], N'') AS [DoReoccuringOrders], CAST(CASE WHEN NULLIF([DateLastPrepDateCalcd], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([DateLastPrepDateCalcd], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([DateLastPrepDateCalcd], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [DateLastPrepDateCalcd], CAST(CASE WHEN NULLIF([MinReminderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([MinReminderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([MinReminderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [MinReminderDate], NULLIF([GroupItemTypeID], N'') AS [GroupReferenceItemID], NULLIF([InternalCustomerIds], N'') AS [InternalContactIDs]
        FROM [AccessSrc].[SysDataTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [SysDataTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'SysDataTbl'))
            DBCC CHECKIDENT (N'SysDataTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [SysDataTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [SysDataTbl] from ' + N'[AccessSrc].[SysDataTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'SysDataTbl') IS NOT NULL SET IDENTITY_INSERT [SysDataTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [SysDataTbl] from ' + N'[AccessSrc].[SysDataTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [SysDataTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [SysDataTbl]: missing source [AccessSrc].[SysDataTbl]';
END
GO

-- TempCoffeecheckupCustomerTbl -> TempCoffeecheckupCustomerTbl
-- Mapping: columnsCount=25
--   TCCID -> TCCID
--   CustomerID -> ContactID
--   CompanyName -> CompanyName
--   ContactFirstName -> ContactFirstName
--   ContactAltFirstName -> ContactAltFirstName
--   CityID -> AreaID
--   EmailAddress -> EmailAddress
--   AltEmailAddress -> AltEmailAddress
--   CustomerTypeID -> ContactTypeID
--   EquipTypeID -> EquipTypeID
--   TypicallySecToo -> TypicallySecToo
--   PreferedAgentID -> PreferedAgentID
--   SalesAgentID -> SalesAgentID
--   UsesFilter -> UsesFilter
--   enabled -> Enabled
--   AlwaysSendChkUp -> AlwaysSendChkUp
--   ReminderCount -> ReminderCount
--   NextPrepDate -> NextPrepDate
--   NextDeliveryDate -> NextDeliveryDate
--   NextCoffee -> NextCoffee
--   NextClean -> NextClean
--   NextFilter -> NextFilter
--   NextDescal -> NextDescal
--   NextService -> NextService
--   RequiresPurchOrder -> RequiresPurchOrder
IF OBJECT_ID(N'AccessSrc.TempCoffeecheckupCustomerTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TempCoffeecheckupCustomerTbl] ([TCCID], [ContactID], [CompanyName], [ContactFirstName], [ContactAltFirstName], [AreaID], [EmailAddress], [AltEmailAddress], [ContactTypeID], [EquipTypeID], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [UsesFilter], [Enabled], [AlwaysSendChkUp], [ReminderCount], [NextPrepDate], [NextDeliveryDate], [NextCoffee], [NextClean], [NextFilter], [NextDescal], [NextService], [RequiresPurchOrder]) SELECT NULLIF([TCCID], N'''') AS [TCCID], NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([CompanyName], N'''') AS [CompanyName], NULLIF([ContactFirstName], N'''') AS [ContactFirstName], NULLIF([ContactAltFirstName], N'''') AS [ContactAltFirstName], NULLIF([CityID], N'''') AS [AreaID], NULLIF([EmailAddress], N'''') AS [EmailAddress], NULLIF([AltEmailAddress], N'''') AS [AltEmailAddress], NULLIF([CustomerTypeID], N'''') AS [ContactTypeID], NULLIF([EquipTypeID], N'''') AS [EquipTypeID], CASE WHEN NULLIF([TypicallySecToo], N'''') IS NULL THEN NULL WHEN NULLIF([TypicallySecToo], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([TypicallySecToo], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([TypicallySecToo], N'''')) END AS [TypicallySecToo], NULLIF([PreferedAgentID], N'''') AS [PreferedAgentID], NULLIF([SalesAgentID], N'''') AS [SalesAgentID], CASE WHEN NULLIF([UsesFilter], N'''') IS NULL THEN NULL WHEN NULLIF([UsesFilter], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TempCoffeecheckupCustomerTbl] ON;
        INSERT INTO [TempCoffeecheckupCustomerTbl]
        (
            [TCCID], [ContactID], [CompanyName], [ContactFirstName], [ContactAltFirstName], [AreaID], [EmailAddress], [AltEmailAddress], [ContactTypeID], [EquipTypeID], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [UsesFilter], [Enabled], [AlwaysSendChkUp], [ReminderCount], [NextPrepDate], [NextDeliveryDate], [NextCoffee], [NextClean], [NextFilter], [NextDescal], [NextService], [RequiresPurchOrder]
        )
        SELECT
            NULLIF([TCCID], N'') AS [TCCID], NULLIF([CustomerID], N'') AS [ContactID], NULLIF([CompanyName], N'') AS [CompanyName], NULLIF([ContactFirstName], N'') AS [ContactFirstName], NULLIF([ContactAltFirstName], N'') AS [ContactAltFirstName], NULLIF([CityID], N'') AS [AreaID], NULLIF([EmailAddress], N'') AS [EmailAddress], NULLIF([AltEmailAddress], N'') AS [AltEmailAddress], NULLIF([CustomerTypeID], N'') AS [ContactTypeID], NULLIF([EquipTypeID], N'') AS [EquipTypeID], CASE WHEN NULLIF([TypicallySecToo], N'') IS NULL THEN NULL WHEN NULLIF([TypicallySecToo], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([TypicallySecToo], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([TypicallySecToo], N'')) END AS [TypicallySecToo], NULLIF([PreferedAgentID], N'') AS [PreferedAgentID], NULLIF([SalesAgentID], N'') AS [SalesAgentID], CASE WHEN NULLIF([UsesFilter], N'') IS NULL THEN NULL WHEN NULLIF([UsesFilter], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([UsesFilter], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([UsesFilter], N'')) END AS [UsesFilter], CASE WHEN NULLIF([enabled], N'') IS NULL THEN NULL WHEN NULLIF([enabled], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([enabled], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([enabled], N'')) END AS [Enabled], NULLIF([AlwaysSendChkUp], N'') AS [AlwaysSendChkUp], NULLIF([ReminderCount], N'') AS [ReminderCount], CAST([NextPrepDate] AS DATE) AS [NextPrepDate], CAST([NextDeliveryDate] AS DATE) AS [NextDeliveryDate], CAST([NextCoffee] AS DATE) AS [NextCoffee], CAST([NextClean] AS DATE) AS [NextClean], CAST([NextFilter] AS DATE) AS [NextFilter], [NextDescal] AS [NextDescal], CAST([NextService] AS DATE) AS [NextService], NULLIF([RequiresPurchOrder], N'') AS [RequiresPurchOrder]
        FROM [AccessSrc].[TempCoffeecheckupCustomerTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TempCoffeecheckupCustomerTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TempCoffeecheckupCustomerTbl'))
            DBCC CHECKIDENT (N'TempCoffeecheckupCustomerTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TempCoffeecheckupCustomerTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TempCoffeecheckupCustomerTbl] from ' + N'[AccessSrc].[TempCoffeecheckupCustomerTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TempCoffeecheckupCustomerTbl') IS NOT NULL SET IDENTITY_INSERT [TempCoffeecheckupCustomerTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TempCoffeecheckupCustomerTbl] from ' + N'[AccessSrc].[TempCoffeecheckupCustomerTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TempCoffeecheckupCustomerTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TempCoffeecheckupCustomerTbl]: missing source [AccessSrc].[TempCoffeecheckupCustomerTbl]';
END
GO

-- TempCoffeecheckupItemsTbl -> TempCoffeecheckupItemsTbl
-- Mapping: columnsCount=9
--   TCIID -> TCIID
--   CustomerID -> ContactID
--   ItemID -> ItemID
--   ItemQty -> ItemQty
--   ItemPrepID -> ItemPrepID
--   ItemPackagID -> ItemPackagingID
--   AutoFulfill -> AutoFulfill
--   NextDateRequired -> NextDateRequired
--   ReoccurOrderID -> RecurringOrderItemID
IF OBJECT_ID(N'AccessSrc.TempCoffeecheckupItemsTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TempCoffeecheckupItemsTbl] ([TCIID], [ContactID], [ItemID], [ItemQty], [ItemPrepID], [ItemPackagingID], [AutoFulfill], [NextDateRequired], [RecurringOrderItemID]) SELECT NULLIF([TCIID], N'''') AS [TCIID], NULLIF([CustomerID], N'''') AS [ContactID], NULLIF([ItemID], N'''') AS [ItemID], NULLIF([ItemQty], N'''') AS [ItemQty], NULLIF([ItemPrepID], N'''') AS [ItemPrepID], NULLIF([ItemPackagID], N'''') AS [ItemPackagingID], CASE WHEN NULLIF([AutoFulfill], N'''') IS NULL THEN NULL WHEN NULLIF([AutoFulfill], N'''') IN (N''1'', N''-1'', N''true'', N''TRUE'', N''yes'', N''YES'', N''Y'', N''y'') THEN 1 WHEN NULLIF([AutoFulfill], N'''') IN (N''0'', N''false'', N''FALSE'', N''no'', N''NO'', N''N'', N''n'') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([AutoFulfill], N'''')) END AS [AutoFulfill], CAST([NextDateRequired] AS DATE) AS [NextDateRequired], NULLIF([ReoccurOrderID], N'''') AS [RecurringOrderItemID] FROM [AccessSrc].[TempCoffeecheckupItemsTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TempCoffeecheckupItemsTbl] ON;
        INSERT INTO [TempCoffeecheckupItemsTbl]
        (
            [TCIID], [ContactID], [ItemID], [ItemQty], [ItemPrepID], [ItemPackagingID], [AutoFulfill], [NextDateRequired], [RecurringOrderItemID]
        )
        SELECT
            NULLIF([TCIID], N'') AS [TCIID], NULLIF([CustomerID], N'') AS [ContactID], NULLIF([ItemID], N'') AS [ItemID], NULLIF([ItemQty], N'') AS [ItemQty], NULLIF([ItemPrepID], N'') AS [ItemPrepID], NULLIF([ItemPackagID], N'') AS [ItemPackagingID], CASE WHEN NULLIF([AutoFulfill], N'') IS NULL THEN NULL WHEN NULLIF([AutoFulfill], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([AutoFulfill], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([AutoFulfill], N'')) END AS [AutoFulfill], CAST([NextDateRequired] AS DATE) AS [NextDateRequired], NULLIF([ReoccurOrderID], N'') AS [RecurringOrderItemID]
        FROM [AccessSrc].[TempCoffeecheckupItemsTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TempCoffeecheckupItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TempCoffeecheckupItemsTbl'))
            DBCC CHECKIDENT (N'TempCoffeecheckupItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TempCoffeecheckupItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TempCoffeecheckupItemsTbl] from ' + N'[AccessSrc].[TempCoffeecheckupItemsTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TempCoffeecheckupItemsTbl') IS NOT NULL SET IDENTITY_INSERT [TempCoffeecheckupItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TempCoffeecheckupItemsTbl] from ' + N'[AccessSrc].[TempCoffeecheckupItemsTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TempCoffeecheckupItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TempCoffeecheckupItemsTbl]: missing source [AccessSrc].[TempCoffeecheckupItemsTbl]';
END
GO

-- TempOrdersHeaderTbl -> TempOrdersHeaderTbl
-- Mapping: columnsCount=9
--   TOHeaderID -> TOHeaderID
--   CustomerID -> ContactID
--   OrderDate -> OrderDate
--   RoastDate -> RoastDate
--   RequiredByDate -> RequiredByDate
--   ToBeDeliveredByID -> ToBeDeliveredByID
--   Confirmed -> Confirmed
--   Done -> Done
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.TempOrdersHeaderTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TempOrdersHeaderTbl] ([TOHeaderID], [ContactID], [OrderDate], [RoastDate], [RequiredByDate], [ToBeDeliveredByID], [Confirmed], [Done], [Notes]) SELECT NULLIF([TOHeaderID], N'''') AS [TOHeaderID], NULLIF([CustomerID], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([OrderDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], CAST(CASE WHEN NULLIF([RequiredByDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RequiredByDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''''), 127), TRY_CONVE ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TempOrdersHeaderTbl] ON;
        INSERT INTO [TempOrdersHeaderTbl]
        (
            [TOHeaderID], [ContactID], [OrderDate], [RoastDate], [RequiredByDate], [ToBeDeliveredByID], [Confirmed], [Done], [Notes]
        )
        SELECT
            NULLIF([TOHeaderID], N'') AS [TOHeaderID], NULLIF([CustomerID], N'') AS [ContactID], CAST(CASE WHEN NULLIF([OrderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], CAST(CASE WHEN NULLIF([RequiredByDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RequiredByDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RequiredByDate], NULLIF([ToBeDeliveredByID], N'') AS [ToBeDeliveredByID], CASE WHEN NULLIF([Confirmed], N'') IS NULL THEN NULL WHEN NULLIF([Confirmed], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Confirmed], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Confirmed], N'')) END AS [Confirmed], CASE WHEN NULLIF([Done], N'') IS NULL THEN NULL WHEN NULLIF([Done], N'') IN (N'1', N'-1', N'true', N'TRUE', N'yes', N'YES', N'Y', N'y') THEN 1 WHEN NULLIF([Done], N'') IN (N'0', N'false', N'FALSE', N'no', N'NO', N'N', N'n') THEN 0 ELSE TRY_CONVERT(bit, NULLIF([Done], N'')) END AS [Done], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[TempOrdersHeaderTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TempOrdersHeaderTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TempOrdersHeaderTbl'))
            DBCC CHECKIDENT (N'TempOrdersHeaderTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TempOrdersHeaderTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TempOrdersHeaderTbl] from ' + N'[AccessSrc].[TempOrdersHeaderTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TempOrdersHeaderTbl') IS NOT NULL SET IDENTITY_INSERT [TempOrdersHeaderTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TempOrdersHeaderTbl] from ' + N'[AccessSrc].[TempOrdersHeaderTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TempOrdersHeaderTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TempOrdersHeaderTbl]: missing source [AccessSrc].[TempOrdersHeaderTbl]';
END
GO

-- TempOrdersLinesTbl -> TempOrdersLinesTbl
-- Mapping: columnsCount=7
--   TOLineID -> TOLineID
--   TOHeaderID -> TOHeaderID
--   ItemID -> ItemID
--   ServiceTypeID -> ItemServiceTypeID
--   Qty -> Qty
--   PackagingID -> ItemPackagingID
--   OriginalOrderID -> OriginalOrderID
IF OBJECT_ID(N'AccessSrc.TempOrdersLinesTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TempOrdersLinesTbl] ([TOLineID], [TOHeaderID], [ItemID], [ItemServiceTypeID], [Qty], [ItemPackagingID], [OriginalOrderID]) SELECT NULLIF([TOLineID], N'''') AS [TOLineID], NULLIF([TOHeaderID], N'''') AS [TOHeaderID], NULLIF([ItemID], N'''') AS [ItemID], NULLIF([ServiceTypeID], N'''') AS [ItemServiceTypeID], NULLIF([Qty], N'''') AS [Qty], NULLIF([PackagingID], N'''') AS [ItemPackagingID], NULLIF([OriginalOrderID], N'''') AS [OriginalOrderID] FROM [AccessSrc].[TempOrdersLinesTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TempOrdersLinesTbl] ON;
        INSERT INTO [TempOrdersLinesTbl]
        (
            [TOLineID], [TOHeaderID], [ItemID], [ItemServiceTypeID], [Qty], [ItemPackagingID], [OriginalOrderID]
        )
        SELECT
            NULLIF([TOLineID], N'') AS [TOLineID], NULLIF([TOHeaderID], N'') AS [TOHeaderID], NULLIF([ItemID], N'') AS [ItemID], NULLIF([ServiceTypeID], N'') AS [ItemServiceTypeID], NULLIF([Qty], N'') AS [Qty], NULLIF([PackagingID], N'') AS [ItemPackagingID], NULLIF([OriginalOrderID], N'') AS [OriginalOrderID]
        FROM [AccessSrc].[TempOrdersLinesTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TempOrdersLinesTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TempOrdersLinesTbl'))
            DBCC CHECKIDENT (N'TempOrdersLinesTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TempOrdersLinesTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TempOrdersLinesTbl] from ' + N'[AccessSrc].[TempOrdersLinesTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TempOrdersLinesTbl') IS NOT NULL SET IDENTITY_INSERT [TempOrdersLinesTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TempOrdersLinesTbl] from ' + N'[AccessSrc].[TempOrdersLinesTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TempOrdersLinesTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TempOrdersLinesTbl]: missing source [AccessSrc].[TempOrdersLinesTbl]';
END
GO

-- TempOrdersTbl -> TempOrdersTbl
-- Mapping: columnsCount=13
--   TempOrderId -> TempOrderID
--   OrderID -> OrderID
--   CustomerId -> ContactID
--   OrderDate -> OrderDate
--   RoastDate -> RoastDate
--   ItemTypeID -> ItemID
--   ServiceTypeId -> ItemServiceTypeID
--   PrepTypeID -> ItemPrepTypeID
--   PackagingId -> ItemPackagingID
--   QuantityOrdered -> QtyOrdered
--   RequiredByDate -> RequiredByDate
--   Delivered -> Delivered
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.TempOrdersTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TempOrdersTbl] ([TempOrderID], [OrderID], [ContactID], [OrderDate], [RoastDate], [ItemID], [ItemServiceTypeID], [ItemPrepTypeID], [ItemPackagingID], [QtyOrdered], [RequiredByDate], [Delivered], [Notes]) SELECT NULLIF([TempOrderId], N'''') AS [TempOrderID], NULLIF([OrderID], N'''') AS [OrderID], NULLIF([CustomerId], N'''') AS [ContactID], CAST(CASE WHEN NULLIF([OrderDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'''') AS [ItemID], NULLIF([ServiceTypeId], N'''') AS [ItemServiceTypeID], NULLIF([PrepTyp ... [truncated]';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TempOrdersTbl] ON;
        INSERT INTO [TempOrdersTbl]
        (
            [TempOrderID], [OrderID], [ContactID], [OrderDate], [RoastDate], [ItemID], [ItemServiceTypeID], [ItemPrepTypeID], [ItemPackagingID], [QtyOrdered], [RequiredByDate], [Delivered], [Notes]
        )
        SELECT
            NULLIF([TempOrderId], N'') AS [TempOrderID], NULLIF([OrderID], N'') AS [OrderID], NULLIF([CustomerId], N'') AS [ContactID], CAST(CASE WHEN NULLIF([OrderDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([OrderDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([OrderDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [OrderDate], CAST(CASE WHEN NULLIF([RoastDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RoastDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RoastDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RoastDate], NULLIF([ItemTypeID], N'') AS [ItemID], NULLIF([ServiceTypeId], N'') AS [ItemServiceTypeID], NULLIF([PrepTypeID], N'') AS [ItemPrepTypeID], NULLIF([PackagingId], N'') AS [ItemPackagingID], NULLIF([QuantityOrdered], N'') AS [QtyOrdered], CAST(CASE WHEN NULLIF([RequiredByDate], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([RequiredByDate], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([RequiredByDate], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [RequiredByDate], NULLIF([Delivered], N'') AS [Delivered], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[TempOrdersTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TempOrdersTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TempOrdersTbl'))
            DBCC CHECKIDENT (N'TempOrdersTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TempOrdersTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TempOrdersTbl] from ' + N'[AccessSrc].[TempOrdersTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TempOrdersTbl') IS NOT NULL SET IDENTITY_INSERT [TempOrdersTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TempOrdersTbl] from ' + N'[AccessSrc].[TempOrdersTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TempOrdersTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
ELSE
BEGIN
    PRINT 'SKIP migrate [TempOrdersTbl]: missing source [AccessSrc].[TempOrdersTbl]';
END
GO

-- TrackedServiceItemTbl -> TrackedServiceItemsTbl
-- Mapping: columnsCount=7
--   TrackerServiceItemID -> TrackerServiceItemID
--   ServiceTypeID -> ItemServiceTypeID
--   TypicalAvePerItem -> TypicalAvePerItem
--   UsageDateFieldName -> UsageDateFieldName
--   UsageAveFieldName -> UsageAveFieldName
--   ThisItemSetsDailyAverage -> ThisItemSetsDailyAverage
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.TrackedServiceItemTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TrackedServiceItemsTbl] ([TrackerServiceItemID], [ItemServiceTypeID], [TypicalAvePerItem], [UsageDateFieldName], [UsageAveFieldName], [ThisItemSetsDailyAverage], [Notes]) SELECT NULLIF([TrackerServiceItemID], N'''') AS [TrackerServiceItemID], NULLIF([ServiceTypeID], N'''') AS [ItemServiceTypeID], NULLIF([TypicalAvePerItem], N'''') AS [TypicalAvePerItem], CAST(CASE WHEN NULLIF([UsageDateFieldName], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([UsageDateFieldName], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDateFieldName], NULLIF([UsageAveFieldName], N'''') AS [UsageAveFieldName], NULLIF([ThisItemSetsDailyAverage], N'''') AS [ThisItemSetsDailyAverage], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[TrackedServiceItemTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TrackedServiceItemsTbl] ON;
        INSERT INTO [TrackedServiceItemsTbl]
        (
            [TrackerServiceItemID], [ItemServiceTypeID], [TypicalAvePerItem], [UsageDateFieldName], [UsageAveFieldName], [ThisItemSetsDailyAverage], [Notes]
        )
        SELECT
            NULLIF([TrackerServiceItemID], N'') AS [TrackerServiceItemID], NULLIF([ServiceTypeID], N'') AS [ItemServiceTypeID], NULLIF([TypicalAvePerItem], N'') AS [TypicalAvePerItem], CAST(CASE WHEN NULLIF([UsageDateFieldName], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([UsageDateFieldName], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDateFieldName], NULLIF([UsageAveFieldName], N'') AS [UsageAveFieldName], NULLIF([ThisItemSetsDailyAverage], N'') AS [ThisItemSetsDailyAverage], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[TrackedServiceItemTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TrackedServiceItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TrackedServiceItemsTbl'))
            DBCC CHECKIDENT (N'TrackedServiceItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TrackedServiceItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TrackedServiceItemsTbl] from ' + N'[AccessSrc].[TrackedServiceItemTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TrackedServiceItemsTbl') IS NOT NULL SET IDENTITY_INSERT [TrackedServiceItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TrackedServiceItemsTbl] from ' + N'[AccessSrc].[TrackedServiceItemTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TrackedServiceItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.TrackedServiceItemTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [TrackedServiceItemsTbl] ([TrackerServiceItemID], [ItemServiceTypeID], [TypicalAvePerItem], [UsageDateFieldName], [UsageAveFieldName], [ThisItemSetsDailyAverage], [Notes]) SELECT NULLIF([TrackerServiceItemID], N'''') AS [TrackerServiceItemID], NULLIF([ServiceTypeID], N'''') AS [ItemServiceTypeID], NULLIF([TypicalAvePerItem], N'''') AS [TypicalAvePerItem], CAST(CASE WHEN NULLIF([UsageDateFieldName], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([UsageDateFieldName], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDateFieldName], NULLIF([UsageAveFieldName], N'''') AS [UsageAveFieldName], NULLIF([ThisItemSetsDailyAverage], N'''') AS [ThisItemSetsDailyAverage], NULLIF([Notes], N'''') AS [Notes] FROM [TrackedServiceItemTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [TrackedServiceItemsTbl] ON;
        INSERT INTO [TrackedServiceItemsTbl]
        (
            [TrackerServiceItemID], [ItemServiceTypeID], [TypicalAvePerItem], [UsageDateFieldName], [UsageAveFieldName], [ThisItemSetsDailyAverage], [Notes]
        )
        SELECT
            NULLIF([TrackerServiceItemID], N'') AS [TrackerServiceItemID], NULLIF([ServiceTypeID], N'') AS [ItemServiceTypeID], NULLIF([TypicalAvePerItem], N'') AS [TypicalAvePerItem], CAST(CASE WHEN NULLIF([UsageDateFieldName], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([UsageDateFieldName], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([UsageDateFieldName], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [UsageDateFieldName], NULLIF([UsageAveFieldName], N'') AS [UsageAveFieldName], NULLIF([ThisItemSetsDailyAverage], N'') AS [ThisItemSetsDailyAverage], NULLIF([Notes], N'') AS [Notes]
        FROM [TrackedServiceItemTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [TrackedServiceItemsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'TrackedServiceItemsTbl'))
            DBCC CHECKIDENT (N'TrackedServiceItemsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [TrackedServiceItemsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [TrackedServiceItemsTbl] from ' + N'[TrackedServiceItemTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'TrackedServiceItemsTbl') IS NOT NULL SET IDENTITY_INSERT [TrackedServiceItemsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [TrackedServiceItemsTbl] from ' + N'[TrackedServiceItemTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [TrackedServiceItemsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

-- UsedItemGroupTbl -> UsedItemGroupsTbl
-- Mapping: columnsCount=7
--   UsedItemGroupID -> UsedItemGroupID
--   ContactID -> ContactID
--   GroupItemTypeID -> GroupReferenceItemID
--   LastItemTypeID -> LastItemID
--   LastItemTypeSortPos -> LastItemSortPos
--   LastItemDateChanged -> LastItemDateChanged
--   Notes -> Notes
IF OBJECT_ID(N'AccessSrc.UsedItemGroupTbl') IS NOT NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [UsedItemGroupsTbl] ([UsedItemGroupID], [ContactID], [GroupReferenceItemID], [LastItemID], [LastItemSortPos], [LastItemDateChanged], [Notes]) SELECT NULLIF([UsedItemGroupID], N'''') AS [UsedItemGroupID], NULLIF([ContactID], N'''') AS [ContactID], NULLIF([GroupItemTypeID], N'''') AS [GroupReferenceItemID], NULLIF([LastItemTypeID], N'''') AS [LastItemID], NULLIF([LastItemTypeSortPos], N'''') AS [LastItemSortPos], CAST(CASE WHEN NULLIF([LastItemDateChanged], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastItemDateChanged], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastItemDateChanged], NULLIF([Notes], N'''') AS [Notes] FROM [AccessSrc].[UsedItemGroupTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [UsedItemGroupsTbl] ON;
        INSERT INTO [UsedItemGroupsTbl]
        (
            [UsedItemGroupID], [ContactID], [GroupReferenceItemID], [LastItemID], [LastItemSortPos], [LastItemDateChanged], [Notes]
        )
        SELECT
            NULLIF([UsedItemGroupID], N'') AS [UsedItemGroupID], NULLIF([ContactID], N'') AS [ContactID], NULLIF([GroupItemTypeID], N'') AS [GroupReferenceItemID], NULLIF([LastItemTypeID], N'') AS [LastItemID], NULLIF([LastItemTypeSortPos], N'') AS [LastItemSortPos], CAST(CASE WHEN NULLIF([LastItemDateChanged], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastItemDateChanged], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastItemDateChanged], NULLIF([Notes], N'') AS [Notes]
        FROM [AccessSrc].[UsedItemGroupTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [UsedItemGroupsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'UsedItemGroupsTbl'))
            DBCC CHECKIDENT (N'UsedItemGroupsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [UsedItemGroupsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [UsedItemGroupsTbl] from ' + N'[AccessSrc].[UsedItemGroupTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'UsedItemGroupsTbl') IS NOT NULL SET IDENTITY_INSERT [UsedItemGroupsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [UsedItemGroupsTbl] from ' + N'[AccessSrc].[UsedItemGroupTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [UsedItemGroupsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

IF OBJECT_ID(N'AccessSrc.UsedItemGroupTbl') IS NULL
BEGIN
    PRINT N'About to execute (IdentityInsert=ON):';
    PRINT N'INSERT INTO [UsedItemGroupsTbl] ([UsedItemGroupID], [ContactID], [GroupReferenceItemID], [LastItemID], [LastItemSortPos], [LastItemDateChanged], [Notes]) SELECT NULLIF([UsedItemGroupID], N'''') AS [UsedItemGroupID], NULLIF([ContactID], N'''') AS [ContactID], NULLIF([GroupItemTypeID], N'''') AS [GroupReferenceItemID], NULLIF([LastItemTypeID], N'''') AS [LastItemID], NULLIF([LastItemTypeSortPos], N'''') AS [LastItemSortPos], CAST(CASE WHEN NULLIF([LastItemDateChanged], N'''') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastItemDateChanged], N'''')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N'''')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastItemDateChanged], NULLIF([Notes], N'''') AS [Notes] FROM [UsedItemGroupTbl];';
    BEGIN TRY
        BEGIN TRAN;
        SET IDENTITY_INSERT [UsedItemGroupsTbl] ON;
        INSERT INTO [UsedItemGroupsTbl]
        (
            [UsedItemGroupID], [ContactID], [GroupReferenceItemID], [LastItemID], [LastItemSortPos], [LastItemDateChanged], [Notes]
        )
        SELECT
            NULLIF([UsedItemGroupID], N'') AS [UsedItemGroupID], NULLIF([ContactID], N'') AS [ContactID], NULLIF([GroupItemTypeID], N'') AS [GroupReferenceItemID], NULLIF([LastItemTypeID], N'') AS [LastItemID], NULLIF([LastItemTypeSortPos], N'') AS [LastItemSortPos], CAST(CASE WHEN NULLIF([LastItemDateChanged], N'') IS NULL OR LEN(LTRIM(RTRIM(NULLIF([LastItemDateChanged], N'')))) = 0 THEN NULL ELSE COALESCE(TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 127), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 126), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 121), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 103), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N''), 101), TRY_CONVERT(datetime2(7), NULLIF([LastItemDateChanged], N'')), CAST(NULL AS datetime2(7))) END AS DATE) AS [LastItemDateChanged], NULLIF([Notes], N'') AS [Notes]
        FROM [UsedItemGroupTbl];
        DECLARE @rowsInserted int = @@ROWCOUNT;
        SET IDENTITY_INSERT [UsedItemGroupsTbl] OFF;
        IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID(N'UsedItemGroupsTbl'))
            DBCC CHECKIDENT (N'UsedItemGroupsTbl', RESEED);
        COMMIT;
        PRINT N'ROWS_INSERTED [UsedItemGroupsTbl] -> ' + CAST(@rowsInserted AS nvarchar(20));
        PRINT 'OK migrate [UsedItemGroupsTbl] from ' + N'[UsedItemGroupTbl]';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        BEGIN TRY
            IF OBJECT_ID(N'UsedItemGroupsTbl') IS NOT NULL SET IDENTITY_INSERT [UsedItemGroupsTbl] OFF;
        END TRY BEGIN CATCH END CATCH
        PRINT 'ERROR migrate [UsedItemGroupsTbl] from ' + N'[UsedItemGroupTbl]' + ': ' + ERROR_MESSAGE();
        PRINT 'WARN: [UsedItemGroupsTbl] migration failed - this table will be empty';
        -- Continue with next table despite error
    END CATCH
END
GO

PRINT 'Identities present:';
SELECT t.name AS TableName, c.name AS IdentityColumn
FROM sys.identity_columns ic
JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
JOIN sys.tables t ON t.object_id=c.object_id;
GO

SELECT COUNT(*) AS ForeignKeysPresent FROM sys.foreign_keys;
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

