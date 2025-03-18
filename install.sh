#!/bin/bash
### This script is based on the following:https://github.com/ThorstenHans/dotfiles/blob/master/install.sh ###
# This script installs the dotfiles in this repository via symlinks
# It also installs oh-my-zsh and some plugins, powerline fonts

# Exit immediately if a command exits with a non-zero status.
set -e

# capture working directory
working_dir=$(pwd)
dependencies=(curl zsh git)

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

# verifies that dependencies are installed on the Mac
verify_mac_dependencies(){
    for lib in "${dependencies[@]}"
    do
        info "Installing $lib if not present"
        brew ls --versions $lib || brew install $lib
        success "$lib is installed"
    done
}

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
    os_type=$(uname)
    case "$os_type" in 
        "Darwin")
        {
            info "Running on MacOS"
            verify_homebrew
            verify_mac_dependencies
        } ;;
        "Linux" )
        {
            info "Running on Linux"
            verify_linux_dependencies
        };;
        *)
        {
            error "Unsupported OS"
            #TODO add support for other OS (windows, etc.)
        };;
    esac
}

# creates a file link
link_file(){
    info "Linking $2"
    ln -sfv $1 $2 > /dev/null
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
grab_fonts(){
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

install_oh_my_zsh(){
    # oh-my-zsh & plugins
    info "Installing oh-my-zsh"
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
    success "oh-my-zsh installed"

    info "Installing zsh-autosuggestions & zsh-syntax-highlighting"
    zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
    success "zsh-autosuggestions & zsh-syntax-highlighting installed"

    }


# cronksp - starship is a cross-shell prompt, cooler than oh-my-zsh
# installs Starship prompt
install_starship() {
    info "Installing Starship prompt"
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
    success "Starship prompt installed"
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
grab_fonts

# oh-my-zsh & plugins
install_oh_my_zsh

# starship prompt
install_starship

# link starship.toml
link_starship_config

#files=("$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.gitignore" "$HOME/.editorconfig" "$HOME/.editorconfig" "$HOME/.npmrc" "$HOME/.zshenv")
files=("$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile")

for f in "${files[@]}"
do
	backup_file $f
    #BUG - this is not working as expected, only the first in the list is backed up
done

info "Linking dotfiles"

#link_file "${working_dir}/git/config" "${HOME}/.gitconfig"
#link_file "${working_dir}/git/ignore" "${HOME}/.gitignore"
link_file "${working_dir}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${working_dir}/zsh/.zshenv" "${HOME}/.zshenv"
link_file "${working_dir}/zsh/.zprofile" "${HOME}/.zprofile"
#link_file "${working_dir}/editorconfig/config" "${HOME}/.editorconfig"
#link_file "${working_dir}/npm/config" "${HOME}/.npmrc"
#verify_directory $HOME/.azure/
#link_file "${working_dir}/azure-cli/config" "${HOME}/.azure/config"
#verify_directory $HOME/.config/gh
#link_file "${working_dir}/github-cli/config" "${HOME}/.config/gh/config.yml"



success "All done! 🚀"

info "Either restart your terminal instance, or just invoke zsh"