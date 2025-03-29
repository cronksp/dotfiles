#!/bin/bash
### This script is based on the following:https://github.com/ThorstenHans/dotfiles/blob/master/install.sh ###
# This script installs the dotfiles in this repository via symlinks
# It also installs oh-my-zsh and some plugins, powerline fonts, and Nerd Fonts

# Exit immediately if a command exits with a non-zero status.
set -e

# capture working directory
working_dir=$(pwd)
dependencies=(curl zsh git unzip)
os_type=$(uname)



# prints an info to the screen
info() {
    printf "\r  [\033[00;34mINFO\033[0m] $1\n"
}

# prints a success-message to the screen
success() {
    printf "\r\033[2K  [\033[00;32m OK \033[0m] $1\n"
    echo ""
}

# prints an error-message to the screen and exits the app
error(){
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    exit
}

# changes the default shell to ZSH
change_shell() {
    info "Changing Shell to ZSH"
    chsh -s $(which zsh)
    success "Shell set to ZSH"
}

# creates a backup-copy of a file
backup_file() {
    if test -f $1; then
        info "Creating backup for existing $1"
        mv $1 $1.backup
        success "Backup created for $1 at $1.backup"
    fi
}

# verifies that Homebrew is installed on the Mac
verify_homebrew(){
    if  ! command -v brew &> /dev/null ; then
        error "Homebrew not installed. Please install brew first"
        # todo: install brew at some point automatically
        exit 1 
    fi
}

# TODO - review this function
# verifies that dependencies are installed on the Mac
verify_mac_dependencies(){
    for lib in "${dependencies[@]}"
    do
        info "Installing $lib if not present"
        brew ls --versions $lib || brew install $lib
        success "$lib is installed"
    done
}

# TODO - review this function
# verifies that dependencies are installed on Linux
verify_linux_dependencies(){
    sudo apt update -q > /dev/null
    for lib in "${dependencies[@]}"
    do
        info "Installing $lib if not present"
        sudo apt install $lib -q --yes > /dev/null
        success "$lib is installed"
    done
}

# verifies environment and installs dependencies (os specific)
verify_runtime(){
    #os_type=$(uname)
    case "$os_type" in 
        "Darwin")
        {
            info "Running on MacOS - Verifying Dependencies"
            sleep 2
            verify_homebrew
            verify_mac_dependencies
            install_fonts
            # TODO - review os specific installs
            install_terminal_tools
            os_specific_installs_macOS
        } ;;
        "Linux" )
        {
            info "Running on Linux - Verifying Dependencies"
            sleep 2
            verify_linux_dependencies
            install_fonts
            # TODO - review os specific installs
            install_terminal_tools
            os_specific_installs_linux
        };;
        *)
        {
            error "Unsupported OS"
            #TODO add support for other OS (windows, etc.)
        };;
    esac
}

# installs fonts
install_fonts(){
    info "Installing fonts"
    grab_powerline_fonts
    # get_nerd_fonts based on OS
    #os_type=$(uname)  # this might not be needed here, its already set in verify_runtime
    case "$os_type" in 
        "Darwin")
        {
            info "Running on MacOS"
            grab_nerd_fonts_on_macOS
        } ;;
        "Linux" )
        {
            info "Running on Linux"
            grab_nerd_fonts
        };;
        *)
        {
            error "Unsupported OS"
            #TODO add support for other OS (windows, etc.)
        };;
    esac
}

# installs dependencies on macOS
os_specific_installs_macOS(){
    info "Installing OS specific tools on MacOS"
}

# installs dependencies on Linux
os_specific_installs_linux(){
    info "Installing OS specific tools on Linux"
}

# installs terminal tools
install_terminal_tools(){
    info "Installing terminal tools"
    # install oh-my-zsh
    install_oh_my_zsh
    # install and link starship
    install_starship
    link_starship_config
}

# creates a file link
link_file(){
    info "Linking $2"
    ln -sf $1 $2
    success "$2 linked"
}

# creates a directory if it doesnt exist
verify_directory(){
    if test ! -d $1; then
        mkdir -p $1
        success "directory $1 created"
    fi
}

