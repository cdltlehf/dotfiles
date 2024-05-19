#!/bin/zsh
#
# ~/.zshrc
# Zsh startup file for interactive shells

# Source the global zsh startup file
# XXX: It causes double sourcing...
# [[ -f "/etc/zshrc" ]] && source "/etc/zshrc";

# Source the shell-independent startup file
[[ -f "$HOME/.shrc" ]] && source "$HOME/.shrc";

# Source files in .zshrc.d
for file in "$HOME"/.zshrc.d/*.zsh; do
  source "$file";
done

# Brew environment
# XXX: Manual says that put this line to zprofile
[[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

# https://github.com/junegunn/fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] \
  && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

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
