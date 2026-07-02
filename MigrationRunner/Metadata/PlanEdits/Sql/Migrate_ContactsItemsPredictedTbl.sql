-- Migration script for table: ContactsItemsPredictedTbl
use [OtterDb]
DELETE FROM [OtterDb].[dbo].[ContactsItemsPredictedTbl];
-- SET IDENTITY_INSERT [ContactsItemsPredictedTbl] ON;
INSERT INTO [OtterDb].[dbo].[ContactsItemsPredictedTbl] (
[ContactID], [LastCupCount], [NextCoffeeBy], [NextCleanOn], [NextFilterEst], [NextDescaleEst], [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount], [CleanAveCount]
)
SELECT
[CustomerId], [LastCupCount], CAST(dbo.SafeDateConvert([NextCoffeeBy]) AS DATE) AS [NextCoffeeBy], CAST(dbo.SafeDateConvert([NextCleanOn]) AS DATE) AS [NextCleanOn], CAST(dbo.SafeDateConvert([NextFilterEst]) AS DATE) AS [NextFilterEst], CAST(dbo.SafeDateConvert([NextDescaleEst]) AS DATE) AS [NextDescaleEst], CAST(dbo.SafeDateConvert([NextServiceEst]) AS DATE) AS [NextServiceEst], [DailyConsumption], [FilterAveCount], [DescaleAveCount], [ServiceAveCount], [CleanAveCount]
FROM [AccessSrc].[ClientUsageTbl];
-- SET IDENTITY_INSERT [ContactsItemsPredictedTbl] OFF;
