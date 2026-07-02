# Safe git helper for TrackerMigration — never stores passwords or tokens in this file.
# Usage:
#   .\Scripts\Git-CommitMigration.ps1 -Message "Your commit message"
#   .\Scripts\Git-CommitMigration.ps1 -Message "Fix migrate scripts" -Push
#
# First-time GitHub push: use a Personal Access Token (not your account password).
# GitHub -> Settings -> Developer settings -> Personal access tokens -> Generate new token (classic)
# Scopes: repo. When git asks for a password, paste the token.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Message,

    [switch]$Push,

    [string]$Remote = "origin",

    [string]$Branch = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Push-Location $repoRoot
try {
    if (-not (Test-Path ".git")) {
        throw "Not a git repository: $repoRoot"
    }

    Write-Host "Repository: $repoRoot" -ForegroundColor Cyan
    git status --short

    $changes = git status --porcelain
    if (-not $changes) {
        Write-Host "Nothing to commit — working tree clean." -ForegroundColor Yellow
        if ($Push) {
            if ([string]::IsNullOrWhiteSpace($Branch)) {
                $Branch = (git rev-parse --abbrev-ref HEAD).Trim()
            }
            Write-Host "Pushing $Remote/$Branch ..."
            git push $Remote $Branch
        }
        return
    }

    git add -A
    git commit -m $Message

    Write-Host "Committed:" -ForegroundColor Green
    git log -1 --oneline

    if ($Push) {
        if ([string]::IsNullOrWhiteSpace($Branch)) {
            $Branch = (git rev-parse --abbrev-ref HEAD).Trim()
        }
        if (-not (git remote get-url $Remote 2>$null)) {
            Write-Host @"

No remote '$Remote' configured. Create an empty repo on GitHub, then run:

  git remote add origin https://github.com/YOUR_USERNAME/TrackerMigration.git
  git branch -M main
  .\Scripts\Git-CommitMigration.ps1 -Message "..." -Push

"@ -ForegroundColor Yellow
            return
        }

        Write-Host "Pushing to $Remote/$Branch (use PAT when prompted for password)..." -ForegroundColor Cyan
        git push -u $Remote $Branch
        Write-Host "Push complete." -ForegroundColor Green
    }
}
finally {
    Pop-Location
}
