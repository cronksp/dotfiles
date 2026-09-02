#!/usr/bin/env bash
#
# Dotfiles Installation & Provisioning Script
# Supports Arch Linux / Omarchy, macOS, Debian/Ubuntu, and DevContainers
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
SKIP_FONTS=false

# CLI arguments
for arg in "$@"; do
    case "$arg" in
        --no-fonts|--quick|-q)
            SKIP_FONTS=true
            ;;
    esac
done

# Detect container environments where host renders fonts
if [[ -n "${CODESPACES:-}" || -n "${DEVCONTAINER:-}" || -n "${REMOTE_CONTAINERS:-}" ]]; then
    SKIP_FONTS=true
fi

info() {
    printf "\r  [\033[00;34mINFO\033[0m] %s\n" "$1"
}

success() {
    printf "\r\033[2K  [\033[00;32m OK \033[0m] %s\n\n" "$1"
}

warn() {
    printf "\r\033[2K  [\033[00;33mWARN\033[0m] %s\n" "$1"
}

error() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
    exit 1
}

download_file() {
    local url="$1"
    local output="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output"
    else
        error "Neither curl nor wget is available for downloading $url"
    fi
}

detect_platform() {
    OS="$(uname -s)"
    DISTRO="unknown"

    case "$OS" in
        Linux)
            if [[ -f /etc/os-release ]]; then
                # shellcheck source=/dev/null
                source /etc/os-release
                DISTRO="${ID:-unknown}"
            fi
            ;;
        Darwin)
            DISTRO="macos"
            ;;
        *)
            DISTRO="unknown"
            ;;
    esac
}

