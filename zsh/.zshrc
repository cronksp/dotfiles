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

# --- Aliases ---
# Config/Reload
alias zshrcconfig='code ~/.zshrc'
alias loadz='source ~/.zshrc'
alias loadb='source ~/.bashrc'

# Navigation
alias dev='cd ~/Documents/dev'
alias dotfiles='cd ~/Documents/dev/repos/dotfiles'
alias wrk='cd /workspaces'

# Tools
alias ls='ls -G'
alias update='sudo apt-get update && sudo apt-get upgrade'

# Python
alias python='python3'
alias pip='pip3'

# Virtualenvwrapper
alias mkv='mkvirtualenv'
alias lsv='lsvirtualenv'
alias lsvb='lsvirtualenv -b'
alias rmv='rmvirtualenv'
alias cpv='cpvirtualenv'
alias dve='deactivate'
alias wkv='workon'

# --- Paths & Tools Integration ---

# Antigravity CLI & IDE
export PATH="/Users/shanecronk/.local/bin:$PATH"
export PATH="/Users/shanecronk/.antigravity/antigravity/bin:$PATH"
export PATH="/Users/shanecronk/.antigravity-ide/antigravity-ide/bin:$PATH"

# LM Studio CLI (lms)
export PATH="$PATH:/Users/shanecronk/.lmstudio/bin"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Angular CLI autocompletion
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

# Virtualenvwrapper setup
if ! [[ -x "$(command -v node)" ]]; then
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
fi

# --- Starship Prompt ---
# Must be initialized at the end
export STARSHIP_CONFIG=~/.config/starship/starship.toml
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
export AI_WORKFLOW_HOME="/Users/shanecronk/Documents/dev/repos/ai"
