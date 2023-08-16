#!/bin/zsh
#
# ~/.zshrc
# Zsh startup file for interactive shells

## Brew environment {{{1
# XXX: Manual says that put this line to zprofile
[[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

## PLUGINS {{{1
# NOTE: Should I consider environments without git...?
# NOTE: Consider using array...
PREFIX="$HOME/.local"

# Make local tmp folder
! [[ -d "$PREFIX/tmp" ]] && mkdir -p "$PREFIX/tmp"
# Make local share folder
! [[ -d "$PREFIX/share" ]] && mkdir -p "$PREFIX/share"

## git-prompt {{{2
## https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
NAME="git-prompt"

# Install
URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

if [[ ! -f "$PREFIX/share/$NAME.sh" ]]; then
  echo -n "Install $NAME...";
  curl \
    -H "Accept: application/vnd.github.v3+json" \
    "$URL" -s -o "$PREFIX/share/$NAME.sh" &&
    echo "done" ||
    echo "failed"
fi
unset URL

# Activate
[[ ! -f "$PREFIX/share/$NAME" ]] && \
  source "$PREFIX/share/$NAME.sh"
unset NAME

## Zsh-completions {{{2
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

## Zsh-autosuggestions {{{2
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

## Zsh-syntax-highlighting {{{2
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
## Zsh-z {{{2
NAME="zsh-z"

# Install
if [[ ! -f "$PREFIX/share/$NAME/$NAME.plugin.zsh" ]]; then
  echo -n "Install $NAME...";
  (git clone --quiet --depth=1 \
    https://github.com/agkozak/$NAME.git \
    "$PREFIX/share/$NAME") &&
    echo "done" ||
    echo "failed"
fi

# Activate
if [[ -f "$PREFIX/share/$NAME/$NAME.plugin.zsh" ]]; then
  source "$PREFIX/share/$NAME/$NAME.plugin.zsh"
fi

# }}}

unset NAME
unset PREFIX
# }}}
## Source the global zsh startup file {{{1
# XXX: It causes double sourcing...
# [[ -f "/etc/zshrc" ]] && source "/etc/zshrc";
## Source the shell-independent startup file {{{1
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# }}}

## Zsh-dependent startup configurations
# Set large history size {{{1
HISTFILE=~/.histfile;
HISTSIZE=1000;
SAVEHIST=1000;
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
unsetopt beep;

# vi-mode {{{1
bindkey -v;

# https://github.com/spaceship-prompt/spaceship-prompt/issues/91
bindkey "^?" backward-delete-char;
export KEYTIMEOUT=1;

# Export editors {{{1
export VISUAL='vim';
export EDITOR='vim -E';
export PAGER='less';

# Zsh aliases {{{1
alias path='printf "${PATH:gs/:/\\n}\\n"'

# }}}

## Source zsh-dependent external configurations {{{1
for file in "$HOME/.zsh_prompt"; do
  [[ -f "$file" ]] && source "$file";
done
unset file;
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}

# vim:ft=zsh:ts=2:sts=2:sw=2:et:sta:fdm=marker
