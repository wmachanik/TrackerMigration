-- Emitted FKs: 67, Skipped: 10
-- Auto-generated FK constraints script
-- FKs (total=77)
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_AreaPrepDaysTbl_AreaID' AND parent_object_id = OBJECT_ID(N'[AreaPrepDaysTbl]'))
BEGIN
    ALTER TABLE [AreaPrepDaysTbl] WITH NOCHECK ADD CONSTRAINT [FK_AreaPrepDaysTbl_AreaID] FOREIGN KEY([AreaID]) REFERENCES [AreasTbl]([AreaID]);
END
GO

BEGIN TRY
    ALTER TABLE [AreaPrepDaysTbl] WITH CHECK CHECK CONSTRAINT [FK_AreaPrepDaysTbl_AreaID];
    PRINT N'OK: Checked constraint FK_AreaPrepDaysTbl_AreaID on [AreaPrepDaysTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_AreaPrepDaysTbl_AreaID] on [AreaPrepDaysTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsAwayPeriodTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[ContactsAwayPeriodTbl]'))
BEGIN
    ALTER TABLE [ContactsAwayPeriodTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsAwayPeriodTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsAwayPeriodTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsAwayPeriodTbl_ContactID];
    PRINT N'OK: Checked constraint FK_ContactsAwayPeriodTbl_ContactID on [ContactsAwayPeriodTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsAwayPeriodTbl_ContactID] on [ContactsAwayPeriodTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemSvcSummaryTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[ContactsItemSvcSummaryTbl]'))
BEGIN
    ALTER TABLE [ContactsItemSvcSummaryTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemSvcSummaryTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemSvcSummaryTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemSvcSummaryTbl_ContactID];
    PRINT N'OK: Checked constraint FK_ContactsItemSvcSummaryTbl_ContactID on [ContactsItemSvcSummaryTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemSvcSummaryTbl_ContactID] on [ContactsItemSvcSummaryTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemSvcSummaryTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsItemSvcSummaryTbl]'))
BEGIN
    ALTER TABLE [ContactsItemSvcSummaryTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemSvcSummaryTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemSvcSummaryTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemSvcSummaryTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_ContactsItemSvcSummaryTbl_ItemServiceTypeID on [ContactsItemSvcSummaryTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemSvcSummaryTbl_ItemServiceTypeID] on [ContactsItemSvcSummaryTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemsPredictedTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[ContactsItemsPredictedTbl]'))
BEGIN
    ALTER TABLE [ContactsItemsPredictedTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemsPredictedTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemsPredictedTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemsPredictedTbl_ContactID];
    PRINT N'OK: Checked constraint FK_ContactsItemsPredictedTbl_ContactID on [ContactsItemsPredictedTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemsPredictedTbl_ContactID] on [ContactsItemsPredictedTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsAccInfoTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[ContactsAccInfoTbl]'))
BEGIN
    ALTER TABLE [ContactsAccInfoTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsAccInfoTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsAccInfoTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsAccInfoTbl_ContactID];
    PRINT N'OK: Checked constraint FK_ContactsAccInfoTbl_ContactID on [ContactsAccInfoTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsAccInfoTbl_ContactID] on [ContactsAccInfoTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsAccInfoTbl_PaymentTermID' AND parent_object_id = OBJECT_ID(N'[ContactsAccInfoTbl]'))
BEGIN
    ALTER TABLE [ContactsAccInfoTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsAccInfoTbl_PaymentTermID] FOREIGN KEY([PaymentTermID]) REFERENCES [PaymentTermsTbl]([PaymentTermID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsAccInfoTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsAccInfoTbl_PaymentTermID];
    PRINT N'OK: Checked constraint FK_ContactsAccInfoTbl_PaymentTermID on [ContactsAccInfoTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsAccInfoTbl_PaymentTermID] on [ContactsAccInfoTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsAccInfoTbl_PriceLevelID' AND parent_object_id = OBJECT_ID(N'[ContactsAccInfoTbl]'))
