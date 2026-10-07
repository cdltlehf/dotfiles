#!/bin/sh
#
# Reference: https://mise.jdx.dev/cli/upgrade.html

set -o nounset
set -o errexit

: "${__DOTFILES_UPGRADE:?Do not run directly}"

# shellcheck disable=SC2310
if has mise; then
  mise upgrade --bump || true
fi
