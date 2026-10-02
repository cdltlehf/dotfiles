#!/bin/sh

set -o nounset
set -o errexit

: "${__DOTFILES_UPGRADE:?Do not run directly}"

softwareupdate --list 2>/dev/null || true
