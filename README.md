# TrackerMigration

Migrate a legacy **Microsoft Access** database to **SQL Server** with a repeatable, menu-driven pipeline. Supports **copy**, **rename**, and **normalize** table strategies, hand-tuned per-table SQL scripts, and fixes for legacy Access spelling in column names.

## What it does

| Strategy | Example | How |
|----------|---------|-----|
| **Copy** | `AwayReasonTbl` → `AwayReasonTbl` | `Migrate_*.sql` reads `AccessSrc`, inserts into `dbo` |
| **Rename** | `CustomersTbl` → `ContactsTbl`, `CustomerID` → `ContactID` | Column mapping in `Migrate_*.sql` |
| **Normalize** | `OrdersTbl` → `OrdersTbl` + `OrderLinesTbl` | Menu `!` (`CustomNormalizeRunner`) |
| **Normalize** | `ReoccuringOrderTbl` → `RecurringOrdersTbl` + `RecurringOrderItemsTbl` | Menu `!` |

**Recommended end-to-end run:** menu option **`99`** — drop tables, stage Access, apply DDL, run all `Migrate_*.sql` scripts, apply FKs, then Orders + Recurring normalisation.

## Prerequisites

- **Windows** (Access OLE DB / ACE)
- **.NET Framework 4.8**
- **SQL Server** (e.g. Express) with a target database
- **Microsoft Access Database Engine** (ACE OLEDB 16.0) for `.mdb` / `.accdb`
- Source **Access** file (e.g. `QuaffeeTracker08.mdb`)

## Quick start

### 1. Clone and configure

```powershell
git clone https://github.com/wmachanik/TrackerMigration.git
cd TrackerMigration
copy MigrationRunner\MigrationConfig.example.json MigrationRunner\MigrationConfig.json
```

Edit `MigrationRunner\MigrationConfig.json`:

```json
{
  "AccessConnectionString": "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=C:\\Path\\To\\Your\\Tracker.mdb;",
  "TargetConnectionString": "Server=.\\SQLEXPRESS;Database=OtterDb;Trusted_Connection=True;MultipleActiveResultSets=True;",
  "AccessTables": ["*"],
  "AccessTableExcludes": ["ContactTypeView"]
}
```

`MigrationConfig.json` is gitignored — it stays on your machine only.

### 2. Build and run

```powershell
dotnet build .\MigrationRunner\MigrationRunner.csproj
dotnet run --project .\MigrationRunner\MigrationRunner.csproj
```

Or run the built exe:

```powershell
.\MigrationRunner\bin\Debug\net48\MigrationRunner.exe
```

### 3. Run the full migration

At the menu, choose **`99`** (Refresh and migrate all).

Pipeline steps:

1. Drop all user tables (`dbo` + `AccessSrc`)
2. **MS** — stage Access → `AccessSrc`
3. Apply **`CreateTables_LATEST_FIXED.sql`** (CREATE only, no FKs)
4. Run all **`Migrate_*.sql`** scripts in FK dependency order
5. Apply **`AddForeignKeys_LATEST.sql`**
6. **`!`** — Orders + Recurring normalisation

## Key menu options

| Key | Purpose |
|-----|---------|
| **99** | Full refresh + migrate (recommended) |
| **MS** | Stage Access data into `[AccessSrc]` |
| **C** | Apply CREATE TABLE DDL |
| **$** | Table-by-table `Migrate_*.sql` migration |
| **!** | Custom normalise Orders + Recurring |
| **>** | Regenerate `Migrate_*.sql` from CSV (**overwrites** hand-tuned scripts — use with care) |
| **Z** | Full generator pipeline (A→B→C→D→M→MS→N→!) — can overwrite generated SQL |

## Project layout

```
TrackerMigration/
├── MigrationRunner/              # Main .NET app
│   ├── CustomNormalizeRunner.cs  # Orders + Recurring normalisation
│   ├── Metadata/
│   │   ├── AccessSchema/         # Exported Access table/column metadata
│   │   └── PlanEdits/
│   │       ├── Csv/              # Migration plan CSV reports
│   │       └── Sql/
│   │           ├── CreateTables_LATEST_FIXED.sql   # Canonical DDL
│   │           ├── Migrate_*.sql                   # Hand-tuned per-table DML
│   │           └── AddForeignKeys_LATEST.sql
│   └── MigrationConfig.example.json
├── Docs/
│   └── DATETIME_TO_DATE_MIGRATION_CHECKLIST.md
└── Scripts/
    ├── Git-CommitMigration.ps1
    └── Git-SetupGitHub.ps1
```

## Canonical SQL scripts

- **DDL:** `MigrationRunner/Metadata/PlanEdits/Sql/CreateTables_LATEST_FIXED.sql`
- **DML:** `MigrationRunner/Metadata/PlanEdits/Sql/Migrate_<TableName>.sql`
- **FKs:** `MigrationRunner/Metadata/PlanEdits/Sql/AddForeignKeys_LATEST.sql`

Option **99** uses the **FIXED** create script and does **not** regenerate SQL from CSV.

## Column renames (Access → SQL)

Legacy Access names often differ from the target `dbo` schema. In `Migrate_*.sql`:

- **INSERT** column list = **target** (`dbo`) names
- **SELECT** = **AccessSrc** names, with `AS [TargetColumn]` when they differ

| AccessSrc | dbo (target) |
|-----------|----------------|
| `NextPrepDate` | `NextPreparationDate` |
| `LastReoccurringDate` | `LastRecurringDate` |
| `DoReoccuringOrders` | `DoRecurringOrders` |
| `HadReoccurItems` | `HadRecurringItems` |
| `ReoccurOrderID` | `RecurringOrderItemID` |
| `ReoccuranceTypeTbl` | `RecurringTypesTbl` |
| `PreferedAgent` / `PreferedAgentID` | `PreferredAgentID` |
| `CustomerID` | `ContactID` (many tables) |

See `Docs/DATETIME_TO_DATE_MIGRATION_CHECKLIST.md` and `Docs/RECURRING_SPELLING_REFERENCE.md`.

## Git helpers

```powershell
.\Scripts\UpdateGitHubRepo.ps1 -Message "Describe your change"
.\Scripts\UpdateGitHubRepo.ps1                          # show help
.\Scripts\Git-CommitMigration.ps1 -Message "..." -Push  # same idea, optional -Push only
```

Use a GitHub **Personal Access Token** (not your account password) when pushing.

## Troubleshooting

| Issue | Likely cause |
|-------|----------------|
| `Invalid column name 'X'` in `Migrate_*.sql` | SELECT uses dbo name instead of AccessSrc name (or vice versa) |
| `PreferedAgentID` error in normalisation | C# must read `PreferredAgentID` from `ContactsTbl` — rebuild after pulling |
| FK apply warns on `PreferedAgentID` | `AddForeignKeys_LATEST.sql` must reference `PreferredAgentID` |
| Build fails — exe locked | Exit running `MigrationRunner.exe` before rebuilding |
| Option `>` overwrote scripts | Regenerates all `Migrate_*.sql` from CSV; restore from git or backups |

## License

Private / internal use — add a license if you intend to open-source this repo.

## Author

Warren Machanik — [github.com/wmachanik](https://github.com/wmachanik)
