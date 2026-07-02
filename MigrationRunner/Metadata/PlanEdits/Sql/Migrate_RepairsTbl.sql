-- Migration script for table: RepairsTbl
DELETE FROM [RepairsTbl];
SET IDENTITY_INSERT [RepairsTbl] ON;
INSERT INTO [RepairsTbl] (
[RepairID], [ContactID], [ContactName], [ContactEmail], [JobCardNumber], [DateLogged], [LastStatusChange], [EquipTypeID], [EquipSerialNumber], [SwopOutMachineID], [EquipConditionID], [TakenFrother], [TakenBeanLid], [TakenWaterLid], [BrokenFrother], [BrokenBeanLid], [BrokenWaterLid], [RepairFaultID], [RepairFaultDesc], [RepairStatusID], [RelatedOrderID], [Notes]
)
SELECT
[RepairID], [CustomerID], [ContactName], [ContactEmail], [JobCardNumber], CAST(dbo.SafeDateConvert([DateLogged]) AS DATE) AS [DateLogged], CAST(dbo.SafeDateConvert([LastStatusChange]) AS DATE) AS [LastStatusChange], [MachineTypeID], [MachineSerialNumber], [SwopOutMachineID], [MachineConditionID], [TakenFrother], [TakenBeanLid], [TakenWaterLid], [BrokenFrother], [BrokenBeanLid], [BrokenWaterLid], [RepairFaultID], [RepairFaultDesc], [RepairStatusID], [RelatedOrderID], [Notes]
FROM [AccessSrc].[RepairsTbl];
SET IDENTITY_INSERT [RepairsTbl] OFF;