install_packages() {
    info "Checking required packages for platform: $DISTRO ($OS)..."

    case "$DISTRO" in
        arch|omarchy|endeavouros|manjaro)
            info "Arch-based distribution detected."
            local pkgs=()
            command -v git >/dev/null 2>&1 || pkgs+=(git)
            command -v curl >/dev/null 2>&1 || pkgs+=(curl)
            command -v unzip >/dev/null 2>&1 || pkgs+=(unzip)
            command -v fzf >/dev/null 2>&1 || pkgs+=(fzf)
            command -v starship >/dev/null 2>&1 || pkgs+=(starship)

            if [[ ${#pkgs[@]} -gt 0 ]]; then
                info "Installing missing packages: ${pkgs[*]}"
                if [[ $EUID -eq 0 ]]; then
                    pacman -S --noconfirm --needed "${pkgs[@]}"
                elif command -v sudo >/dev/null 2>&1 && (sudo -n true 2>/dev/null || [[ -t 0 ]]); then
                    sudo pacman -S --noconfirm --needed "${pkgs[@]}"
                else
                    warn "Cannot elevate with sudo. Please install manually: pacman -S ${pkgs[*]}"
                fi
            else
                success "All required base packages are already installed"
            fi
            ;;
        macos)
            info "macOS detected."
            if ! command -v brew >/dev/null 2>&1; then
                warn "Homebrew not found. Please install Homebrew from https://brew.sh"
            else
                local brew_pkgs=()
                command -v git >/dev/null 2>&1 || brew_pkgs+=(git)
                command -v curl >/dev/null 2>&1 || brew_pkgs+=(curl)
                command -v unzip >/dev/null 2>&1 || brew_pkgs+=(unzip)
                command -v fzf >/dev/null 2>&1 || brew_pkgs+=(fzf)
                command -v starship >/dev/null 2>&1 || brew_pkgs+=(starship)

                if [[ ${#brew_pkgs[@]} -gt 0 ]]; then
                    info "Installing missing packages via brew: ${brew_pkgs[*]}"
                    brew install "${brew_pkgs[@]}"
                else
                    success "All required base packages are already installed"
                fi
            fi
            ;;
        ubuntu|debian|pop)
            info "Debian/Ubuntu-based distribution detected."
            local apt_pkgs=()
            command -v git >/dev/null 2>&1 || apt_pkgs+=(git)
            command -v curl >/dev/null 2>&1 || apt_pkgs+=(curl)
            command -v unzip >/dev/null 2>&1 || apt_pkgs+=(unzip)
            command -v fzf >/dev/null 2>&1 || apt_pkgs+=(fzf)

            if [[ ${#apt_pkgs[@]} -gt 0 ]]; then
                if [[ $EUID -eq 0 ]]; then
                    apt-get update -qq && apt-get install -y "${apt_pkgs[@]}"
                elif command -v sudo >/dev/null 2>&1 && (sudo -n true 2>/dev/null || [[ -t 0 ]]); then
                    sudo apt-get update -qq && sudo apt-get install -y "${apt_pkgs[@]}"
                fi
            fi

            if ! command -v starship >/dev/null 2>&1; then
                info "Installing Starship prompt via official installer script..."
                curl -fsSL https://starship.rs/install.sh | sh -s -- -y
            fi
            ;;
        *)
            warn "Unrecognized OS/distro ($DISTRO). Ensuring Starship is installed..."
            if ! command -v starship >/dev/null 2>&1; then
                curl -fsSL https://starship.rs/install.sh | sh -s -- -y
            fi
            ;;
    esac
}

install_fonts() {
    if [[ "$SKIP_FONTS" == true ]]; then
        info "Skipping local font download (container/quick mode active; host terminal renders fonts)."
        return 0
    fi

    info "Checking modern coding fonts..."

    local FONT_DIR
    if [[ "$OS" == "Darwin" ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
    fi

    # Check if JetBrainsMono and Monaspace or other nerd fonts are present
    if command -v fc-list >/dev/null 2>&1; then
        if fc-list : family | grep -iq "JetBrainsMono Nerd Font"; then
            success "Coding fonts are already installed"
            return 0
        fi
    fi

    local TEMP_DIR
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "${TEMP_DIR:-}"' EXIT

    cd "$TEMP_DIR"

    local NERD_FONT_VERSION="v3.2.1"
    local FONTS=("JetBrainsMono" "FiraCode" "ComicShannsMono")

    for font in "${FONTS[@]}"; do
        info "Downloading $font (Nerd Font $NERD_FONT_VERSION)..."
        if download_file "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${font}.zip" "${font}.zip"; then
            unzip -q -o "${font}.zip" -d "$font"
            find "$font" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$FONT_DIR/" \;
            success "$font installed"
        fi
    done

    # Monaspace
    info "Downloading Monaspace..."
    if download_file "https://github.com/githubnext/monaspace/releases/download/v1.101/monaspace-v1.101.zip" "monaspace.zip"; then
        unzip -q -o "monaspace.zip" -d "monaspace"
        find monaspace -type f \( -name "*.otf" -o -name "*.ttf" \) -exec cp {} "$FONT_DIR/" \;
        success "Monaspace installed"
    fi

    if [[ "$OS" == "Linux" ]]; then
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -fv >/dev/null 2>&1 || true
        fi
    fi

    cd "$DOTFILES_DIR"
    rm -rf "$TEMP_DIR"
    trap - EXIT
    success "Modern coding fonts verified and installed"
}

backup_and_link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        success "Already linked: $dst -> $src"
        return 0
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        local backup="${dst}.backup.${TIMESTAMP}"
        warn "Existing file found at $dst. Backing up to $backup"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    success "Linked: $dst -> $src"
}

setup_directories() {
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/state/starship"
    mkdir -p "$HOME/.config/starship"
}

link_dotfiles() {
    info "Linking dotfiles and binaries..."

    # Theme CLI
    chmod +x "$DOTFILES_DIR/bin/starship-seasonal-theme"
    backup_and_link "$DOTFILES_DIR/bin/starship-seasonal-theme" "$HOME/.local/bin/starship-seasonal-theme"

    # Starship config template
    backup_and_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"

    # Ghostty config (if ghostty is installed or config directory exists)
    if [[ "$OS" == "Darwin" ]] || [[ -d "$HOME/.config/ghostty" ]]; then
        if [[ -f "$DOTFILES_DIR/ghostty/config" ]]; then
            backup_and_link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
        fi
    fi

    # Shell configs
    backup_and_link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    backup_and_link "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
    backup_and_link "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"

    # AI Workspace Bridge
    local AI_REPO="${AI_HOME:-$HOME/dev/repos/ai}"
    if [[ -d "$AI_REPO" && -f "$AI_REPO/rules.md" ]]; then
        info "Linking AI workspace rules to home directory..."
        backup_and_link "$AI_REPO/rules.md" "$HOME/.cursorrules"
        backup_and_link "$AI_REPO/rules.md" "$HOME/.windsurfrules"
    fi
}

initialize_theme() {
    info "Initializing seasonal Starship theme..."
    if [[ -x "$HOME/.local/bin/starship-seasonal-theme" ]]; then
        "$HOME/.local/bin/starship-seasonal-theme" --ensure
        local current_theme
        current_theme="$("$HOME/.local/bin/starship-seasonal-theme" current)"
        success "Starship initialized with active theme: $current_theme"
    else
        warn "starship-seasonal-theme binary not executable yet."
    fi
}

main() {
    printf "============================================\n"
    printf "      Dotfiles Provisioning & Install       \n"
    printf "============================================\n\n"

    detect_platform
    install_packages
    install_fonts
    setup_directories
    link_dotfiles
    initialize_theme

    success "Dotfiles installation complete! 🚀"
    info "Restart your terminal or run: source ~/.bashrc (or source ~/.zshrc)"
}

main "$@"
