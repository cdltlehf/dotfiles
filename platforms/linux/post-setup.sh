#!/bin/sh
#
# Reference: https://mise.jdx.dev/configuration.html

set -o nounset
set -o errexit

: "${__DOTFILES_SETUP:?Do not run directly}"
: "${XDG_CONFIG_HOME:?Do not run directly}"
: "${BASE_DIR:?Do not run directly}"

readonly MISE_CONF_DIR="${XDG_CONFIG_HOME}/mise/conf.d"
readonly LINUX_MISE_CONFIG="${BASE_DIR}/platforms/linux/mise.toml"

if [ -f "${LINUX_MISE_CONFIG}" ]; then
  mkdir -p "${MISE_CONF_DIR}"
  symlink "${LINUX_MISE_CONFIG}" "${MISE_CONF_DIR}/linux.toml"
  # shellcheck disable=SC2310
  if has mise; then
    mise install --yes || true
  fi
fi
