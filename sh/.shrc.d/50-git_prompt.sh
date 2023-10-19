#!/usr/bin/env sh
#
# ~/.shrc.d/git_prompt.sh
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

__install_git_prompt() {
  __dependencies="git"
  for command in ${__dependencies}; do
    if ! command -v -- ${command} > /dev/null 2>&1; then
      echo ${command} not exists!
      unset __dependencies
      return 255
    fi
  done

  __target=$1
  __url="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

  mkdir -p "$(dirname "${__target}")"
  curl -H "Accept: application/vnd.github.v3+json" \
    "${__url}" -s -o "${__target}"

  unset __target
  unset __url
  return $?
}

__main() {
  __prefix="${HOME}/.local"
  __target="${__prefix}/share/git-prompt"

  if [ -f "${__target}" ]; then
    # shellcheck source=/dev/null
    . "${__target}"

    # GIT_PS1 environment variables
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM="auto"
    # export GIT_PS1_STATESEPARATOR
    # export GIT_PS1_COMPRESSSPARSESTATE
    # export GIT_PS1_OMITSPARSESTATE
    # export GIT_PS1_DESCRIBE_STYLE
    export GIT_PS1_SHOWCOLORHINTS=1
  else
    echo "Install git-prompt at ${__target}..."
    if __install_git_prompt "${__target}"; then
      echo "done"
    else
      echo "failed"
    fi
  fi
  unset __target
  unset __prefix
}
__main
unset -f __main
unset -f __install_git_prompt
