#!/usr/bin/env bash
## $HOME/.bashrc
## Bash startup file for interactive non-login shells
## Since $HOME/.bash_profile sources this file,
## it sourced for interactive login shells

# Source the global bash startup file
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

# Source the shell-independent startup file
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Place bash-dependent startup configurations here.
##

# Source bash-dependent external configurations
for file in "$HOME/.bash_prompt"; do
  [[ -f "$file" ]] && source "$file";
done
unset file;

## PLUGINS
PREFIX="$HOME/.local"

# Make local tmp folder
! [[ -d "$PREFIX/tmp" ]] && mkdir -p "$PREFIX/tmp"
# Make local share folder
! [[ -d "$PREFIX/share" ]] && mkdir -p "$PREFIX/share"

## bash-completion
## https://github.com/scop/bash-completion
NAME="bash-completion"

# Install
# FIXME
# if [[ ! -f "$PREFIX/share/$NAME" ]]; then
if [[ ! true ]]; then
  echo -n "Install $NAME...";
  # (git clone --quiet --depth=1 \
  (git clone --depth=1 \
    https://github.com/scop/$NAME.git \
    "$PREFIX/tmp/$NAME" &&
    cd "$PREFIX/tmp/$NAME" &&
    autoreconf
    make install prefix="$PREFIX" &&
    rm -rf "$PREFIX/tmp/$NAME") &&
    echo "done" ||
    echo "failed"
fi

# Activate
[[ $PS1 && -f "$PREFIX/share/$NAME" ]] && \
  . "$PREFIX/share/$NAME"

unset NAME

unset PREFIX

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
