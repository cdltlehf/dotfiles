#!/usr/bin/env sh
#
# ~/.shrc.d/nvm.sh
# https://github.com/nvm-sh/nvm

__install_nvm() {
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

  export NVM_DIR="$__target" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `
      git describe --abbrev=0 --tags --match \
        "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) && \. "$NVM_DIR/nvm.sh"
  return $?
}

__main() {
  __prefix="${HOME}/.local"
  __target="${__prefix}/share/nvm"

  if [ -d "${__target}" ]; then
    export NVM_DIR="${__target}"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  else
    echo "Install nvm at ${__target}..."
    if __install_nvm "${__target}"; then
      echo "done"
      export NVM_DIR="${__target}"
      # shellcheck source=/dev/null
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
      # shellcheck source=/dev/null
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    else
      echo "failed"
    fi
  fi
  unset __target
  unset __prefix
}
__main
unset -f __main
unset -f __install_nvm
