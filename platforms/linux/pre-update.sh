#!/bin/sh
#
# Reference: https://mise.jdx.dev/cli/plugins/update.html

set -o nounset
set -o errexit

: "${__DOTFILES_UPDATE:?Do not run directly}"

# shellcheck disable=SC2310
if has mise; then
  mise plugins update || true
fi
