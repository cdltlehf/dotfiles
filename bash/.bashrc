#!/usr/bin/env bash
## $HOME/.bashrc
## Bash startup file for interactive non-login shells
## Since $HOME/.bash_profile sources this file,
## it sourced for interactive login shells

# Source the global bash startup file
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

## Source the shell-independent startup file
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Place bash-dependent startup configurations here.
##

# Source bash-dependent external configurations
for file in "$HOME/.bash_prompt"; do
  [[ -f "$file" ]] && source "$file";
done
unset file;

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
