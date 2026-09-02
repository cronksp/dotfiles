# -------------------------------------------------------------------
# Shared Shell Aliases & Functions (Bash & Zsh)
# Simple, fast, and portable across all machines & devcontainers
# -------------------------------------------------------------------

# --- Smart Navigation Helpers ---
# Probes common locations if not explicitly overridden in ~/.bashrc.local
_resolve_path() {
    for p in "$@"; do
        if [ -d "$p" ]; then
            echo "$p"
            return 0
        fi
    done
    echo "$1" # fallback to first option
}

export DEV_DIR="${DEV_DIR:-$(_resolve_path "$HOME/dev" "$HOME/Documents/dev" "$HOME/Developer" "/workspaces")}"
export REPOS_DIR="${REPOS_DIR:-$(_resolve_path "$DEV_DIR/repos" "$HOME/dev/repos" "$HOME/Documents/dev/repos" "/workspaces")}"
export DOTFILES_DIR="${DOTFILES_DIR:-$(_resolve_path "$REPOS_DIR/dotfiles" "$HOME/dev/repos/dotfiles" "$HOME/Documents/dev/repos/dotfiles" "$HOME/dotfiles")}"
export AI_HOME="${AI_HOME:-$(_resolve_path "$REPOS_DIR/ai" "$HOME/dev/repos/ai" "$HOME/Documents/dev/repos/ai")}"

alias dev='cd "$DEV_DIR"'
alias repos='cd "$REPOS_DIR"'
alias dotfiles='cd "$DOTFILES_DIR"'
alias chatter='cd "$(_resolve_path "$REPOS_DIR/chatter" "$HOME/dev/repos/chatter")"'
alias wrk='cd /workspaces'

# --- Shell Reload Shortcuts ---
alias loadb='source ~/.bashrc'
alias loadz='source ~/.zshrc'

# --- Starship Seasonal Theme Management ---
alias theme='starship-seasonal-theme help'
alias set-theme='starship-seasonal-theme'

# --- Modern CLI Tool Replacements (Graceful Fallbacks) ---
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --level=2 --icons'
elif [[ "${OSTYPE:-}" == darwin* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
elif command -v batcat &> /dev/null; then
    alias cat='batcat --paging=never'
    alias bat='batcat'
fi

if command -v zeditor &> /dev/null; then
    alias zed='env -u LIBGL_ALWAYS_SOFTWARE zeditor'
fi

# --- AI Workspace Bridge ---
if [ -d "$AI_HOME" ]; then
    alias ai-repo='cd "$AI_HOME"'
    alias skills='cd "$AI_HOME/skills"'
    alias prompts='cd "$AI_HOME/prompts"'
    if [ -d "$AI_HOME/bin" ] && [[ ":$PATH:" != *":$AI_HOME/bin:"* ]]; then
        export PATH="$AI_HOME/bin:$PATH"
    fi
fi
