#!/bin/sh
#
# Reference: https://mise.jdx.dev/cli/upgrade.html

set -o nounset
set -o errexit

: "${__DOTFILES_UPGRADE:?Do not run directly}"

if command -v mise >/dev/null; then
  mise upgrade --bump || true
fi
