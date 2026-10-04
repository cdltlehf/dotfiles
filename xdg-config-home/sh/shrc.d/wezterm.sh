# shellcheck shell=sh
#
# Reference: https://wezfurlong.org/wezterm/shell-integration.html

_shell_integration="${XDG_DATA_HOME:-${HOME}/.local/share}/wezterm/shell-integration/wezterm.sh"
# shellcheck source=/dev/null
[ -f "${_shell_integration}" ] && . "${_shell_integration}"
unset _shell_integration
