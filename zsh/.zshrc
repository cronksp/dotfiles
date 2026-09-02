# -------------------------------------------------------------------
# ~/.zshrc - Modern ZSH Configuration
# -------------------------------------------------------------------

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt autocd
setopt interactivecomments

# Ensure ~/.local/bin is on PATH
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dev/repos/dotfiles}"

# Source shared aliases and tool updates
[[ -r "$DOTFILES_DIR/bash/aliases.bash" ]] && source "$DOTFILES_DIR/bash/aliases.bash"
[[ -r "$DOTFILES_DIR/bash/tool-updates.bash" ]] && source "$DOTFILES_DIR/bash/tool-updates.bash"

# zoxide (Smarter cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf (Fuzzy Finder integration)
if command -v fzf &> /dev/null; then
    source <(fzf --zsh 2>/dev/null) || true
fi

# Starship prompt setup with seasonal theme compiler
if command -v starship-seasonal-theme >/dev/null 2>&1; then
  starship-seasonal-theme --ensure >/dev/null 2>&1 || true
  export STARSHIP_CONFIG="${XDG_STATE_HOME:-$HOME/.local/state}/starship/starship.toml"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Machine-specific / local overrides (ignored by Git)
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
