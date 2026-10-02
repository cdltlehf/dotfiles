#!/bin/sh

set -o nounset
set -o errexit

: "${__DOTFILES_SETUP:?Do not run directly}"
: "${BASE_DIR:?Do not run directly}"
: "${ARCH:?Do not run directly}"

readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

case "${ARCH}" in
  arm64)
    if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
      sudo softwareupdate --install-rosetta || true
    fi
    BREW_BIN="/opt/homebrew/bin/brew"
    ;;
  x86_64)
    BREW_BIN="/usr/local/bin/brew"
    ;;
  *)
    err "Warning: unsupported macOS architecture: ${ARCH}"
    ;;
esac

if [ -n "${BREW_BIN:-}" ] && [ -x "${BREW_BIN}" ]; then
  eval "$("${BREW_BIN}" shellenv || true)"
fi

xcode-select --install 2>/dev/null || true

if ! has brew; then
  download "${HOMEBREW_INSTALL_URL}" | /bin/bash
  if [ -n "${BREW_BIN:-}" ] && [ -x "${BREW_BIN}" ]; then
    eval "$("${BREW_BIN}" shellenv || true)"
  fi
fi

brew bundle --file "${BASE_DIR}/platforms/darwin/Brewfile"

unset BREW_BIN
