# Tool-update helpers for Arch/Omarchy & Mise. Source this from ~/.bashrc.

# Mise manages Codex and the other tools declared in ~/.config/mise/config.toml.
codex-upgrade-preview() {
    mise upgrade --dry-run codex
}

codex-upgrade() {
    mise upgrade codex && codex --version
}

mise-upgrade-preview() {
    mise upgrade --dry-run
}

# Show pending updates before applying them. `checkupdates` covers official
# repositories; yay covers AUR packages such as user-installed helpers.
arch-upgrade-preview() {
    checkupdates || [[ $? -eq 2 ]]
    if command -v yay >/dev/null 2>&1; then
        yay -Qua
    fi
}

# Apply all official-repository and AUR updates after reviewing the preview.
arch-upgrade() {
    yay -Syu
}

alias codex-update-check='codex-upgrade-preview'
alias codex-update='codex-upgrade'
alias updates-check='arch-upgrade-preview'
alias updates='arch-upgrade'
