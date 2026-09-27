if [[ -z "${BASH_COMPLETION_VERSINFO:-}" ]]; then
  if command -v brew >/dev/null 2>&1; then
    brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix)}"
    # shellcheck source=/dev/null
    [[ -r "${brew_prefix}/etc/profile.d/bash_completion.sh" ]] && . "${brew_prefix}/etc/profile.d/bash_completion.sh"
    unset brew_prefix
  elif [[ -r "/usr/share/bash-completion/bash_completion" ]]; then
    # shellcheck source=/dev/null
    . "/usr/share/bash-completion/bash_completion"
  fi
fi

if [[ -r "${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions/mise" ]]; then
  # shellcheck source=/dev/null
  . "${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions/mise"
fi
