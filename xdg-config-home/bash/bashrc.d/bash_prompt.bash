# shellcheck disable=SC2088
#
# Reference:
# - https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md

__prompt_pretty_path() {
  local git_root="$1"
  local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
  local ellipsis="..."
  [[ "${glyphs}" != "ascii" ]] && ellipsis="…"

  local subpath
  if [[ -n "${git_root}" ]]; then
    local repo_name="${git_root##*/}"
    subpath="${PWD#"${git_root}"}"
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
    elif [[ "${PWD}" == "${HOME}"/* ]]; then
      local home_subpath="${PWD#"${HOME}"/}"
      IFS='/' read -r -a parts <<<"${home_subpath}"
      local len=${#parts[@]}
      if [[ ${len} -gt 2 ]]; then
        printf "~/%s/%s/%s" "${ellipsis}" "${parts[len-2]}" "${parts[len-1]}"
      else
        printf "~/%s" "${home_subpath}"
      fi
    else
      local sys_subpath="${PWD#/}"
      IFS='/' read -r -a parts <<<"${sys_subpath}"
      local len=${#parts[@]}
      if [[ ${len} -gt 2 ]]; then
        printf "/%s/%s/%s" "${ellipsis}" "${parts[len-2]}" "${parts[len-1]}"
      else
        printf "%s" "${PWD}"
      fi
    fi
  fi
}

__prompt_command() {
  local exit_code=$?
  printf $'\e]133;D;%s\a' "${exit_code}"
  local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
  local sep="\[\e[90m\] . \[\e[0m\]"
  local err_icon="!"
  local job_icon="&"
  local prompt_char="> "
  if [[ "${glyphs}" != "ascii" ]]; then
    sep="\[\e[90m\] · \[\e[0m\]"
  fi
  if [[ "${glyphs}" == "unicode" ]]; then
    err_icon="✖"
    job_icon="✦"
    prompt_char="❯ "
  elif [[ "${glyphs}" == "nerdfont" ]]; then
    err_icon=""
    job_icon=""
    prompt_char=" "
  fi

  local git_root
  git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  local git_part=""
  if [[ -n "${git_root}" ]]; then
    local git_output
    git_output="$(git-prompt-codicon 2>/dev/null)"
    if [[ -n "${git_output}" ]]; then
      git_part="${sep}${git_output}"
    fi
  fi

  local -a job_pids
  readarray -t job_pids < <(jobs -p)
  local job_count=${#job_pids[@]}
  local jobs_part=""
  if [[ ${job_count} -gt 0 ]]; then
    jobs_part="${sep}\[\e[90m\]${job_icon} ${job_count}\[\e[0m\]"
  fi

  local osc_a=$'\[\e]133;A\a\]'
  local osc_b=$'\[\e]133;B\a\]'
  PS1=$'\n'"${osc_a}"

  # Username (only when root/sudo)
  if [[ "${USER}" == "root" ]]; then
    PS1+="\[\e[31m\]\u\[\e[0m\]${sep}"
  fi

  # Smart path
  PS1+="\[\e[34m\]$(__prompt_pretty_path "${git_root}")\[\e[0m\]"

  # Git prompt
  if [[ -n "${git_part}" ]]; then
    PS1+="${git_part}"
  fi

  # Environment
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    PS1+="${sep}\[\e[90m\]${VIRTUAL_ENV##*/}\[\e[0m\]"
  fi

  # Background jobs
  if [[ -n "${jobs_part}" ]]; then
    PS1+="${jobs_part}"
  fi

  # Remote host (only on SSH, before timestamp)
  if [[ -n "${SSH_TTY}" ]]; then
    PS1+="${sep}\[\e[90m\]\h\[\e[0m\]"
  fi

  # Timestamp
  PS1+="${sep}\[\e[90m\]\t\[\e[0m\]\n"

  # Return with error code on 2nd line if failed
  if [[ "${exit_code}" -ne 0 ]]; then
    PS1+="\[\e[31m\]${err_icon} ${exit_code} \[\e[0m\]"
  fi
  if [[ "${USER}" == "root" ]]; then
    PS1+="# "
  else
    PS1+="${prompt_char}"
  fi
  PS1+="${osc_b}"

  # Continued prompt & command start marker
  PS0=$'\[\e]133;C\a\]'
  PS2=$'\[\e]133;A;k=s\a\]\[\e[90m\]> \[\e[0m\]\[\e]133;B\a\]'
}

if [[ "${PROMPT_COMMAND:-}" != *"__prompt_command"* ]]; then
  PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi
export PROMPT_COMMAND