# grab powerline fonts
grab_powerline_fonts(){
    info "Grabbing powerline fonts"
    info "https://github.com/powerline/fonts.git"

    # powerline fonts for zsh agnoster theme
    info "creating tempFonts directory"
    cd ~ && verify_directory ~/tempFonts
    info "move to tempFonts directory"
    cd ~/tempFonts
    info "cloning powerline fonts"
    git clone https://github.com/powerline/fonts.git
    info "moving to fonts directory"
    cd fonts
    info "installing powerline fonts"
    ./install.sh
    info "moving back to tempFonts directory && removing fonts directory"
    cd .. && rm -rf fonts
    info "moving back to working directory && removing tempFonts directory"
    cd $working_dir && rm -rf ~/tempFonts
    success "Powerline fonts installed"
}

# TODO - find a common way to grab fonts on all platforms
# grab nerd fonts
grab_nerd_fonts(){
    info "Grabbing Nerd Fonts"
    info "https://github.com/ryanoasis/nerd-fonts"

    # nerd fonts
    info "creating tempNerdFonts directory"
    cd ~ && verify_directory ~/tempNerdFonts
    info "move to tempNerdFonts directory"
    cd ~/tempNerdFonts
    info "downloading Nerd Fonts"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
    info "unzipping Nerd Fonts"
    unzip Meslo.zip -d Meslo
    unzip FiraCode.zip -d FiraCode
    unzip RobotoMono.zip -d RobotoMono
    info "installing Nerd Fonts"
    cp Meslo/*.ttf ~/.local/share/fonts/
    cp FiraCode/*.ttf ~/.local/share/fonts/
    cp RobotoMono/*.ttf ~/.local/share/fonts/
    info "updating font cache"
    fc-cache -fv
    info "removing tempNerdFonts directory"
    cd $working_dir && rm -rf ~/tempNerdFonts
    success "Nerd Fonts installed"
}

# TODO - find a common way to grab fonts on all platforms
# grab nerd fonts on macOS (curl)
grab_nerd_fonts_on_macOS(){
    info "Grabbing Nerd Fonts"
    info "https://github.com/ryanoasis/nerd-fonts"

    # nerd fonts
    info "creating tempNerdFonts directory"
    cd ~ && verify_directory ~/tempNerdFonts
    info "move to tempNerdFonts directory"
    cd ~/tempNerdFonts
    info "downloading Nerd Fonts"
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
    info "unzipping Nerd Fonts"
    unzip Meslo.zip -d Meslo
    unzip FiraCode.zip -d FiraCode
    unzip RobotoMono.zip -d RobotoMono
    info "installing Nerd Fonts"
    cp Meslo/*.ttf ~/Library/Fonts/
    cp FiraCode/*.ttf ~/Library/Fonts/
    cp RobotoMono/*.ttf ~/Library/Fonts/
    info "removing tempNerdFonts directory"
    cd $working_dir && rm -rf ~/tempNerdFonts
    success "Nerd Fonts installed"
}

install_oh_my_zsh(){
    # oh-my-zsh & plugins
    info "Installing oh-my-zsh"

    # Check if the .oh-my-zsh directory exists
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info ".oh-my-zsh directory already exists"
        read -p "Do you want to remove the existing .oh-my-zsh directory? (y/n): " choice
        if [ "$choice" = "y" ]; then
            rm -rf "$HOME/.oh-my-zsh"
            info "Removed existing .oh-my-zsh directory"
        else
            error "Installation aborted. Please remove or rename the existing .oh-my-zsh directory and try again."
            return
        fi
    fi
    # TODO - verify oh-my-zsh installation includes oh-my-zsh.sh file
    #wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
    success "oh-my-zsh installed"

    info "Installing zsh-autosuggestions & zsh-syntax-highlighting"

    # Remove existing zsh-autosuggestions directory if it exists
    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        info "Removing existing zsh-autosuggestions directory"
        rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi
    zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'

    # Remove existing zsh-syntax-highlighting directory if it exists
    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        info "Removing existing zsh-syntax-highlighting directory"
        rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi
    zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

    success "zsh-autosuggestions & zsh-syntax-highlighting installed"
}

# cronksp - starship is a cross-shell prompt, cooler than oh-my-zsh
# installs Starship prompt
#install_starship() {
    #info "Installing Starship prompt"
    #curl --cacert /etc/ssl/certs/ca-certificates.crt -sSL
    #if curl --cacert /etc/ssl/certs/ca-certificates.crt -fsSL https://starship.rs/install.sh | sh -s -- -y; then
        #success "Starship prompt installed"
        # Verify Starship version
        #starship_version=$(starship --version)
        #info "Starship version: $starship_version"
    #else
        #error "Failed to install Starship prompt"
    #fi
#}

# TODO - ensure this works
install_starship() {
    info "Installing Starship prompt"

    case "$os_type" in
        "Darwin")
            # macOS
            if command -v brew &> /dev/null; then
                brew install starship
            else
                error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        "Linux")
            # Linux
            if command -v apt &> /dev/null; then
                # Debian/Ubuntu
                #sudo apt update -q && sudo apt install -y starship
                if curl --cacert /etc/ssl/certs/ca-certificates.crt -fsSL https://starship.rs/install.sh | sh -s -- -y; then
                    success "Starship prompt installed"
                    # Verify Starship version
                    starship_version=$(starship --version)
                    info "Starship version: $starship_version"
                else
                    error "Failed to install Starship prompt"
                fi
            elif command -v dnf &> /dev/null; then
                # Fedora
                sudo dnf install -y starship
            elif command -v pacman &> /dev/null; then
                # Arch Linux
                sudo pacman -S --noconfirm starship
            else
                # Fallback to curl if no package manager is detected
                curl -fsSL https://starship.rs/install.sh | sh -s -- -y
            fi
            ;;
        "MINGW"*|"CYGWIN"*|"MSYS"*)
            # Windows (via Scoop or Chocolatey)
            if command -v scoop &> /dev/null; then
                scoop install starship
            elif command -v choco &> /dev/null; then
                choco install starship
            else
                error "No supported package manager found on Windows. Please install Scoop or Chocolatey."
                return 1
            fi
            ;;
        *)
            # Unsupported OS
            error "Unsupported OS. Please install Starship manually from https://starship.rs."
            return 1
            ;;
    esac

    # Verify installation
    if command -v starship &> /dev/null; then
        starship_version=$(starship --version)
        success "Starship prompt installed successfully (version: $starship_version)"
    else
        error "Failed to install Starship prompt."
    fi
}

# creates a symlink for starship.toml
link_starship_config() {
    info "Linking starship.toml"
    STARSHIP_CONFIG_DIR="$HOME/.config/starship"
    STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"
    DOTFILES_DIR="$working_dir"

    # Create the target directory if it doesn't exist
    verify_directory "$STARSHIP_CONFIG_DIR"

    # Remove any existing symlink or file at the target location
    if [ -L "$STARSHIP_CONFIG_FILE" ] || [ -e "$STARSHIP_CONFIG_FILE" ]; then
        rm -f "$STARSHIP_CONFIG_FILE"
    fi

    # Create the symlink
    link_file "$DOTFILES_DIR/starship/.config/starship.toml" "$STARSHIP_CONFIG_FILE"
}

# verify runtime environment
verify_runtime

#install fonts
#grab_powerline_fonts
#grab_nerd_fonts

# oh-my-zsh & plugins
#install_oh_my_zsh

# starship prompt
#install_starship

# link starship.toml
#link_starship_config

#Set git config explicitly
git config --global user.name "Shane Cronk"
git config --global user.email "Shane.Cronk7@gmail.com"

#files=("$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.gitignore" "$HOME/.editorconfig" "$HOME/.editorconfig" "$HOME/.npmrc" "$HOME/.zshenv")
files=("$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile")

for f in "${files[@]}"
do
    info "Backing up $f"
    backup_file $f
    #BUG - this is not working as expected, only the first in the list is backed up
done

info "Linking dotfiles"

link_file "${working_dir}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${working_dir}/zsh/.zshenv" "${HOME}/.zshenv"
link_file "${working_dir}/zsh/.zprofile" "${HOME}/.zprofile"

#link_file "${working_dir}/git/config" "${HOME}/.gitconfig"
#link_file "${working_dir}/git/ignore" "${HOME}/.gitignore"
#link_file "${working_dir}/editorconfig/config" "${HOME}/.editorconfig"
#link_file "${working_dir}/npm/config" "${HOME}/.npmrc"
#verify_directory $HOME/.azure/
#link_file "${working_dir}/azure-cli/config" "${HOME}/.azure/config"
#verify_directory $HOME/.config/gh
#link_file "${working_dir}/github-cli/config" "${HOME}/.config/gh/config.yml"

success "All done! 🚀"

info "Either restart your terminal instance, or just invoke zsh"