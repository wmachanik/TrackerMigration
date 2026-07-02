-- Migration script for table: TempOrdersHeaderTbl
DELETE FROM [TempOrdersHeaderTbl];
SET IDENTITY_INSERT [TempOrdersHeaderTbl] ON;
INSERT INTO [TempOrdersHeaderTbl] (
[TOHeaderID], [ContactID], [OrderDate], [RoastDate], [RequiredByDate], [ToBeDeliveredByID], [Confirmed], [Done], [Notes]
)
SELECT
[TOHeaderID], [CustomerID], CAST(dbo.SafeDateConvert([OrderDate]) AS DATE) AS [OrderDate], CAST(dbo.SafeDateConvert([RoastDate]) AS DATE) AS [RoastDate], CAST(dbo.SafeDateConvert([RequiredByDate]) AS DATE) AS [RequiredByDate], [ToBeDeliveredByID], [Confirmed], [Done], [Notes]
FROM [AccessSrc].[TempOrdersHeaderTbl];
SET IDENTITY_INSERT [TempOrdersHeaderTbl] OFF;
