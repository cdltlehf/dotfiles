#!/bin/bash
: "${__DOTFILES_SETUP:?Do not run directly}"

xcode-select --install 2>/dev/null || true
arch -x86_64 /usr/bin/true 2>/dev/null || sudo softwareupdate --install-rosetta || true

if ! command -v brew &>/dev/null; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle --file "${BASE_DIR}/Brewfile"
