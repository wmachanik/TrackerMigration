-- Migration script for table: ContactsAwayPeriodTbl
DELETE FROM [ContactsAwayPeriodTbl];
SET IDENTITY_INSERT [ContactsAwayPeriodTbl] ON;
INSERT INTO [ContactsAwayPeriodTbl] (
[AwayPeriodID], [ContactID], [AwayStartDate], [AwayEndDate], [ReasonID]
)
SELECT
[AwayPeriodID], [ClientID], CAST(dbo.SafeDateConvert([AwayStartDate]) AS DATE) AS [AwayStartDate], CAST(dbo.SafeDateConvert([AwayEndDate]) AS DATE) AS [AwayEndDate], [ReasonID]
FROM [AccessSrc].[ClientAwayPeriodTbl];
SET IDENTITY_INSERT [ContactsAwayPeriodTbl] OFF;
