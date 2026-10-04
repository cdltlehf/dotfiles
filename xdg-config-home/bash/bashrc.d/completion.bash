# Reference: https://github.com/scop/bash-completion

if [[ -z "${BASH_COMPLETION_VERSINFO:-}" ]]; then
  if [[ -n "${HOMEBREW_PREFIX:-}" && -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    # shellcheck source=/dev/null
    . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  elif [[ -r "/usr/share/bash-completion/bash_completion" ]]; then
    # shellcheck source=/dev/null
    . "/usr/share/bash-completion/bash_completion"
  fi
fi

if [[ -r "${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions/mise" ]]; then
  # shellcheck source=/dev/null
  . "${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions/mise"
fi
