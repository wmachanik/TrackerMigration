-- Migration script for table: TempCoffeecheckupItemsTbl
DELETE FROM [TempCoffeecheckupItemsTbl];
SET IDENTITY_INSERT [TempCoffeecheckupItemsTbl] ON;
INSERT INTO [TempCoffeecheckupItemsTbl] (
[TCIID], [ContactID], [ItemID], [ItemQty], [ItemPrepID], [ItemPackagingID], [AutoFulfill], [NextDateRequired], [RecurringOrderItemID]
)
SELECT
[TCIID], [CustomerID], [ItemID], [ItemQty], [ItemPrepID], [ItemPackagID], [AutoFulfill], CAST(dbo.SafeDateConvert([NextDateRequired]) AS DATE) AS [NextDateRequired], [ReoccurOrderID] AS [RecurringOrderItemID]
FROM [AccessSrc].[TempCoffeecheckupItemsTbl];
SET IDENTITY_INSERT [TempCoffeecheckupItemsTbl] OFF;