BEGIN
    ALTER TABLE [ContactsAccInfoTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsAccInfoTbl_PriceLevelID] FOREIGN KEY([PriceLevelID]) REFERENCES [PriceLevelsTbl]([PriceLevelID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsAccInfoTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsAccInfoTbl_PriceLevelID];
    PRINT N'OK: Checked constraint FK_ContactsAccInfoTbl_PriceLevelID on [ContactsAccInfoTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsAccInfoTbl_PriceLevelID] on [ContactsAccInfoTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsAccInfoTbl_InvoiceTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsAccInfoTbl]'))
BEGIN
    ALTER TABLE [ContactsAccInfoTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsAccInfoTbl_InvoiceTypeID] FOREIGN KEY([InvoiceTypeID]) REFERENCES [InvoiceTypesTbl]([InvoiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsAccInfoTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsAccInfoTbl_InvoiceTypeID];
    PRINT N'OK: Checked constraint FK_ContactsAccInfoTbl_InvoiceTypeID on [ContactsAccInfoTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsAccInfoTbl_InvoiceTypeID] on [ContactsAccInfoTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_ContactTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_ContactTypeID] FOREIGN KEY([ContactTypeID]) REFERENCES [ContactTypesTbl]([ContactTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_ContactTypeID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_ContactTypeID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_ContactTypeID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_EquipTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_EquipTypeID] FOREIGN KEY([EquipTypeID]) REFERENCES [EquipTypesTbl]([EquipTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_EquipTypeID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_EquipTypeID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_EquipTypeID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_ItemPrefID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_ItemPrefID] FOREIGN KEY([ItemPrefID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_ItemPrefID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_ItemPrefID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_ItemPrefID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_PrefItemPrepTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_PrefItemPrepTypeID] FOREIGN KEY([PrefItemPrepTypeID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_PrefItemPrepTypeID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_PrefItemPrepTypeID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_PrefItemPrepTypeID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [ContactsTbl].[PrefItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_SecondaryItemPrefID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_SecondaryItemPrefID] FOREIGN KEY([SecondaryItemPrefID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_SecondaryItemPrefID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_SecondaryItemPrefID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_SecondaryItemPrefID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_PreferedAgentID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_PreferedAgentID] FOREIGN KEY([PreferredAgentID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_PreferedAgentID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_PreferedAgentID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_PreferedAgentID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsTbl_SalesAgentID' AND parent_object_id = OBJECT_ID(N'[ContactsTbl]'))
BEGIN
    ALTER TABLE [ContactsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsTbl_SalesAgentID] FOREIGN KEY([SalesAgentID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsTbl_SalesAgentID];
    PRINT N'OK: Checked constraint FK_ContactsTbl_SalesAgentID on [ContactsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsTbl_SalesAgentID] on [ContactsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactTrackedServiceItemsTbl_ContactTypeID' AND parent_object_id = OBJECT_ID(N'[ContactTrackedServiceItemsTbl]'))
BEGIN
    ALTER TABLE [ContactTrackedServiceItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactTrackedServiceItemsTbl_ContactTypeID] FOREIGN KEY([ContactTypeID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactTrackedServiceItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactTrackedServiceItemsTbl_ContactTypeID];
    PRINT N'OK: Checked constraint FK_ContactTrackedServiceItemsTbl_ContactTypeID on [ContactTrackedServiceItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactTrackedServiceItemsTbl_ContactTypeID] on [ContactTrackedServiceItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactTrackedServiceItemsTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[ContactTrackedServiceItemsTbl]'))
