#!/bin/zsh
#
# ~/.zshrc
# Zsh startup file for interactive shells

# Source the shell-independent startup file
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Source files in .zshrc.d
for file in "$HOME"/.zshrc.d/*.zsh; do
  source "$file";
done

# Brew environment
# XXX: Manual says that put this line to zprofile
[[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

# Zsh-dependent startup configurations
# Set large history size
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

# vi-mode
bindkey -v;

# https://github.com/spaceship-prompt/spaceship-prompt/issues/91
bindkey "^?" backward-delete-char;
export KEYTIMEOUT=1;

# Zsh aliases
alias path='printf "${PATH:gs/:/\\n}\\n"'
