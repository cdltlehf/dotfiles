#!/usr/bin/env bash

SCRIPTPATH="$(cd -- "$(dirname $0)" ; pwd -P )"

if [[ "$OSTYPE" == "darwin"* ]]; then
    cd "$(dirname "${BASH_SOURCE}")";
    xcode-select --install

    # brew
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew update
    brew upgrade
    brew bundle
    brew cleanup

    # oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if ! fgrep -q "$(brew --prefix)/bin/zsh" /etc/shells; then
        echo "Run follow commands";
        echo "echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells";
        echo "chsh -s $(brew --prefix)/bin/zsh";
    else
        chsh -s "$(brew --prefix)/bin/zsh";
    fi;
fi;

# git pull origin main
# git config --global user.email "28900401+cdltlehf@users.noreply.github.com"
# git config --global user.name "Sicheol Sung"

# vim dracula
mkdir -p ~/.vim/pack/themes/start
if [[ ! -d "$HOME/.vim/pack/themes/start/dracula/" ]]; then
    git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula
fi;

for file in $SCRIPTPATH/.*; do
    if [[ -f $file ]]; then
        if [[ $(basename $file) == ".gitmodules" ]]; then 
        continue 
    fi;
        ln -is "$SCRIPTPATH/$(basename $file)" "$HOME/$(basename $file)"
        # echo "$SCRIPTPATH/$(basename $file)" 
        # echo "$HOME/$(basename $file)"
    fi;
done;

# tpm
if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then 
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi;

