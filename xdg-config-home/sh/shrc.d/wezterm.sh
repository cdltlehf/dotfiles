# shellcheck shell=sh
# Reference: https://wezfurlong.org/wezterm/shell-integration.html

SHELL_INTEGRATION="${XDG_DATA_HOME:-${HOME}/.local/share}/wezterm/shell-integration/wezterm.sh"
# shellcheck source=/dev/null
[ -f "${SHELL_INTEGRATION}" ] && . "${SHELL_INTEGRATION}"
unset SHELL_INTEGRATION
