# -------------------------------------------------------------------
# ~/.zshrc
# Modern ZSH Configuration
# -------------------------------------------------------------------

# --- Environment & Language ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# --- History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space

# --- ZSH Options ---
setopt autocd              # Allow changing directories without `cd`
setopt interactivecomments # Allow comments in interactive shell

# --- Core Navigation & Standard Aliases ---
alias zshrcconfig='code ~/.zshrc'
alias loadz='source ~/.zshrc'
alias loadb='source ~/.bashrc'

alias dev='cd ~/Documents/dev'
alias dotfiles='cd ~/Documents/dev/repos/dotfiles'
alias wrk='cd /workspaces'

alias update='sudo apt-get update && sudo apt-get upgrade'

# Python & Virtualenvwrapper
alias python='python3'
alias pip='pip3'
alias mkv='mkvirtualenv'
alias lsv='lsvirtualenv'
alias lsvb='lsvirtualenv -b'
alias rmv='rmvirtualenv'
alias cpv='cpvirtualenv'
alias dve='deactivate'
alias wkv='workon'

# --- Modern CLI Tool Replacements & Aliases ---

# eza (Modern ls replacement with icons & git status)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --level=2 --icons'
elif [[ "$OSTYPE" == darwin* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

# bat (Syntax-highlighted cat)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
elif command -v batcat &> /dev/null; then
    alias cat='batcat --paging=never'
    alias bat='batcat'
fi

# zoxide (Smarter cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf (Fuzzy Finder integration)
if command -v fzf &> /dev/null; then
    source <(fzf --zsh 2>/dev/null) || true
fi

# --- AI Workspace Bridge ---
export AI_HOME="${AI_HOME:-$HOME/Documents/dev/repos/ai}"
if [ -d "$AI_HOME" ]; then
    alias ai-repo='cd "$AI_HOME"'
    alias skills='cd "$AI_HOME/skills"'
    alias prompts='cd "$AI_HOME/prompts"'
    if [ -d "$AI_HOME/bin" ]; then
        export PATH="$AI_HOME/bin:$PATH"
    fi
fi

# --- Paths & Tools Integration ---

# Antigravity CLI & IDE
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
[ -d "$HOME/.antigravity-ide/antigravity-ide/bin" ] && export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# LM Studio CLI (lms)
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Angular CLI autocompletion
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

# Virtualenvwrapper setup
if command -v python3 &> /dev/null; then
    export VIRTUALENVWRAPPER_PYTHON=$(/usr/bin/env python3 -c "import sys; print(sys.executable)" 2>/dev/null || command -v python3)
    export WORKON_HOME=$HOME/.virtualenvs
    if [ -n "$CODESPACES" ] || [ -n "$DEVCONTAINER" ]; then
        export PROJECT_HOME=/workspaces
    else
        export PROJECT_HOME=$HOME/Documents/dev
    fi
    if command -v virtualenvwrapper.sh &>/dev/null; then
        source "$(command -v virtualenvwrapper.sh)"
    elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        source /usr/local/bin/virtualenvwrapper.sh
    fi
fi

# --- Starship Prompt ---
# Must be initialized at the end of shell setup
export STARSHIP_CONFIG=~/.config/starship/starship.toml
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# --- Machine-Specific / Local Overrides (Ignored by Git) ---
# Use ~/.zshrc.local for corporate tokens, Artifactory tokens, work proxies, or personal API keys
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
