# -------------------------------------------------------------------
# PowerShell Profile - Modern Dotfiles
# Compatible with PowerShell 7 & Windows PowerShell
# -------------------------------------------------------------------

# --- UTF-8 Encoding ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- Smart Navigation Helpers ---
function Resolve-PathOption {
    param([string[]]$Paths)
    foreach ($p in $Paths) {
        if (Test-Path $p) { return $p }
    }
    return $Paths[0]
}

$DEV_DIR = if ($env:DEV_DIR) { $env:DEV_DIR } else { Resolve-PathOption @("$HOME\dev", "$HOME\Documents\dev", "$HOME\Developer", "C:\dev") }
$REPOS_DIR = if ($env:REPOS_DIR) { $env:REPOS_DIR } else { Resolve-PathOption @("$DEV_DIR\repos", "$HOME\dev\repos", "$HOME\Documents\dev\repos") }
$DOTFILES_DIR = if ($env:DOTFILES_DIR) { $env:DOTFILES_DIR } else { Resolve-PathOption @("$REPOS_DIR\dotfiles", "$HOME\dev\repos\dotfiles", "$HOME\dotfiles") }
$AI_HOME = if ($env:AI_HOME) { $env:AI_HOME } else { Resolve-PathOption @("$REPOS_DIR\ai", "$HOME\dev\repos\ai", "$HOME\Documents\dev\repos\ai") }

function dev { Set-Location $DEV_DIR }
function repos { Set-Location $REPOS_DIR }
function dotfiles { Set-Location $DOTFILES_DIR }
function chatter { Set-Location (Join-Path $REPOS_DIR "chatter") }

# --- Modern CLI Tool Aliases & Fallbacks ---
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza --icons $args }
    function ll { eza -l --icons --git $args }
    function la { eza -la --icons --git $args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat --paging=never $args }
}

# --- AI Workspace Bridge ---
if (Test-Path $AI_HOME) {
    function ai-repo { Set-Location $AI_HOME }
    function skills { Set-Location (Join-Path $AI_HOME "skills") }
    function prompts { Set-Location (Join-Path $AI_HOME "prompts") }
    $aiBin = Join-Path $AI_HOME "bin"
    if ((Test-Path $aiBin) -and ($env:Path -notlike "*$aiBin*")) {
        $env:Path = "$aiBin;$env:Path"
    }
}

# --- Starship Seasonal Prompt ---
$themeScript = Join-Path $DOTFILES_DIR "powershell\starship-seasonal-theme.ps1"
if (-not (Test-Path $themeScript)) {
    $themeScript = Join-Path $PSScriptRoot "starship-seasonal-theme.ps1"
}

if (Test-Path $themeScript) {
    & $themeScript --ensure
    function set-theme { param([string]$Action, [string]$ThemeName) & $themeScript $Action $ThemeName }
    function theme { & $themeScript help }
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- Machine-Specific / Local Overrides (Ignored by Git) ---
$localProfile = Join-Path $PSScriptRoot "profile.local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
