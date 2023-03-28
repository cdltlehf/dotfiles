#!/bin/bash
#
# ~/.bash_profile
# Bash startup file for login shells

# Source the shell-independent startup file for login shells
# shellcheck source=/dev/null
[[ -f "${HOME}/.profile" ]] && source "${HOME}/.profile";

# Source the bash startup file for non-login shells
# shellcheck source=/dev/null
[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc";

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
