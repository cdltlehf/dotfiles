#!/usr/bin/env bash
#
# ~/.bashrc
# Bash startup file for interactive non-login shells
# Since $HOME/.bash_profile sources this file,
# it sourced for interactive login shells too

for file in ${HOME}/.bashrc.d; do
  # shellcheck source=/dev/null
  source "${file}"
done

# TODO: Move plugin scripts to bashrc.d
## PLUGINS
PREFIX="${HOME}/.local"

# Make local tmp folder
! [[ -d "${PREFIX}/tmp" ]] && mkdir -p "${PREFIX}/tmp"
# Make local share folder
! [[ -d "${PREFIX}/share" ]] && mkdir -p "${PREFIX}/share"

## git-prompt
## https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
NAME="git-prompt"

# Install
URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

if [[ ! -f "${PREFIX}/share/${NAME}.sh" ]]; then
  echo -n "Install ${NAME}...";
  curl \
    -H "Accept: application/vnd.github.v3+json" \
    "${URL}" -s -o "${PREFIX}/share/${NAME}.sh" &&
    echo "done" ||
    echo "failed"
fi
unset URL

# Activate
# shellcheck source=/dev/null
[[ -f "${PREFIX}/share/${NAME}.sh" ]] && \
  source "${PREFIX}/share/${NAME}.sh"
unset NAME

## bash-completion
## https://github.com/scop/bash-completion
NAME="bash-completion"

# Install
# FIXME: It needs autoreconf to build
if false; then
  # if [[ ! -f "${PREFIX}/share/${NAME}" ]]; then
  echo -n "Install ${NAME}...";
  # (git clone --quiet --depth=1 \
    (git clone --depth=1 \
    https://github.com/scop/${NAME}.git \
    "${PREFIX}/tmp/${NAME}" &&
    cd "${PREFIX}/tmp/${NAME}" &&
    autoreconf
  make install prefix="${PREFIX}" &&
    rm -rf "${PREFIX}/tmp/${NAME}") &&
    echo "done" ||
    echo "failed"
fi

# Activate
# shellcheck source=/dev/null
[[ ${PS1} && -f "${PREFIX}/share/${NAME}" ]] && \
  . "${PREFIX}/share/${NAME}"
unset NAME

unset PREFIX

# Source the global bash startup file
# shellcheck source=/etc/bashrc
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

# Source the shell-independent startup file
# shellcheck source=/dev/null
[[ -f "${HOME}/.shrc" ]] && source "${HOME}/.shrc";

## Bash-dependent startup configurations
alias path='printf \"${PATH//:/\\n}\\n\"'
shopt -s globstar

# shellcheck source=/dev/null
[[ -f "${HOME}/.bash_prompt" ]] && source "${HOME}/.bash_prompt"

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta:fdm=marker
