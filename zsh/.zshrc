#!/usr/bin/env zsh
## $HOME/.zshrc
## Zsh startup file for interactive shells

# brew environment
# XXX: Manual says that put this line to zprofile
[[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

# Source the shell-independent startup file
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Set large history size
HISTFILE=~/.histfile;
HISTSIZE=1000;
SAVEHIST=1000;
unsetopt beep;

# vi-mode
bindkey -v;
# https://github.com/spaceship-prompt/spaceship-prompt/issues/91
bindkey "^?" backward-delete-char;
export KEYTIMEOUT=1;

# Export editors
export VISUAL='vim';
export EDITOR='vim -E';
export PAGER='less';

# Source zsh-dependent external configurations
for file in "$HOME/.zsh_prompt"; do
  [[ -f "$file" ]] && source "$file";
done
unset file;

## PLUGINS
# NOTE: Should I consider environments without git...?
# NOTE: Consider using array...
PREFIX="$HOME/.local"

# Make local tmp folder
! [[ -d "$PREFIX/tmp" ]] && mkdir -p "$PREFIX/tmp"
# Make local share folder
! [[ -d "$PREFIX/share" ]] && mkdir -p "$PREFIX/share"

## zsh-completions
NAME="zsh-completions"

# Install
if [[ ! -d "$PREFIX/share/$NAME/src" ]]; then
  echo -n "Install $NAME...";
  git clone --quiet --depth=1 \
    https://github.com/zsh-users/$NAME.git \
    "$PREFIX/share/$NAME" &&
    echo "done" ||
    echo "failed"
fi

# Activate
if [[ -d "$PREFIX/share/$NAME/src" ]]; then
  fpath=("$PREFIX/share/$NAME/src" $fpath)
  # XXX: Is it right?
  autoload compinit
  rm -f ~/.zcompdump; compinit
fi
unset NAME

## zsh-autosuggestions
NAME="zsh-autosuggestions"

# Install
if [[ ! -f "$PREFIX/share/$NAME/$NAME.zsh" ]]; then
  echo -n "Install $NAME...";
  git clone --quiet --depth=1 \
    https://github.com/zsh-users/$NAME.git \
    "$PREFIX/share/$NAME" && \
    echo "done" || \
    echo "failed"
fi

# Activate
if [[ -f "$PREFIX/share/$NAME/$NAME.zsh" ]]; then
  source "$PREFIX/share/$NAME/$NAME.zsh"
fi
unset NAME

## zsh-syntax-highlighting
NAME="zsh-syntax-highlighting"

# Install
if [[ ! -f "$PREFIX/share/$NAME/$NAME.zsh" ]]; then
  echo -n "Install $NAME...";
  (git clone --quiet --depth=1 \
    https://github.com/zsh-users/$NAME.git \
    "$PREFIX/tmp/$NAME" &&
    cd "$PREFIX/tmp/$NAME" &&
    make install PREFIX="$PREFIX" > /dev/null &&
    rm -rf "$PREFIX/tmp/$NAME") &&
    echo "done" ||
    echo "failed"
fi

# Activate
if [[ -f "$PREFIX/share/$NAME/$NAME.zsh" ]]; then
  source "$PREFIX/share/$NAME/$NAME.zsh"
fi
unset NAME

unset PREFIX

# vim:ft=zsh:ts=2:sts=2:sw=2:et:sta