BEGIN
    ALTER TABLE [ContactTrackedServiceItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactTrackedServiceItemsTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactTrackedServiceItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactTrackedServiceItemsTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_ContactTrackedServiceItemsTbl_ItemServiceTypeID on [ContactTrackedServiceItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactTrackedServiceItemsTbl_ItemServiceTypeID] on [ContactTrackedServiceItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemGroupsTbl_GroupReferenceItemID' AND parent_object_id = OBJECT_ID(N'[ItemGroupsTbl]'))
BEGIN
    ALTER TABLE [ItemGroupsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemGroupsTbl_GroupReferenceItemID] FOREIGN KEY([GroupReferenceItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemGroupsTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemGroupsTbl_GroupReferenceItemID];
    PRINT N'OK: Checked constraint FK_ItemGroupsTbl_GroupReferenceItemID on [ItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemGroupsTbl_GroupReferenceItemID] on [ItemGroupsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemGroupsTbl_ItemID' AND parent_object_id = OBJECT_ID(N'[ItemGroupsTbl]'))
BEGIN
    ALTER TABLE [ItemGroupsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemGroupsTbl_ItemID] FOREIGN KEY([ItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemGroupsTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemGroupsTbl_ItemID];
    PRINT N'OK: Checked constraint FK_ItemGroupsTbl_ItemID on [ItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemGroupsTbl_ItemID] on [ItemGroupsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemsTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[ItemsTbl]'))
BEGIN
    ALTER TABLE [ItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemsTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemsTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_ItemsTbl_ItemServiceTypeID on [ItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemsTbl_ItemServiceTypeID] on [ItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemsTbl_ReplacementItemID' AND parent_object_id = OBJECT_ID(N'[ItemsTbl]'))
BEGIN
    ALTER TABLE [ItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemsTbl_ReplacementItemID] FOREIGN KEY([ReplacementItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemsTbl_ReplacementItemID];
    PRINT N'OK: Checked constraint FK_ItemsTbl_ReplacementItemID on [ItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemsTbl_ReplacementItemID] on [ItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemsTbl_ItemUnitID' AND parent_object_id = OBJECT_ID(N'[ItemsTbl]'))
BEGIN
    ALTER TABLE [ItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemsTbl_ItemUnitID] FOREIGN KEY([ItemUnitID]) REFERENCES [ItemUnitsTbl]([ItemUnitID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemsTbl_ItemUnitID];
    PRINT N'OK: Checked constraint FK_ItemsTbl_ItemUnitID on [ItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemsTbl_ItemUnitID] on [ItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemUsageTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[ContactsItemUsageTbl]'))
BEGIN
    ALTER TABLE [ContactsItemUsageTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemUsageTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemUsageTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemUsageTbl_ContactID];
    PRINT N'OK: Checked constraint FK_ContactsItemUsageTbl_ContactID on [ContactsItemUsageTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemUsageTbl_ContactID] on [ContactsItemUsageTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemUsageTbl_ItemProvidedID' AND parent_object_id = OBJECT_ID(N'[ContactsItemUsageTbl]'))
BEGIN
    ALTER TABLE [ContactsItemUsageTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemUsageTbl_ItemProvidedID] FOREIGN KEY([ItemProvidedID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemUsageTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemUsageTbl_ItemProvidedID];
    PRINT N'OK: Checked constraint FK_ContactsItemUsageTbl_ItemProvidedID on [ContactsItemUsageTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemUsageTbl_ItemProvidedID] on [ContactsItemUsageTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContactsItemUsageTbl_ItemPrepTypeID' AND parent_object_id = OBJECT_ID(N'[ContactsItemUsageTbl]'))
BEGIN
    ALTER TABLE [ContactsItemUsageTbl] WITH NOCHECK ADD CONSTRAINT [FK_ContactsItemUsageTbl_ItemPrepTypeID] FOREIGN KEY([ItemPrepTypeID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [ContactsItemUsageTbl] WITH CHECK CHECK CONSTRAINT [FK_ContactsItemUsageTbl_ItemPrepTypeID];
    PRINT N'OK: Checked constraint FK_ContactsItemUsageTbl_ItemPrepTypeID on [ContactsItemUsageTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ContactsItemUsageTbl_ItemPrepTypeID] on [ContactsItemUsageTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [ContactsItemUsageTbl].[ItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_NextPrepDateByAreasTbl_AreaID' AND parent_object_id = OBJECT_ID(N'[NextPrepDateByAreasTbl]'))
BEGIN
    ALTER TABLE [NextPrepDateByAreasTbl] WITH NOCHECK ADD CONSTRAINT [FK_NextPrepDateByAreasTbl_AreaID] FOREIGN KEY([AreaID]) REFERENCES [AreasTbl]([AreaID]);
END
GO

BEGIN TRY
    ALTER TABLE [NextPrepDateByAreasTbl] WITH CHECK CHECK CONSTRAINT [FK_NextPrepDateByAreasTbl_AreaID];
    PRINT N'OK: Checked constraint FK_NextPrepDateByAreasTbl_AreaID on [NextPrepDateByAreasTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_NextPrepDateByAreasTbl_AreaID] on [NextPrepDateByAreasTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_ContactID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_ContactID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_ContactID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_EquipTypeID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_EquipTypeID] FOREIGN KEY([EquipTypeID]) REFERENCES [EquipTypesTbl]([EquipTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_EquipTypeID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_EquipTypeID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_EquipTypeID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_EquipConditionID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_EquipConditionID] FOREIGN KEY([EquipConditionID]) REFERENCES [EquipConditionsTbl]([EquipConditionID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_EquipConditionID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_EquipConditionID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_EquipConditionID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_RepairFaultID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_RepairFaultID] FOREIGN KEY([RepairFaultID]) REFERENCES [RepairFaultsTbl]([RepairFaultID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_RepairFaultID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_RepairFaultID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_RepairFaultID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_RepairStatusID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_RepairStatusID] FOREIGN KEY([RepairStatusID]) REFERENCES [RepairStatusesTbl]([RepairStatusID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_RepairStatusID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_RepairStatusID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_RepairStatusID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RepairsTbl_RelatedOrderID' AND parent_object_id = OBJECT_ID(N'[RepairsTbl]'))
BEGIN
    ALTER TABLE [RepairsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RepairsTbl_RelatedOrderID] FOREIGN KEY([RelatedOrderID]) REFERENCES [OrdersTbl]([OrderID]);
END
GO

BEGIN TRY
    ALTER TABLE [RepairsTbl] WITH CHECK CHECK CONSTRAINT [FK_RepairsTbl_RelatedOrderID];
    PRINT N'OK: Checked constraint FK_RepairsTbl_RelatedOrderID on [RepairsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RepairsTbl_RelatedOrderID] on [RepairsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_SentRemindersLogTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[SentRemindersLogTbl]'))
