# shellcheck shell=sh

SHELL_INTEGRATION="${XDG_DATA_HOME:-$HOME/.local/share}/wezterm/shell-integration/wezterm.sh"
[ -f "${SHELL_INTEGRATION}" ] && . "${SHELL_INTEGRATION}"
unset SHELL_INTEGRATION
