-- Migration script for table: ClosureDatesTbl
DELETE FROM [ClosureDatesTbl];
SET IDENTITY_INSERT [ClosureDatesTbl] ON;
INSERT INTO [ClosureDatesTbl] (
[ClosureDateID], [DateClosed], [DateReopen], [NextPreparationDate], [Comments]
)
SELECT
[ID], CAST(dbo.SafeDateConvert([DateClosed]) AS DATE) AS [DateClosed], CAST(dbo.SafeDateConvert([DateReopen]) AS DATE) AS [DateReopen], CAST(dbo.SafeDateConvert([NextRoastDate]) AS DATE) AS [NextPreparationDate], [Comments]
FROM [AccessSrc].[ClosureDatesTbl];
SET IDENTITY_INSERT [ClosureDatesTbl] OFF;