BEGIN
    ALTER TABLE [SentRemindersLogTbl] WITH NOCHECK ADD CONSTRAINT [FK_SentRemindersLogTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [SentRemindersLogTbl] WITH CHECK CHECK CONSTRAINT [FK_SentRemindersLogTbl_ContactID];
    PRINT N'OK: Checked constraint FK_SentRemindersLogTbl_ContactID on [SentRemindersLogTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_SentRemindersLogTbl_ContactID] on [SentRemindersLogTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [ItemServiceTypesTbl].[ItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ItemServiceTypesTbl_ItemPrepTypeID' AND parent_object_id = OBJECT_ID(N'[ItemServiceTypesTbl]'))
BEGIN
    ALTER TABLE [ItemServiceTypesTbl] WITH NOCHECK ADD CONSTRAINT [FK_ItemServiceTypesTbl_ItemPrepTypeID] FOREIGN KEY([ItemPrepTypeID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [ItemServiceTypesTbl] WITH CHECK CHECK CONSTRAINT [FK_ItemServiceTypesTbl_ItemPrepTypeID];
    PRINT N'OK: Checked constraint FK_ItemServiceTypesTbl_ItemPrepTypeID on [ItemServiceTypesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_ItemServiceTypesTbl_ItemPrepTypeID] on [ItemServiceTypesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_SysDataTbl_GroupReferenceItemID' AND parent_object_id = OBJECT_ID(N'[SysDataTbl]'))
BEGIN
    ALTER TABLE [SysDataTbl] WITH NOCHECK ADD CONSTRAINT [FK_SysDataTbl_GroupReferenceItemID] FOREIGN KEY([GroupReferenceItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [SysDataTbl] WITH CHECK CHECK CONSTRAINT [FK_SysDataTbl_GroupReferenceItemID];
    PRINT N'OK: Checked constraint FK_SysDataTbl_GroupReferenceItemID on [SysDataTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_SysDataTbl_GroupReferenceItemID] on [SysDataTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_ContactID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_ContactID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_ContactID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_AreaID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_AreaID] FOREIGN KEY([AreaID]) REFERENCES [AreasTbl]([AreaID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_AreaID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_AreaID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_AreaID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_ContactTypeID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_ContactTypeID] FOREIGN KEY([ContactTypeID]) REFERENCES [ContactTypesTbl]([ContactTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_ContactTypeID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_ContactTypeID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_ContactTypeID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_EquipTypeID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_EquipTypeID] FOREIGN KEY([EquipTypeID]) REFERENCES [EquipTypesTbl]([EquipTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_EquipTypeID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_EquipTypeID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_EquipTypeID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_PreferedAgentID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_PreferedAgentID] FOREIGN KEY([PreferredAgentID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_PreferedAgentID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_PreferedAgentID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_PreferedAgentID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupCustomerTbl_SalesAgentID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupCustomerTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_SalesAgentID] FOREIGN KEY([SalesAgentID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupCustomerTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupCustomerTbl_SalesAgentID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupCustomerTbl_SalesAgentID on [TempCoffeecheckupCustomerTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupCustomerTbl_SalesAgentID] on [TempCoffeecheckupCustomerTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupItemsTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupItemsTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ContactID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupItemsTbl_ContactID on [TempCoffeecheckupItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupItemsTbl_ContactID] on [TempCoffeecheckupItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupItemsTbl_ItemID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupItemsTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ItemID] FOREIGN KEY([ItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ItemID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupItemsTbl_ItemID on [TempCoffeecheckupItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupItemsTbl_ItemID] on [TempCoffeecheckupItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupItemsTbl_ItemPrepID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupItemsTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ItemPrepID] FOREIGN KEY([ItemPrepID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupItemsTbl_ItemPrepID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupItemsTbl_ItemPrepID on [TempCoffeecheckupItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupItemsTbl_ItemPrepID] on [TempCoffeecheckupItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [TempCoffeecheckupItemsTbl].[ItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempCoffeecheckupItemsTbl_RecurringOrderItemID' AND parent_object_id = OBJECT_ID(N'[TempCoffeecheckupItemsTbl]'))
BEGIN
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempCoffeecheckupItemsTbl_RecurringOrderItemID] FOREIGN KEY([RecurringOrderItemID]) REFERENCES [RecurringOrderItemsTbl]([RecurringOrderItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempCoffeecheckupItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_TempCoffeecheckupItemsTbl_RecurringOrderItemID];
    PRINT N'OK: Checked constraint FK_TempCoffeecheckupItemsTbl_RecurringOrderItemID on [TempCoffeecheckupItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempCoffeecheckupItemsTbl_RecurringOrderItemID] on [TempCoffeecheckupItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersHeaderTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[TempOrdersHeaderTbl]'))
