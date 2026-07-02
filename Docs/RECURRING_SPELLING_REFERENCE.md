# Recurring spelling reference (Access → SQL)

Legacy Access and intermediate targets used several misspellings of **recurring**. Canonical **dbo** names in `CreateTables_LATEST_FIXED.sql` use correct spelling. **AccessSrc** keeps Access names; `Migrate_*.sql` maps them with `AS [TargetColumn]`.

## dbo targets (correct spelling)

| Table / column | Was (wrong) | Now (correct) |
|----------------|-------------|---------------|
| `RecurringTypesTbl` | `RecurranceTypesTbl` | `RecurringTypesTbl` |
| `SysDataTbl.DoRecurringOrders` | `DoReccuringOrders` | `DoRecurringOrders` |
| `SentRemindersLogTbl.HadRecurringItems` | `HadRecurrItems` | `HadRecurringItems` |

Already correct in dbo (no change needed):

- `LastRecurringDate` (`SysDataTbl`)
- `RecurringOrdersTbl`, `RecurringOrderItemsTbl`, `RecurringOrderID`, `RecurringOrderItemID`, `RecurringTypeID`

## AccessSrc source names (unchanged — use in SELECT only)

| Access / AccessSrc | Used in |
|--------------------|---------|
| `ReoccuranceTypeTbl` | → `RecurringTypesTbl` |
| `ReoccuringOrderTbl` | Normalised by menu `!` → `RecurringOrdersTbl` + `RecurringOrderItemsTbl` |
| `LastReoccurringDate` | → `LastRecurringDate` |
| `DoReoccuringOrders` | → `DoRecurringOrders` |
| `HadReoccurItems` | → `HadRecurringItems` |
| `ReoccurOrderID` | → `RecurringOrderItemID` |
| `ReoccuranceType` | → `RecurringTypeID` (recurring order lines, via normaliser) |

## Scripts updated

| File | Change |
|------|--------|
| `CreateTables_LATEST_FIXED.sql` | Table + column renames |
| `CreateTables_LATEST.sql` | Synced from FIXED |
| `AddForeignKeys_LATEST.sql` | FK → `RecurringTypesTbl` |
| `Migrate_RecurringTypesTbl.sql` | Renamed from `Migrate_RecurranceTypesTbl.sql` |
| `Migrate_SysDataTbl.sql` | `DoRecurringOrders` |
| `Migrate_SentRemindersLogTbl.sql` | `HadRecurringItems` |
| `Migrate_TempCoffeecheckupItemsTbl.sql` | `ReoccurOrderID` AS `RecurringOrderItemID` |
| `Verify_RecurringTypesTbl.sql` | Renamed from `Verify_RecurranceTypesTbl.sql` |

## After pulling these changes

Re-run option **99** (or at least steps 1, 3, 4, 5) so dbo tables are recreated with the new names.

**Do not** run menu `>` to regenerate `Migrate_*.sql` unless you intend to overwrite hand-tuned scripts.

## Not changed (historical / generated)

- `DataMigration_*.sql` — auto-generated bundles; option 99 does not use them
- `Data/*.csv` — migration plan history
- Access source table names in `AccessSrc` after staging (always match Access)
