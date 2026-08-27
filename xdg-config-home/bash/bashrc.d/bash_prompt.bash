if [[ -f "${XDG_DATA_HOME}/git/completion/git-prompt.sh" ]]; then
  source "${XDG_DATA_HOME}/git/completion/git-prompt.sh"
fi

__prompt_pretty_path() {
  local charset="${CHARSET:-ascii}"
  local ellipsis="..."
  [[ "${charset}" != "ascii" ]] && ellipsis="…"

  local git_root subpath
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "${git_root}" ]]; then
    local repo_name
    repo_name=$(basename "${git_root}")
    subpath="${PWD#${git_root}}"
    subpath="${subpath#/}"
    if [[ -z "${subpath}" ]]; then
      printf "%s" "${repo_name}"
    else
      IFS='/' read -r -a parts <<<"${subpath}"
      local len=${#parts[@]}
      if [[ ${len} -gt 2 ]]; then
        printf "%s/%s/%s/%s" "${repo_name}" "${ellipsis}" "${parts[len-2]}" "${parts[len-1]}"
      else
        printf "%s/%s" "${repo_name}" "${subpath}"
      fi
    fi
  else
    if [[ "${PWD}" == "${HOME}" ]]; then
      printf "%s" "${HOME}"
    else
      local full_path="${PWD/#${HOME}/~}"
      IFS='/' read -r -a parts <<<"${full_path}"
      local len=${#parts[@]}
      if [[ ${len} -gt 3 ]]; then
        printf "%s/%s/%s" "${ellipsis}" "${parts[len-2]}" "${parts[len-1]}"
      else
        printf "%s" "${full_path}"
      fi
    fi
  fi
}

__prompt_command() {
  local exit_code=$?
  local charset="${CHARSET:-ascii}"
  local sep="\[\e[1;30m\] . \[\e[0m\]"
  local err_icon="!"
  if [[ "${charset}" != "ascii" ]]; then
    sep="\[\e[1;30m\] · \[\e[0m\]"
  fi
  if [[ "${charset}" == "nerdfont" ]]; then
    err_icon=""
  fi

  PS1=$'\n'

  # Username (only when root/sudo)
  if [[ "${USER}" == "root" ]]; then
    PS1+="\[\e[31m\]\u\[\e[0m\]${sep}"
  fi

  # Smart path
  PS1+="\[\e[34m\]$(__prompt_pretty_path)\[\e[0m\]"

  # Git prompt
  local git_output
  git_output="$(git-prompt-codicon 2>/dev/null)"
  if [[ -n "${git_output}" ]]; then
    PS1+="${sep}${git_output}"
  fi

  # Environment
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    PS1+="${sep}$(basename "${VIRTUAL_ENV}")"
  fi

  # Remote host (only on SSH, before timestamp)
  if [[ -n "${SSH_TTY}" ]]; then
    PS1+="${sep}\h"
  fi

  # Timestamp
  PS1+="${sep}\t\n"

  # Return with error code on 2nd line if failed
  if [[ "${exit_code}" -ne 0 ]]; then
    PS1+="\[\e[31m\]${err_icon} ${exit_code} \[\e[0m\]"
  fi
  if [[ "${USER}" == "root" ]]; then
    PS1+="# "
  else
    PS1+="\$ "
  fi

  # Continued prompt
  PS2=$"\[\e[1;30m\]> \[\e[0m\]"
}

if [[ -z "${PROMPT_COMMAND}" ]]; then
  PROMPT_COMMAND="__prompt_command"
else
  PROMPT_COMMAND="${PROMPT_COMMAND}; __prompt_command"
fi
export PROMPT_COMMAND