BEGIN
    ALTER TABLE [TempOrdersHeaderTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersHeaderTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersHeaderTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersHeaderTbl_ContactID];
    PRINT N'OK: Checked constraint FK_TempOrdersHeaderTbl_ContactID on [TempOrdersHeaderTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersHeaderTbl_ContactID] on [TempOrdersHeaderTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersHeaderTbl_ToBeDeliveredByID' AND parent_object_id = OBJECT_ID(N'[TempOrdersHeaderTbl]'))
BEGIN
    ALTER TABLE [TempOrdersHeaderTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersHeaderTbl_ToBeDeliveredByID] FOREIGN KEY([ToBeDeliveredByID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersHeaderTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersHeaderTbl_ToBeDeliveredByID];
    PRINT N'OK: Checked constraint FK_TempOrdersHeaderTbl_ToBeDeliveredByID on [TempOrdersHeaderTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersHeaderTbl_ToBeDeliveredByID] on [TempOrdersHeaderTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersLinesTbl_TOHeaderID' AND parent_object_id = OBJECT_ID(N'[TempOrdersLinesTbl]'))
BEGIN
    ALTER TABLE [TempOrdersLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersLinesTbl_TOHeaderID] FOREIGN KEY([TOHeaderID]) REFERENCES [TempOrdersHeaderTbl]([TOHeaderID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersLinesTbl_TOHeaderID];
    PRINT N'OK: Checked constraint FK_TempOrdersLinesTbl_TOHeaderID on [TempOrdersLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersLinesTbl_TOHeaderID] on [TempOrdersLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersLinesTbl_ItemID' AND parent_object_id = OBJECT_ID(N'[TempOrdersLinesTbl]'))
