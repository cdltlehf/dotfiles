#!/usr/bin/env zsh

# history {{{1
HISTFILE=~/.histfile;
HISTSIZE=1000;
SAVEHIST=1000;
unsetopt beep;
# }}}

# vi-mode {{{1
bindkey -v;
# https://github.com/spaceship-prompt/spaceship-prompt/issues/91
bindkey "^?" backward-delete-char;
export KEYTIMEOUT=1;
# }}}

# export editors {{{1
export VISUAL='vim';
export EDITOR='vim -E';
export PAGER='less';
# }}}

# vim:ts=2:sts=2:sw=2:et:sta:fdm=marker:fdl=0
