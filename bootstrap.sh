#!/bin/bash

# Treat unset variables and parameters as an error
set -u

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
    # Install command line developer tools
    xcode-select --install

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install dependencies from Brewfile
    brew bundle install --file="./Brewfile"

    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi;

if [[ command -v git > /dev/null ]]; then 
    git pull origin main
    git config --global user.email 'cdltlehf@naver.com'
    git config --golobal user.name 'sungsicheol'
else
    echo 'Warning: git not installed'
fi;

# TODO: Change to use Plug
# Install vim dracula
mkdir -p ~/.vim/pack/themes/start
if [[ ! -d "$HOME/.vim/pack/themes/start/dracula/" ]]; then
    git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula
fi;

# TODO: Seperate dotfiles
# Make symlinks
for file in $SCRIPTPATH/.*; do
    if [[ -f $file ]]; then
        if [[ $(basename $file) == ".gitmodules" ]]; then 
            continue 
        fi;
        ln -is "$SCRIPTPATH/$(basename $file)" "$HOME/$(basename $file)"
    fi;
done;

# Install tpm
if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then 
    if [[ command -v tmux > /dev/null ]] && [[ command -v git > /dev/null ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi;
fi;

