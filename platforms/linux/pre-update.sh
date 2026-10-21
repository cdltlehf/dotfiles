#!/bin/sh
#
# Reference: https://mise.jdx.dev/cli/plugins/update.html

set -o nounset
set -o errexit

: "${__DOTFILES_UPDATE:?Do not run directly}"

if command -v mise >/dev/null; then
  mise plugins update || true
fi
