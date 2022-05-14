#!/usr/bin/env bash
## $HOME/.bash_profile
## Bash startup file for login shells

# Source the shell-independent startup file for login shells
[[ -f "$HOME/.profile" ]] && source "$HOME/.profile";

# Source the bash startup file for non-login shells
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc";

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
