if [[ -f "${XDG_DATA_HOME}/git/completion/git-prompt.sh" ]]; then
  source "${XDG_DATA_HOME}/git/completion/git-prompt.sh"
fi

if ! declare -F __git_ps1 >/dev/null 2>&1; then
  __git_ps1() {
    echo ""
  }
fi

__prompt_formatted_path() {
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
        printf "%s:…/%s/%s" "${repo_name}" "${parts[len-2]}" "${parts[len-1]}"
      else
        printf "%s:%s" "${repo_name}" "${subpath}"
      fi
    fi
  else
    local full_path="${PWD/#${HOME}/~}"
    IFS='/' read -r -a parts <<<"${full_path}"
    local len=${#parts[@]}
    if [[ ${len} -gt 3 ]]; then
      printf "…/%s/%s" "${parts[len-2]}" "${parts[len-1]}"
    else
      printf "%s" "${full_path}"
    fi
  fi
}

__prompt_command() {
  local exit_code=$?
  PS1=$'\n'

  local user_part=""
  if [[ "${USER}" == "root" ]]; then
    user_part="\[\e[31m\]\u\[\e[0m\]"
  else
    user_part="\[\e[35m\]\u\[\e[0m\]"
  fi

  local host_part=""
  if [[ -n "${SSH_TTY}" ]]; then
    host_part="\[\e[31m\]\h\[\e[0m\]"
  else
    host_part="\[\e[36m\]\h\[\e[0m\]"
  fi

  PS1+="${user_part}\[\e[1;30m\] · \[\e[0m\]${host_part}\[\e[1;30m\] · \[\e[0m\]"

  # Smart path
  PS1+="\[\e[33m\]$(__prompt_formatted_path)\[\e[0m\]"

  # Git prompt
  PS1+="$(__git_ps1 "\[\e[1;30m\] · \[\e[0m\]%s")"

  # Environment
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    PS1+="\[\e[1;30m\] · \[\e[0m\]\[\e[34m\]$(basename "${VIRTUAL_ENV}")\[\e[0m\]"
  fi

  # Timestamp
  PS1+="\[\e[1;30m\] · \[\e[0m\]\t\n"

  # Return
  if [ "${exit_code}" -eq 0 ]; then
    PS1+="\$ "
  else
    PS1+="\[\e[31m\]?${exit_code}\[\e[0m\] "
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
