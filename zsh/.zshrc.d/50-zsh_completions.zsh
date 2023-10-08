#!/usr/bin/env zsh
#
# ~/.zshrc.d/zsh_completions.zsh

__install_zsh_completions() {
  local dependencies="git"
  for command in ${dependencies}; do
    if ! command -v -- "${command}" > /dev/null 2>&1; then
      echo "${command}" not exists!
      return 255
    fi
  done
  local prefix="${HOME}/.local"
  local url="https://github.com/zsh-users/zsh-completions.git"

  git clone --quiet --depth=1 "${url}" "${prefix}/share/zsh-completions"
  return $?
}

__main() {
  autoload -Uz compinit
  local prefix="${HOME}/.local"
  local target="${prefix}/share/zsh-completions"

  if [[ -d "${target}" ]]; then
    fpath=(${target} $fpath)
  else
    echo -n "Install zsh-completions..."
    if __install_zsh_completions; then
      echo "done"
      rm -f ~/.zcompdump; compinit
      fpath=(${target} $fpath)
    else
      echo "failed"
    fi
  fi
}

__main
unset -f __main
unset -f __install_zsh_completions