BEGIN
    ALTER TABLE [TempOrdersLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersLinesTbl_ItemID] FOREIGN KEY([ItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersLinesTbl_ItemID];
    PRINT N'OK: Checked constraint FK_TempOrdersLinesTbl_ItemID on [TempOrdersLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersLinesTbl_ItemID] on [TempOrdersLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersLinesTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[TempOrdersLinesTbl]'))
BEGIN
    ALTER TABLE [TempOrdersLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersLinesTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersLinesTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_TempOrdersLinesTbl_ItemServiceTypeID on [TempOrdersLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersLinesTbl_ItemServiceTypeID] on [TempOrdersLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [TempOrdersLinesTbl].[ItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersLinesTbl_OriginalOrderID' AND parent_object_id = OBJECT_ID(N'[TempOrdersLinesTbl]'))
BEGIN
    ALTER TABLE [TempOrdersLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersLinesTbl_OriginalOrderID] FOREIGN KEY([OriginalOrderID]) REFERENCES [OrdersTbl]([OrderID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersLinesTbl_OriginalOrderID];
    PRINT N'OK: Checked constraint FK_TempOrdersLinesTbl_OriginalOrderID on [TempOrdersLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersLinesTbl_OriginalOrderID] on [TempOrdersLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersTbl_OrderID' AND parent_object_id = OBJECT_ID(N'[TempOrdersTbl]'))
BEGIN
    ALTER TABLE [TempOrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersTbl_OrderID] FOREIGN KEY([OrderID]) REFERENCES [OrdersTbl]([OrderID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersTbl_OrderID];
    PRINT N'OK: Checked constraint FK_TempOrdersTbl_OrderID on [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersTbl_OrderID] on [TempOrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[TempOrdersTbl]'))
BEGIN
    ALTER TABLE [TempOrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersTbl_ContactID];
    PRINT N'OK: Checked constraint FK_TempOrdersTbl_ContactID on [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersTbl_ContactID] on [TempOrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersTbl_ItemID' AND parent_object_id = OBJECT_ID(N'[TempOrdersTbl]'))
BEGIN
    ALTER TABLE [TempOrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersTbl_ItemID] FOREIGN KEY([ItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersTbl_ItemID];
    PRINT N'OK: Checked constraint FK_TempOrdersTbl_ItemID on [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersTbl_ItemID] on [TempOrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[TempOrdersTbl]'))
