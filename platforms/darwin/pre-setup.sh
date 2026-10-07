#!/bin/sh

set -o nounset
set -o errexit

: "${__DOTFILES_SETUP:?Do not run directly}"
: "${BASE_DIR:?Do not run directly}"
: "${ARCH:?Do not run directly}"

readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

if [ "${ARCH}" = "arm64" ] && ! arch -x86_64 /usr/bin/true 2>/dev/null; then
  sudo softwareupdate --install-rosetta || true
fi

_brew_prefix="${HOMEBREW_PREFIX:-}"
if [ -z "${_brew_prefix}" ]; then
  case "${ARCH}" in
    arm64)
      _brew_prefix="/opt/homebrew"
      ;;
    x86_64)
      _brew_prefix="/usr/local"
      ;;
    *)
      err "Warning: unsupported macOS architecture: ${ARCH}"
      ;;
  esac
fi

BREW_BIN="${_brew_prefix}/bin/brew"
unset _brew_prefix

if [ -x "${BREW_BIN}" ]; then
  __cached "${BREW_BIN}" shellenv
fi

xcode-select --install 2>/dev/null || true

if ! has brew; then
  download "${HOMEBREW_INSTALL_URL}" | /bin/bash
  if [ -n "${BREW_BIN:-}" ] && [ -x "${BREW_BIN}" ]; then
    __cached "${BREW_BIN}" shellenv
  fi
fi

brew bundle --file "${BASE_DIR}/platforms/darwin/Brewfile"

unset BREW_BIN
