-- Migration script for table: NextPreparationDateByAreasTbl
DELETE FROM [NextPreparationDateByAreasTbl];
SET IDENTITY_INSERT [NextPreparationDateByAreasTbl] ON;
INSERT INTO [NextPreparationDateByAreasTbl] (
[NextPrepDayID], [AreaID], [PreparationDate], [DeliveryDate], [DeliveryOrder], [NextPreparationDate], [NextDeliveryDate]
)
SELECT
[NextRoastDayID], [CityID], CAST(dbo.SafeDateConvert([PreperationDate]) AS DATE) AS [PreparationDate], CAST(dbo.SafeDateConvert([DeliveryDate]) AS DATE) AS [DeliveryDate], [DeliveryOrder], CAST(dbo.SafeDateConvert([NextPreperationDate]) AS DATE) AS [NextPreparationDate], CAST(dbo.SafeDateConvert([NextDeliveryDate]) AS DATE) AS [NextDeliveryDate]
FROM [AccessSrc].[NextRoastDateByCityTbl];
SET IDENTITY_INSERT [NextPreparationDateByAreasTbl] OFF;

