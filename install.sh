#!/bin/bash
# Dotfiles installation script

# Exit immediately if a command exits with a non-zero status, unset variables are errors, and fail on pipe errors.
set -euo pipefail

# Capture absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPENDENCIES=(curl zsh git unzip wget fzf)
OS_TYPE="$(uname)"

# Helpers for output
info() {
    printf "\r  [\033[00;34mINFO\033[0m] %s\n" "$1"
}

success() {
    printf "\r\033[2K  [\033[00;32m OK \033[0m] %s\n\n" "$1"
}

error(){
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
    exit 1
}

# Change default shell to ZSH
change_shell() {
    info "Changing Shell to ZSH"
    local CURRENT_SHELL="${SHELL:-}"
    local ZSH_PATH
    ZSH_PATH="$(which zsh 2>/dev/null || true)"

    if [ -n "$ZSH_PATH" ] && [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        if chsh -s "$ZSH_PATH" 2>/dev/null; then
            success "Shell set to ZSH"
        else
            info "Note: Could not automatically change default shell. You can set it manually with: chsh -s $ZSH_PATH"
        fi
    else
        success "Shell is already ZSH"
    fi
}

# Create a backup of an existing file
backup_file() {
    if [ -f "$1" ] || [ -L "$1" ]; then
        info "Creating backup for existing $1"
        mv "$1" "${1}.backup"
        success "Backup created for $1 at ${1}.backup"
    fi
}

# Creates a file link
link_file() {
    local src="$1"
    local dest="$2"
    info "Linking $dest"
    ln -sf "$src" "$dest"
    success "$dest linked to $src"
}

# Creates a directory if it doesn't exist
verify_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        success "Directory $1 created"
    fi
}

# Verifies that Homebrew is installed on the Mac
verify_homebrew(){
    if ! command -v brew &> /dev/null ; then
        info "Homebrew not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Failed to install Homebrew"
        success "Homebrew installed"
    else
        success "Homebrew is installed"
    fi
}

# Verifies dependencies on macOS
verify_mac_dependencies(){
    for lib in "${DEPENDENCIES[@]}"; do
        info "Checking $lib"
        brew ls --versions "$lib" > /dev/null || brew install "$lib"
        success "$lib is installed"
    done
}

# Verifies dependencies on Linux
verify_linux_dependencies(){
    info "Updating apt packages"
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -q -y > /dev/null
    for lib in "${DEPENDENCIES[@]}"; do
        info "Checking $lib"
        if ! command -v "$lib" &> /dev/null ; then
            sudo DEBIAN_FRONTEND=noninteractive apt-get install "$lib" -q -y > /dev/null
        fi
        success "$lib is installed"
    done
}

install_fonts() {
    info "Installing modern coding fonts..."
    
    local FONT_DIR
    if [ "$OS_TYPE" = "Darwin" ]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
        verify_directory "$FONT_DIR"
    fi

    local TEMP_DIR
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "${TEMP_DIR:-}"' EXIT

    cd "$TEMP_DIR" || error "Failed to cd into temp directory"

    local NERD_FONT_VERSION="v3.2.1"
    local FONTS=("JetBrainsMono" "FiraCode" "ComicShannsMono")

    for font in "${FONTS[@]}"; do
        info "Downloading $font..."
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${font}.zip"
        unzip -q "${font}.zip" -d "$font"
        find "$font" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$FONT_DIR/" \;
        success "$font installed"
    done

    # Install Monaspace (Non-Nerd font, highly legible)
    info "Downloading Monaspace..."
    wget -q "https://github.com/githubnext/monaspace/releases/download/v1.101/monaspace-v1.101.zip"
    unzip -q "monaspace-v1.101.zip"
    find monaspace-v1.101 -type f \( -name "*.otf" -o -name "*.ttf" \) -exec cp {} "$FONT_DIR/" \;
    success "Monaspace installed"

    if [ "$OS_TYPE" = "Linux" ]; then
        if ! command -v fc-cache &> /dev/null; then
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fontconfig > /dev/null
        fi
        fc-cache -fv > /dev/null
    fi

    cd "$DOTFILES_DIR"
    rm -rf "$TEMP_DIR"
    trap - EXIT
    success "All fonts installed"
}

# Installs Starship prompt
install_starship() {
    info "Installing Starship prompt"
    if ! command -v starship &> /dev/null; then
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y > /dev/null
        success "Starship prompt installed"
    else
        success "Starship prompt is already installed"
    fi
}

# Creates a symlink for starship.toml
link_starship_config() {
    local STARSHIP_CONFIG_DIR="$HOME/.config/starship"
    local STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"

    verify_directory "$STARSHIP_CONFIG_DIR"
    backup_file "$STARSHIP_CONFIG_FILE"
    link_file "$DOTFILES_DIR/starship/.config/starship.toml" "$STARSHIP_CONFIG_FILE"
}

# Creates a symlink for ghostty/config if Ghostty config directory exists or on macOS
link_ghostty_config() {
    if [ "$OS_TYPE" = "Darwin" ] || [ -d "$HOME/.config/ghostty" ]; then
        local GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
        local GHOSTTY_CONFIG_FILE="$GHOSTTY_CONFIG_DIR/config"
        verify_directory "$GHOSTTY_CONFIG_DIR"
        backup_file "$GHOSTTY_CONFIG_FILE"
        link_file "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_CONFIG_FILE"
    fi
}

# Optional AI Workspace Bridge Linking
link_ai_rules() {
    local AI_REPO="${AI_HOME:-$HOME/Documents/dev/repos/ai}"
    if [ -d "$AI_REPO" ]; then
        info "AI workspace repository detected at $AI_REPO"
        if [ -f "$AI_REPO/rules.md" ]; then
            backup_file "$HOME/.cursorrules"
            link_file "$AI_REPO/rules.md" "$HOME/.cursorrules"
            backup_file "$HOME/.windsurfrules"
            link_file "$AI_REPO/rules.md" "$HOME/.windsurfrules"
        fi
    fi
}

# Verify runtime environment and dependencies
case "$OS_TYPE" in 
    "Darwin")
        info "Running on MacOS - Verifying Dependencies"
        verify_homebrew
        verify_mac_dependencies
        ;;
    "Linux" )
        info "Running on Linux - Verifying Dependencies"
        verify_linux_dependencies
        ;;
    *)
        error "Unsupported OS: $OS_TYPE"
        ;;
esac

# Execute installations
install_fonts
install_starship
link_starship_config
link_ghostty_config
link_ai_rules

# Link Dotfiles
info "Linking dotfiles"
FILES=("$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile")

for f in "${FILES[@]}"; do
    backup_file "$f"
done

link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/zsh/.zshenv" "${HOME}/.zshenv"
link_file "${DOTFILES_DIR}/zsh/.zprofile" "${HOME}/.zprofile"

# Ensure shell is set to zsh
change_shell

success "Dotfiles installation complete! 🚀"
info "Please restart your terminal."