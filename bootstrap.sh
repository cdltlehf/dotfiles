#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";
xcode-select --install

git pull origin main
git config --global user.email "28900401+cdltlehf@users.noreply.github.com"
git config --global user.name "Sicheol Sung"

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

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

