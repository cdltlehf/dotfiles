#!/bin/bash

# Treat unset variables and parameters as an error
set -u

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
    # Install command line developer tools
    xcode-select --install
    sudo softwareupdate --install-rosetta

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # TODO: Is it valid?
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Install dependencies from Brewfile
    brew bundle install --file="./Brewfile"
    curl -L https://iterm2.com/shell_integration/zsh \
    -o ~/.iterm2_shell_integration.zsh

    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

fi;

# git setting
if command -v git > /dev/null; then 
    git config --global user.email 'cdltlehf@naver.com'
    git config --golobal user.name 'sungsicheol'

    # Pull dotfiles
    git pull origin main

    # Pull submodules
    # TODO: automate these settings
    if [[ "$OS" == "Darwin" ]]; then
        git submodule init
        git submodule update
    fi;
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
for file in ./.*; do
    if [[ -f $file ]]; then
        if [[ $(basename $file) == ".gitmodules" ]]; then 
            continue 
        fi;
    fi;
    ln -is "$(pwd)/$(basename $file)" "$HOME/$(basename $file)"
done;

# Install tpm
if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then 
    if command -v tmux > /dev/null && command -v git > /dev/null; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi;
fi;

