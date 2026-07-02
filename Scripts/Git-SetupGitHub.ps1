# One-time setup: link this repo to a new GitHub repository.
# Does NOT store credentials. You will be prompted when pushing.
#
# Usage:
#   .\Scripts\Git-SetupGitHub.ps1 -GitHubUser YOUR_USERNAME -RepoName TrackerMigration
#
# Then push with a Personal Access Token (GitHub no longer accepts account passwords for git).

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubUser,

    [string]$RepoName = "TrackerMigration",

    [string]$Remote = "origin",

    [ValidateSet("main", "master")]
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Push-Location $repoRoot
try {
    if (-not (Test-Path ".git")) {
        git init
    }

    $url = "https://github.com/$GitHubUser/$RepoName.git"

    $existing = git remote get-url $Remote 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Remote '$Remote' already set to: $existing"
        $answer = Read-Host "Replace with $url ? [y/N]"
        if ($answer -match '^[Yy]') {
            git remote set-url $Remote $url
        }
    }
    else {
        git remote add $Remote $url
    }

    git branch -M $Branch

    Write-Host @"

Local repo is ready.

1. Create an empty repository on GitHub named '$RepoName' (no README/license if repo already has commits).
2. Create a Personal Access Token: GitHub -> Settings -> Developer settings -> PAT (classic), scope 'repo'.
3. Push:

   git push -u $Remote $Branch

   Username: $GitHubUser
   Password: paste your PAT (not your GitHub account password)

Or use:

   .\Scripts\Git-CommitMigration.ps1 -Message "Your message" -Push

"@ -ForegroundColor Green
}
finally {
    Pop-Location
}
