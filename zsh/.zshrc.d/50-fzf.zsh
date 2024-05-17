#!/bin/zsh
# https://github.com/junegunn/fzf

# shellcheck source=/dev/null
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] \
  && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