BEGIN
    ALTER TABLE [TempOrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_TempOrdersTbl_ItemServiceTypeID on [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersTbl_ItemServiceTypeID] on [TempOrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TempOrdersTbl_ItemPrepTypeID' AND parent_object_id = OBJECT_ID(N'[TempOrdersTbl]'))
BEGIN
    ALTER TABLE [TempOrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_TempOrdersTbl_ItemPrepTypeID] FOREIGN KEY([ItemPrepTypeID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [TempOrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_TempOrdersTbl_ItemPrepTypeID];
    PRINT N'OK: Checked constraint FK_TempOrdersTbl_ItemPrepTypeID on [TempOrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TempOrdersTbl_ItemPrepTypeID] on [TempOrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [TempOrdersTbl].[ItemPackagingID] -> [ItemPackagingTbl]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TrackedServiceItemsTbl_ItemServiceTypeID' AND parent_object_id = OBJECT_ID(N'[TrackedServiceItemsTbl]'))
BEGIN
    ALTER TABLE [TrackedServiceItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_TrackedServiceItemsTbl_ItemServiceTypeID] FOREIGN KEY([ItemServiceTypeID]) REFERENCES [ItemServiceTypesTbl]([ItemServiceTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [TrackedServiceItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_TrackedServiceItemsTbl_ItemServiceTypeID];
    PRINT N'OK: Checked constraint FK_TrackedServiceItemsTbl_ItemServiceTypeID on [TrackedServiceItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_TrackedServiceItemsTbl_ItemServiceTypeID] on [TrackedServiceItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_UsedItemGroupsTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[UsedItemGroupsTbl]'))
BEGIN
    ALTER TABLE [UsedItemGroupsTbl] WITH NOCHECK ADD CONSTRAINT [FK_UsedItemGroupsTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [UsedItemGroupsTbl] WITH CHECK CHECK CONSTRAINT [FK_UsedItemGroupsTbl_ContactID];
    PRINT N'OK: Checked constraint FK_UsedItemGroupsTbl_ContactID on [UsedItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_UsedItemGroupsTbl_ContactID] on [UsedItemGroupsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_UsedItemGroupsTbl_GroupReferenceItemID' AND parent_object_id = OBJECT_ID(N'[UsedItemGroupsTbl]'))
BEGIN
    ALTER TABLE [UsedItemGroupsTbl] WITH NOCHECK ADD CONSTRAINT [FK_UsedItemGroupsTbl_GroupReferenceItemID] FOREIGN KEY([GroupReferenceItemID]) REFERENCES [ItemGroupsTbl]([ItemGroupID]);
END
GO

BEGIN TRY
    ALTER TABLE [UsedItemGroupsTbl] WITH CHECK CHECK CONSTRAINT [FK_UsedItemGroupsTbl_GroupReferenceItemID];
    PRINT N'OK: Checked constraint FK_UsedItemGroupsTbl_GroupReferenceItemID on [UsedItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_UsedItemGroupsTbl_GroupReferenceItemID] on [UsedItemGroupsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_UsedItemGroupsTbl_LastItemID' AND parent_object_id = OBJECT_ID(N'[UsedItemGroupsTbl]'))
BEGIN
    ALTER TABLE [UsedItemGroupsTbl] WITH NOCHECK ADD CONSTRAINT [FK_UsedItemGroupsTbl_LastItemID] FOREIGN KEY([LastItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [UsedItemGroupsTbl] WITH CHECK CHECK CONSTRAINT [FK_UsedItemGroupsTbl_LastItemID];
    PRINT N'OK: Checked constraint FK_UsedItemGroupsTbl_LastItemID on [UsedItemGroupsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_UsedItemGroupsTbl_LastItemID] on [UsedItemGroupsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_OrdersTbl_ContactID' AND parent_object_id = OBJECT_ID(N'[OrdersTbl]'))
BEGIN
    ALTER TABLE [OrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_OrdersTbl_ContactID] FOREIGN KEY([ContactID]) REFERENCES [ContactsTbl]([ContactID]);
END
GO

BEGIN TRY
    ALTER TABLE [OrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_OrdersTbl_ContactID];
    PRINT N'OK: Checked constraint FK_OrdersTbl_ContactID on [OrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_OrdersTbl_ContactID] on [OrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_OrdersTbl_ToBeDeliveredByID' AND parent_object_id = OBJECT_ID(N'[OrdersTbl]'))
BEGIN
    ALTER TABLE [OrdersTbl] WITH NOCHECK ADD CONSTRAINT [FK_OrdersTbl_ToBeDeliveredByID] FOREIGN KEY([ToBeDeliveredByID]) REFERENCES [PeopleTbl]([PersonID]);
END
GO

BEGIN TRY
    ALTER TABLE [OrdersTbl] WITH CHECK CHECK CONSTRAINT [FK_OrdersTbl_ToBeDeliveredByID];
    PRINT N'OK: Checked constraint FK_OrdersTbl_ToBeDeliveredByID on [OrdersTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_OrdersTbl_ToBeDeliveredByID] on [OrdersTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [OrderLinesTbl].[OrderID] -> [Header]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_OrderLinesTbl_ItemID' AND parent_object_id = OBJECT_ID(N'[OrderLinesTbl]'))
BEGIN
    ALTER TABLE [OrderLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_OrderLinesTbl_ItemID] FOREIGN KEY([ItemID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [OrderLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_OrderLinesTbl_ItemID];
    PRINT N'OK: Checked constraint FK_OrderLinesTbl_ItemID on [OrderLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_OrderLinesTbl_ItemID] on [OrderLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_OrderLinesTbl_PrepTypeID' AND parent_object_id = OBJECT_ID(N'[OrderLinesTbl]'))
BEGIN
    ALTER TABLE [OrderLinesTbl] WITH NOCHECK ADD CONSTRAINT [FK_OrderLinesTbl_PrepTypeID] FOREIGN KEY([PrepTypeID]) REFERENCES [ItemPrepTypesTbl]([ItemPrepID]);
END
GO

BEGIN TRY
    ALTER TABLE [OrderLinesTbl] WITH CHECK CHECK CONSTRAINT [FK_OrderLinesTbl_PrepTypeID];
    PRINT N'OK: Checked constraint FK_OrderLinesTbl_PrepTypeID on [OrderLinesTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_OrderLinesTbl_PrepTypeID] on [OrderLinesTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [OrderLinesTbl].[PackagingID] -> [ItemPackagingTbl]
-- Skipped: referenced table not in model for [RecurringOrderItemsTbl].[RecurringOrderID] -> [Header]
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RecurringOrderItemsTbl_RecurringTypeID' AND parent_object_id = OBJECT_ID(N'[RecurringOrderItemsTbl]'))
BEGIN
    ALTER TABLE [RecurringOrderItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RecurringOrderItemsTbl_RecurringTypeID] FOREIGN KEY([RecurringTypeID]) REFERENCES [RecurringTypesTbl]([RecurringTypeID]);
END
GO

BEGIN TRY
    ALTER TABLE [RecurringOrderItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_RecurringOrderItemsTbl_RecurringTypeID];
    PRINT N'OK: Checked constraint FK_RecurringOrderItemsTbl_RecurringTypeID on [RecurringOrderItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RecurringOrderItemsTbl_RecurringTypeID] on [RecurringOrderItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_RecurringOrderItemsTbl_ItemRequiredID' AND parent_object_id = OBJECT_ID(N'[RecurringOrderItemsTbl]'))
BEGIN
    ALTER TABLE [RecurringOrderItemsTbl] WITH NOCHECK ADD CONSTRAINT [FK_RecurringOrderItemsTbl_ItemRequiredID] FOREIGN KEY([ItemRequiredID]) REFERENCES [ItemsTbl]([ItemID]);
END
GO

BEGIN TRY
    ALTER TABLE [RecurringOrderItemsTbl] WITH CHECK CHECK CONSTRAINT [FK_RecurringOrderItemsTbl_ItemRequiredID];
    PRINT N'OK: Checked constraint FK_RecurringOrderItemsTbl_ItemRequiredID on [RecurringOrderItemsTbl]';
END TRY
BEGIN CATCH
    PRINT N'WARN: could not CHECK [FK_RecurringOrderItemsTbl_ItemRequiredID] on [RecurringOrderItemsTbl]: ' + ERROR_MESSAGE();
END CATCH
GO

-- Skipped: referenced table not in model for [RecurringOrderItemsTbl].[ItemPackagingID] -> [ItemPackagingTbl]
