#!/bin/bash

cat bashrc.additions >> ~/.bashrc

cp ./.gitmessage ~
cp ./.gitconfig ~

# powerline fonts for zsh agnoster theme
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-zsh & plugins
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
cp ./.zshrc ~

########################################################################################################################
#### set agnoster as theme, this came from https://gist.github.com/corentinbettiol/21a6d4e942a0ee58d51acb7996697a88
#### in vscode settings for devcontainer (not for User or Workspace), Search for terminal.integrated.fontFamily value, and set it to "Roboto Mono for Powerline" (or any of those: https://github.com/powerline/fonts#font-families font families).
# save current zshrc
mv ~/.zshrc ~/.zshrc.bak

sudo sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -t agnoster

# remove newly created zshrc
rm -f ~/.zshrc
# restore saved zshrc
mv ~/.zshrc.bak ~/.zshrc
# update theme
sed -i '/^ZSH_THEME/c\ZSH_THEME="agnoster"' ~/.zshrc