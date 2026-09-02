<#
.SYNOPSIS
    Windows PowerShell & Windows Terminal Dotfiles Installer
#>
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = Split-Path -Parent $scriptDir

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "    Windows & PowerShell Dotfiles Setup     " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# 1. Verify Starship is installed
if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Starship not found. Installing via winget..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Starship.Starship -e --silent
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install starship
    } else {
        Write-Warning "Please install Starship manually: https://starship.rs"
    }
} else {
    Write-Host "[ OK ] Starship is already installed." -ForegroundColor Green
}

# 2. Setup PowerShell Profiles
$profileDirs = @(
    (Split-Path -Parent $PROFILE.CurrentUserCurrentHost),
    (Split-Path -Parent $PROFILE.CurrentUserAllHosts)
) | Select-Object -Unique

foreach ($dir in $profileDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $targetProfile = Join-Path $dir "Microsoft.PowerShell_profile.ps1"
    $sourceProfile = Join-Path $scriptDir "Microsoft.PowerShell_profile.ps1"

    if (Test-Path $targetProfile) {
        $backup = "$targetProfile.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "[WARN] Backing up existing profile to $backup" -ForegroundColor Yellow
        Move-Item -Path $targetProfile -Destination $backup -Force
    }

    Copy-Item -Path $sourceProfile -Destination $targetProfile -Force
    Write-Host "[ OK ] PowerShell profile configured at $targetProfile" -ForegroundColor Green
}

# 3. Setup Starship config
$starshipConfigDir = Join-Path $HOME ".config\starship"
if (-not (Test-Path $starshipConfigDir)) {
    New-Item -ItemType Directory -Path $starshipConfigDir -Force | Out-Null
}
$starshipSource = Join-Path $repoDir "starship\starship.toml"
$starshipTarget = Join-Path $starshipConfigDir "starship.toml"
Copy-Item -Path $starshipSource -Destination $starshipTarget -Force
Write-Host "[ OK ] Starship template configured at $starshipTarget" -ForegroundColor Green

# 4. Initialize Theme
$themeScript = Join-Path $scriptDir "starship-seasonal-theme.ps1"
if (Test-Path $themeScript) {
    & $themeScript --ensure
    Write-Host "[ OK ] Starship seasonal theme initialized." -ForegroundColor Green
}

Write-Host "`n[ OK ] Windows & PowerShell installation complete! 🚀" -ForegroundColor Green
Write-Host "[INFO] Restart PowerShell or run: . `$PROFILE" -ForegroundColor Cyan
