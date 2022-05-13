#!/usr/bin/env bash

# Source the global bash configuration
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

# Source the shell-independent configuration
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Source the local bash profile if the shell is interactive
[[ -n "$PS1" ]] && [[ -f "$HOME/.bash_profile" ]] && source "$HOME/.bash_profile";

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
