#!/usr/bin/env bash

if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
    exit
fi

cd "$(dirname "${BASH_SOURCE}")";
xcode-select --install

git pull origin main
git config --global user.email "cdltlehf@naver.com"
git config --golobal user.name "sungsicheol"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew upgrade
brew bundle
brew cleanup

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if ! fgrep -q "$(brew --prefix)/bin/zsh" /etc/shells; then
  echo "Run follow commands";
  echo "echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells";
  echo "chsh -s $(brew --prefix)/bin/zsh";
else
  chsh -s "$(brew --prefix)/bin/zsh";
fi;

