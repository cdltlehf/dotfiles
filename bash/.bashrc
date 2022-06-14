#!/usr/bin/env bash
# shellcheck disable=SC1090
#
# ~/.bashrc
# Bash startup file for interactive non-login shells
# Since $HOME/.bash_profile sources this file,
# it sourced for interactive login shells too

## PLUGINS {{{1
PREFIX="${HOME}/.local"

# Make local tmp folder
! [[ -d "${PREFIX}/tmp" ]] && mkdir -p "${PREFIX}/tmp"
# Make local share folder
! [[ -d "${PREFIX}/share" ]] && mkdir -p "${PREFIX}/share"

## git-prompt {{{2
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
[[ ! -f "${PREFIX}/share/${NAME}" ]] && \
  source "{$PREFIX}/share/${NAME}.sh"
unset NAME

## bash-completion {{{2
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
[[ ${PS1} && -f "${PREFIX}/share/${NAME}" ]] && \
  . "${PREFIX}/share/${NAME}"
unset NAME

# }}}

unset PREFIX
# }}}

# Source the global bash startup file {{{1
# shellcheck disable=SC1091
[[ -f "/etc/bashrc" ]] && source "/etc/bashrc";

# Source the shell-independent startup file {{{1
# shellcheck disable=SC1091
[[ -f "${HOME}/.shrc" ]] && source "${HOME}/.shrc";

#}}}

## Bash-dependent startup configurations
alias path='printf \"${PATH//:/\\n}\\n\"'

## Source bash-dependent external configurations {{{1
# shellcheck disable=SC2043
for file in "${HOME}"/.bash_prompt; do
  [[ -f "${file}" ]] && source "${file}";
done
unset file;

# }}}

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta:fdm=marker
