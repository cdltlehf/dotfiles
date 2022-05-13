#!/usr/bin/env bash

# Source bash-dependent dotfiles
for file in "$HOME/.bash_prompt"; do
  [[ -f "$file" ]] && source "$file";
done
unset file;

# Source profile
[[ -f "$HOME/.profile" ]] && source "$HOME/.profile";

# vim:ft=bash:ts=2:sts=2:sw=2:et:sta
