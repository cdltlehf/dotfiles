#!/usr/bin/env bash
#
# ~/.bashrc.d/bash_completion.sh
# https://github.com/scop/bash-completion

__install_bash_completion() {
  local dependencies="git make autoreconf"
  for command in ${dependencies}; do
    if ! command -v -- "${command}" > /dev/null 2>&1; then
      echo "${command}" not exists!
      return 255
    fi
  done

  local target=$1
  local prefix="${HOME}/.local"
  local url="https://github.com/scop/bash-completion.git"

  local tempd
  tempd=$(mktemp -d)

  (
  cd "${tempd}" || return 255
  git clone --depth=1 "${url}" "bash-completion" \
    && cd "bash-completion" \
    && autoreconf -i \
    && ./configure --prefix="${prefix}" \
    && make \
    && make install
  )
  local exitcode=$?

  rm -rf "${tempd}/bash-completion"
  rmdir "${tempd}"
  return ${exitcode}
}

__main() {
  local prefix="${HOME}/.local"
  local target="${prefix}/share/bash-completion/bash_completion"
  if [[ -n "${PS1}" && -f ${target} ]]; then
    # shellcheck source=/dev/null
    . "${target}"
  else
    echo -n "Install bash-completion at ${target}"
    if __install_bash_completion "${target}"; then
      echo "done"
      # shellcheck source=/dev/null
      . "${target}"
    else
      echo "failed"
    fi
  fi
}

__main
unset -f __main
unset -f __install_bash_completion
