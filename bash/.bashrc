#!/usr/bin/env bash
#
# ~/.bashrc
# Bash startup file for interactive non-login shells
# Since $HOME/.bash_profile sources this file,
# it will be sourced for interactive login shells too

# Source the global bash startup file
# shellcheck source=/dev/null
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

# Source the shell-independent startup file
# shellcheck source=/dev/null
[[ -f "${HOME}/.shrc" ]] && source "${HOME}/.shrc";

## Bash-dependent startup configurations
alias path='printf \"${PATH//:/\\n}\\n\"'
# shopt -s globstar

# shellcheck source=/dev/null
[[ -f "${HOME}/.bashrc.host" ]] && source "${HOME}/.bashrc.host"

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ -d "${HOME}/.bashrc.d" ]]; then
  for file in "${HOME}"/.bashrc.d/*.sh; do
    # shellcheck source=/dev/null
    source "${file}"
  done
fi

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta:fdm=marker
