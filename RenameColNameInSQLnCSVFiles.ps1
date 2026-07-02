[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$SourceColumn,
    [string]$TargetColumn
)

# --- Use current directory as root ---
$RootPath = Get-Location

# --- Prompt for missing parameters ---
if (-not $SourceColumn) {
    $SourceColumn = Read-Host "Enter source column name (e.g. NextPrepDate)"
}
if (-not $TargetColumn) {
    $TargetColumn = Read-Host "Enter target column name"
}

Write-Host "`nStarting scan in: $RootPath" -ForegroundColor Cyan
Write-Host "Replacing: '$SourceColumn' -> '$TargetColumn'" -ForegroundColor Yellow

# --- Get SQL files ---
$sqlFiles = Get-ChildItem -Path $RootPath -Recurse -Filter *.sql -File -ErrorAction SilentlyContinue

# --- Get latest CSV files per folder ---
$csvFiles = Get-ChildItem -Path $RootPath -Recurse -Filter *.csv -File -ErrorAction SilentlyContinue |
    Group-Object DirectoryName |
    ForEach-Object {
        $_.Group | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }

# --- Get XML files ---
$xmlFiles = Get-ChildItem -Path $RootPath -Recurse -Filter *.xml -File -ErrorAction SilentlyContinue

# --- Get Markdown files ---
$mdFiles = Get-ChildItem -Path $RootPath -Recurse -Filter *.md -File -ErrorAction SilentlyContinue

# --- Combine all files ---
$allFiles = $sqlFiles + $csvFiles + $xmlFiles + $mdFiles

if (-not $allFiles -or $allFiles.Count -eq 0) {
    Write-Warning "No matching files found."
    return
}

Write-Host "Files found: $($allFiles.Count)`n"

# --- Replace logic ---
$updatedCount = 0

# Safe regex escape
$escapedSource = [regex]::Escape($SourceColumn)
$pattern = "\b$escapedSource\b"

foreach ($file in $allFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction Stop

        if ($content -match $escapedSource) {

            $targetDescription = $file.FullName

            if ($PSCmdlet.ShouldProcess($targetDescription, "Replace '$SourceColumn' with '$TargetColumn'")) {

                # Backup file
                $backupPath = "$($file.FullName).bak"
                Copy-Item $file.FullName $backupPath -Force

                # Replace text
                $newContent = $content -replace $pattern, $TargetColumn

                # Save file
                Set-Content $file.FullName $newContent -ErrorAction Stop

                Write-Host "Updated: $($file.FullName)" -ForegroundColor Green
                $updatedCount++
            }
            else {
                Write-Host "Would update: $($file.FullName)" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "Error processing: $($file.FullName)" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

Write-Host "`nCompleted. Files updated: $updatedCount" -ForegroundColor Cyan