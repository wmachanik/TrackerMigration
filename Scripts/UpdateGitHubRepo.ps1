<#
.SYNOPSIS
    Commit all changes and push to GitHub for TrackerMigration.

.DESCRIPTION
    Stages all changes, creates a commit with your message, and pushes to origin.

.PARAMETER Message
    Commit message describing your changes.

.EXAMPLE
    .\Scripts\UpdateGitHubRepo.ps1 -Message "Fix recurring spelling in migrate scripts"

.EXAMPLE
    .\Scripts\UpdateGitHubRepo.ps1 "Fix recurring spelling in migrate scripts"

.EXAMPLE
    .\Scripts\UpdateGitHubRepo.ps1
    Shows usage help (no commit is made).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Message,

    [string]$Remote = "origin",

    [string]$Branch = ""
)

function Show-UpdateGitHubRepoHelp {
    Write-Host ""
    Write-Host "UpdateGitHubRepo - commit and push TrackerMigration to GitHub" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host '  .\Scripts\UpdateGitHubRepo.ps1 -Message "Your commit message"'
    Write-Host '  .\Scripts\UpdateGitHubRepo.ps1 "Your commit message"'
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host '  .\Scripts\UpdateGitHubRepo.ps1 -Message "Fix recurring spelling in DDL scripts"'
    Write-Host '  .\Scripts\UpdateGitHubRepo.ps1 "Add project README"'
    Write-Host ""
    Write-Host "Notes:" -ForegroundColor Yellow
    Write-Host "  - Stages all changes (git add -A), commits, then pushes to origin."
    Write-Host "  - When git asks for a password, paste a GitHub Personal Access Token (scope: repo)."
    Write-Host "  - Repo: https://github.com/wmachanik/TrackerMigration"
    Write-Host ""
}

if ([string]::IsNullOrWhiteSpace($Message)) {
    Show-UpdateGitHubRepoHelp
    exit 0
}

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$previousLocation = Get-Location

try {
    Set-Location $repoRoot

    if (-not (Test-Path ".git")) {
        throw "Not a git repository: $repoRoot"
    }

    Write-Host "Repository: $repoRoot" -ForegroundColor Cyan
    git status --short

    $changes = git status --porcelain
    if ($changes) {
        git add -A

        $msgFile = Join-Path $repoRoot ".git\commit-msg-temp.txt"
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($msgFile, $Message.Trim(), $utf8NoBom)
        git commit -F $msgFile
        Remove-Item $msgFile -ErrorAction SilentlyContinue

        Write-Host "Committed:" -ForegroundColor Green
        git log -1 --oneline
    }
    else {
        Write-Host "Nothing to commit - working tree clean." -ForegroundColor Yellow
        Write-Host "Checking for unpushed commits..." -ForegroundColor Cyan
    }

    if ([string]::IsNullOrWhiteSpace($Branch)) {
        $Branch = (git rev-parse --abbrev-ref HEAD).Trim()
    }

    $remoteUrl = & git remote get-url $Remote 2>$null
    if (-not $remoteUrl) {
        Write-Host ""
        Write-Host "No remote '$Remote' configured. Run:" -ForegroundColor Yellow
        Write-Host "  .\Scripts\Git-SetupGitHub.ps1 -GitHubUser YOUR_USERNAME"
        exit 1
    }

    Write-Host "Pushing to $Remote/$Branch ..." -ForegroundColor Cyan
    git push -u $Remote $Branch
    Write-Host "GitHub repo updated: $remoteUrl" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Set-Location $previousLocation
}
