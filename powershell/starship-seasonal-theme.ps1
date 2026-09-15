<#
.SYNOPSIS
    Dynamic seasonal & holiday Starship palette selector for PowerShell.
#>
param(
    [Parameter(Position=0)]
    [string]$Action = "--ensure",
    [Parameter(Position=1)]
    [string]$ThemeName = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = Split-Path -Parent $scriptDir

# Locate starship template
$templatePath = Join-Path $repoDir "starship\starship.toml"
if (-not (Test-Path $templatePath)) {
    $templatePath = Join-Path $HOME ".config\starship\starship.toml"
}

# State directory
$stateDir = Join-Path $HOME ".local\state\starship"
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}
$activePath = Join-Path $stateDir "starship.toml"
$overridePath = Join-Path $stateDir "season-override"

function Get-SeasonForMonth {
    $month = (Get-Date).Month
    switch ($month) {
        { $_ -in 12, 1, 2 } { return "winter" }
        { $_ -in 3, 4, 5 }  { return "spring" }
        { $_ -in 6, 7, 8 }  { return "summer" }
        { $_ -in 9, 11 }    { return "autumn" }
        10                  { return "halloween" }
        Default             { return "autumn" }
    }
}

function Get-HolidayForToday {
    $date = Get-Date
    $monthDay = $date.ToString("MMdd")

    switch ($monthDay) {
        { $_ -ge "1220" -and $_ -le "1228" } { return "christmas" }
        { $_ -in "1229","1230","1231","0101" } { return "new_year" }
        { $_ -ge "0314" -and $_ -le "0317" } { return "st_patricks" }
        { $_ -ge "0701" -and $_ -le "0704" } { return "fourth_of_july" }
    }

    # Thanksgiving (4th Thursday in November)
    if ($date.Month -eq 11) {
        $firstDay = [datetime]::new($date.Year, 11, 1)
        $firstWeekday = [int]$firstDay.DayOfWeek
        $thanksgivingDay = 1 + (4 - $firstWeekday + 7) % 7 + 21
        if ($date.Day -ge ($thanksgivingDay - 3) -and $date.Day -le $thanksgivingDay) {
            return "thanksgiving"
        }
    }
    return $null
}

function Get-IconsForSeason([string]$season) {
    switch ($season) {
        "spring"         { return "🌱 🌸 🐣" }
        "summer"         { return "☀️ 🌊 🍉" }
        "autumn"         { return "🍂 🍁 🌽" }
        "halloween"      { return "🎃 👻 💀" }
        "winter"         { return "❄️ ⛄ 🏔️" }
        "christmas"      { return "🎄 🎅 🎁" }
        "st_patricks"    { return "🍀 🌈 🪙" }
        "fourth_of_july" { return "🇺🇸 🎆 🗽" }
        "thanksgiving"   { return "🦃 🥧 🍂" }
        "new_year"       { return "🎆 🥂 ✨" }
        Default          { return "🍂 🍁 🌽" }
    }
}

function Get-ActiveSeason {
    if ($env:STARSHIP_SEASON) {
        return $env:STARSHIP_SEASON
    }
    if (Test-Path $overridePath) {
        $val = (Get-Content $overridePath -Raw).Trim()
        if ($val) { return $val }
    }
    $holiday = Get-HolidayForToday
    if ($holiday) {
        return $holiday
    }
    return (Get-SeasonForMonth)
}

function Set-ThemeOverride([string]$requested) {
    if ($requested -eq "auto") {
        if (Test-Path $overridePath) { Remove-Item $overridePath -Force }
        return
    }
    $valid = @("spring","summer","autumn","halloween","winter","christmas","st_patricks","fourth_of_july","thanksgiving","new_year")
    if ($valid -contains $requested) {
        Set-Content -Path $overridePath -Value $requested -NoNewline
    } else {
        Write-Error "Unknown theme: $requested"
        exit 2
    }
}

$announce = $false

switch ($Action.ToLower()) {
    { $_ -in "set", "--set" } {
        if (-not $ThemeName) { Write-Error "Usage: set-theme set <theme>"; exit 2 }
        Set-ThemeOverride $ThemeName
        $announce = $true
    }
    "auto" {
        Set-ThemeOverride "auto"
        $announce = $true
    }
    { $_ -in "current", "--print" } {
        Write-Output (Get-ActiveSeason)
        return
    }
    { $_ -in "help", "--help", "-h" } {
        Write-Host "Starship Seasonal Theme Selector (PowerShell)"
        Write-Host "Usage: set-theme [current | auto | <theme-name>]"
        return
    }
    { $_ -in @("spring","summer","autumn","halloween","winter","christmas","st_patricks","fourth_of_july","thanksgiving","new_year") } {
        Set-ThemeOverride $Action
        $announce = $true
    }
    "--ensure" { }
    Default {
        Write-Host "Usage: set-theme [current | auto | <theme-name>]"
        return
    }
}

$season = Get-ActiveSeason
$icons = Get-IconsForSeason $season

if (Test-Path $templatePath) {
    $content = Get-Content $templatePath -Raw
    $content = $content -replace "palette = '.*' # __SEASON__", "palette = '$season' # __SEASON__"
    $content = $content -replace "__SEASON_ICONS__", $icons
    Set-Content -Path $activePath -Value $content -NoNewline
    $env:STARSHIP_CONFIG = $activePath
}

if ($announce) {
    Write-Host "Active Starship theme set to: $season" -ForegroundColor Cyan
}
