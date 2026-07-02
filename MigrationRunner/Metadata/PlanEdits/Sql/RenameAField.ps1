<#
.SYNOPSIS
Replaces text in all .sql files within a folder.

.DESCRIPTION
Searches recursively through a folder for .sql files and replaces all
occurrences of a given string with another string.

.PARAMETER FromText
The text to search for.

.PARAMETER ToText
The text to replace it with.

.PARAMETER FolderPath
The root folder to process (default = current folder).

.PARAMETER WhatIf
Preview changes without modifying files.

.EXAMPLE
.\replace-sql-text.ps1 -FromText "OldValue" -ToText "NewValue"

.EXAMPLE
.\replace-sql-text.ps1 -FromText "A" -ToText "B" -FolderPath "C:\SQL" -WhatIf
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="Text to find")]
    [ValidateNotNullOrEmpty()]
    [string]$FromText,

    [Parameter(Mandatory=$true, HelpMessage="Text to replace with")]
    [string]$ToText,

    [Parameter()]
    [string]$FolderPath = ".",

    [switch]$WhatIf
)

try {
    # Validate path
    if (!(Test-Path $FolderPath)) {
        throw "Folder does not exist: $FolderPath"
    }

    # Prevent pointless run
    if ($FromText -eq $ToText) {
        throw "FromText and ToText cannot be the same."
    }

    Write-Host "Starting replacement..." -ForegroundColor Cyan
    Write-Host "From: '$FromText'" -ForegroundColor Yellow
    Write-Host "To:   '$ToText'" -ForegroundColor Yellow
    Write-Host "Folder: $FolderPath" -ForegroundColor Yellow

    $files = Get-ChildItem -Path $FolderPath -Filter *.sql -Recurse -ErrorAction Stop

    foreach ($file in $files) {

        $content = Get-Content $file.FullName -Raw -ErrorAction Stop

        # Escape special regex chars
        $pattern = [regex]::Escape($FromText)

        $newContent = $content -replace $pattern, $ToText

        if ($content -ne $newContent) {

            if ($WhatIf) {
                Write-Host "[Preview] Would update: $($file.FullName)" -ForegroundColor Cyan
            }
            else {
                Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -ErrorAction Stop
                Write-Host "Updated: $($file.FullName)" -ForegroundColor Green
            }

        } else {
            Write-Host "No change: $($file.FullName)" -ForegroundColor DarkYellow
        }
    }

    Write-Host "Done." -ForegroundColor Cyan
}
catch {
    Write-Error "Error: $_"
}