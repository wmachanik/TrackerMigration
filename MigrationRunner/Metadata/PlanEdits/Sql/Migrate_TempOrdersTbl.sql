-- Migration script for table: TempOrdersTbl
DELETE FROM [TempOrdersTbl];
SET IDENTITY_INSERT [TempOrdersTbl] ON;
INSERT INTO [TempOrdersTbl] (
[TempOrderID], [OrderID], [ContactID], [OrderDate], [RoastDate], [ItemID], [ItemServiceTypeID], [ItemPrepTypeID], [ItemPackagingID], [QtyOrdered], [RequiredByDate], [Delivered], [Notes]
)
SELECT
[TempOrderId], [OrderID], [CustomerId], CAST(dbo.SafeDateConvert([OrderDate]) AS DATE) AS [OrderDate], CAST(dbo.SafeDateConvert([RoastDate]) AS DATE) AS [RoastDate], [ItemTypeID], [ServiceTypeId], [PrepTypeID], [PackagingId], [QuantityOrdered], CAST(dbo.SafeDateConvert([RequiredByDate]) AS DATE) AS [RequiredByDate], [Delivered], [Notes]
FROM [AccessSrc].[TempOrdersTbl];
SET IDENTITY_INSERT [TempOrdersTbl] OFF;
