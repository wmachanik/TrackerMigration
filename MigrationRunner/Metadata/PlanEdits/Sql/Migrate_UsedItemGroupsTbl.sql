-- Migration script for table: UsedItemGroupsTbl
DELETE FROM [UsedItemGroupsTbl];
SET IDENTITY_INSERT [UsedItemGroupsTbl] ON;
INSERT INTO [UsedItemGroupsTbl] (
[UsedItemGroupID], [ContactID], [GroupItemServiceTypeID], [LastItemID], [LastItemSortPos], [LastItemDateChanged], [Notes]
)
SELECT
[UsedItemGroupID], [ContactID], [GroupItemTypeID], [LastItemTypeID], [LastItemTypeSortPos], CAST(dbo.SafeDateConvert([LastItemDateChanged]) AS DATE) AS [LastItemDateChanged], [Notes]
FROM [AccessSrc].[UsedItemGroupTbl];
SET IDENTITY_INSERT [UsedItemGroupsTbl] OFF;
