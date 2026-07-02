-- Migration script for table: TempCoffeecheckupCustomerTbl
DELETE FROM [TempCoffeecheckupCustomerTbl];
SET IDENTITY_INSERT [TempCoffeecheckupCustomerTbl] ON;
INSERT INTO [TempCoffeecheckupCustomerTbl] (
[TCCID], [ContactID], [CompanyName], [ContactFirstName], [ContactAltFirstName], [AreaID], [EmailAddress], [AltEmailAddress], [ContactTypeID], [EquipTypeID], [TypicallySecToo], [PreferredAgentID], [SalesAgentID], [UsesFilter], [Enabled], [AlwaysSendChkUp], [ReminderCount], [NextPreparationDate], [NextDeliveryDate], [NextCoffee], [NextClean], [NextFilter], [NextDescal], [NextService], [RequiresPurchOrder]
)
SELECT
[TCCID], [CustomerID], [CompanyName], [ContactFirstName], [ContactAltFirstName], [CityID], [EmailAddress], [AltEmailAddress], [CustomerTypeID], [EquipTypeID], [TypicallySecToo], [PreferedAgentID], [SalesAgentID], [UsesFilter], [enabled], [AlwaysSendChkUp], [ReminderCount], CAST(dbo.SafeDateConvert([NextPrepDate]) AS DATE) AS [NextPreparationDate], CAST(dbo.SafeDateConvert([NextDeliveryDate]) AS DATE) AS [NextDeliveryDate], CAST(dbo.SafeDateConvert([NextCoffee]) AS DATE) AS [NextCoffee], CAST(dbo.SafeDateConvert([NextClean]) AS DATE) AS [NextClean], CAST(dbo.SafeDateConvert([NextFilter]) AS DATE) AS [NextFilter], CAST(dbo.SafeDateConvert([NextDescal]) AS DATE) AS [NextDescal], CAST(dbo.SafeDateConvert([NextService]) AS DATE) AS [NextService], [RequiresPurchOrder]
FROM [AccessSrc].[TempCoffeecheckupCustomerTbl];
SET IDENTITY_INSERT [TempCoffeecheckupCustomerTbl] OFF;

