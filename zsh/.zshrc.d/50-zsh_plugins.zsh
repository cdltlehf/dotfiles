#!/usr/bin/env zsh
#
# ~/.zshrc.d/zsh_completion.sh

__install_zsh_plugin() {
  local dependencies="git"
  for command in ${dependencies}; do
    if ! command -v -- "${command}" > /dev/null 2>&1; then
      echo "${command}" not exists!
      return 255
    fi
  done
  local prefix="${HOME}/.local"
  local name=$1
  local url="https://github.com/zsh-users/${name}.git"

  git clone --quiet --depth=1 "${url}" "${prefix}/share/${name}"
  return $?
}

__main() {
  local prefix="${HOME}/.local"
  local plugins=()
  plugins+=("zsh-syntax-highlighting")
  plugins+=("zsh-autosuggestions")

  for name in ${plugins}; do
    local target="${prefix}/share/${name}/${name}.zsh"
    if [[ -f "${target}" ]]; then
      source "${target}"
    else
      echo -n "Install ${name}..."
      if __install_zsh_plugin "${name}"; then
        echo "done"
        source "${target}"
      else
        echo "failed"
      fi
    fi
  done
}

__main
unset -f __main
unset -f __install_zsh_plugin
