-- Migration script for table: ItemGroupsTbl
DELETE FROM [ItemGroupsTbl];
SET IDENTITY_INSERT [ItemGroupsTbl] ON;
INSERT INTO [ItemGroupsTbl] (
[ItemGroupID], [GroupItemServiceTypeID], [ItemID], [ItemSortPos], [Enabled], [Notes]
)
SELECT
[ItemGroupID], [GroupItemTypeID], [ItemTypeID], [ItemTypeSortPos], [Enabled], [Notes]
FROM [AccessSrc].[ItemGroupTbl];
SET IDENTITY_INSERT [ItemGroupsTbl] OFF;
