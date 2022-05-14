#!/usr/bin/env zsh
## $HOME/.zshrc
## Zsh startup file for interactive shells

## Source the shell-independent startup file
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

# vim:ft=zsh:ts=2:sts=2:sw=2:et:sta
