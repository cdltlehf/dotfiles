#!/bin/bash

: "${__DOTFILES_SETUP:?Do not run directly}"

readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

xcode-select --install 2>/dev/null || true
if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
  sudo softwareupdate --install-rosetta || true
fi

if ! command -v brew &>/dev/null; then
  bash -c "$(curl -fsSL "${HOMEBREW_INSTALL_URL}" || true)"
  eval "$(/opt/homebrew/bin/brew shellenv || true)"
fi

brew bundle --file "${BASE_DIR:-.}/platforms/darwin/Brewfile"
