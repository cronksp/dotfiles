# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else
[[ $- != *i* ]] && return

# Omarchy default aliases and functions (if on Omarchy)
[[ -n "${OMARCHY_PATH:-}" && -r "$OMARCHY_PATH/default/bash/rc" ]] && source "$OMARCHY_PATH/default/bash/rc"

# Ensure ~/.local/bin is on PATH
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Source dotfiles aliases and tools
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dev/repos/dotfiles}"
[[ -r "$DOTFILES_DIR/bash/aliases.bash" ]] && source "$DOTFILES_DIR/bash/aliases.bash"
[[ -r "$DOTFILES_DIR/bash/tool-updates.bash" ]] && source "$DOTFILES_DIR/bash/tool-updates.bash"

# zoxide (Smarter cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# fzf (Fuzzy Finder)
if command -v fzf &> /dev/null; then
    eval "$(fzf --bash 2>/dev/null || true)"
fi

# Starship prompt setup with seasonal theme compiler
if command -v starship-seasonal-theme >/dev/null 2>&1; then
  starship-seasonal-theme --ensure >/dev/null 2>&1 || true
  export STARSHIP_CONFIG="${XDG_STATE_HOME:-$HOME/.local/state}/starship/starship.toml"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Local machine-specific overrides (tokens, proxies, private secrets - ignored by git)
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
