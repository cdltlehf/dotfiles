# shellcheck shell=bash
#
# Reference: https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md

__prompt_pretty_path() {
  local git_root="$1"
  local ellipsis="..."
  [[ "${LC_TERMINAL_GLYPHS:-ascii}" != "ascii" ]] && ellipsis="…"

  local prefix subpath
  if [[ -n "${git_root}" ]]; then
    prefix="${git_root##*/}"
    subpath="${PWD#"${git_root}"}"
    subpath="${subpath#/}"
    if [[ -z "${subpath}" ]]; then
      printf "%s" "${prefix}"
      return
    fi
  elif [[ "${PWD}" == "${HOME}" ]]; then
    printf "%s" "${HOME}"
    return
  elif [[ "${PWD}" == "${HOME}"/* ]]; then
    prefix="~"
    subpath="${PWD#"${HOME}"/}"
  else
    prefix=""
    subpath="${PWD#/}"
  fi

  local -a parts
  IFS='/' read -r -a parts <<<"${subpath}"
  local len=${#parts[@]}
  if [[ ${len} -gt 2 ]]; then
    printf "%s/%s/%s/%s" "${prefix}" "${ellipsis}" "${parts[len - 2]}" "${parts[len - 1]}"
  else
    printf "%s/%s" "${prefix}" "${subpath}"
  fi
}

__prompt_command() {
  local exit_code=$?
  printf $'\e]133;D;%s\a' "${exit_code}"
  local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
  local sep="\[\e[90m\] . \[\e[0m\]"
  local err_icon="!"
  local job_icon="&"
  local host_icon="@"
  local prompt_symbol=">"
  if [[ "${glyphs}" != "ascii" ]]; then
    sep="\[\e[90m\] · \[\e[0m\]"
  fi
  if [[ "${glyphs}" == "unicode" ]]; then
    err_icon="×"
    prompt_symbol="›"
  elif [[ "${glyphs}" == "nerdfont" ]]; then
    err_icon=""
    job_icon=""
    host_icon=" "
    prompt_symbol=""
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
  readarray -t job_pids < <(jobs -p || true)
  local job_count=${#job_pids[@]}
  local jobs_part=""
  if [[ ${job_count} -gt 0 ]]; then
    jobs_part="${sep}\[\e[90m\]${job_icon} ${job_count}\[\e[0m\]"
  fi

  local osc_a=$'\[\e]133;A\a\]'
  local osc_b=$'\[\e]133;B\a\]'
  PS1=$'\n'"${osc_a}"

  if [[ "${USER}" == "root" ]]; then
    PS1+="\[\e[31m\]\u\[\e[0m\]${sep}"
  fi
  PS1+="\[\e[34m\]$(__prompt_pretty_path "${git_root}")\[\e[0m\]"
  PS1+="${git_part}"
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    PS1+="${sep}\[\e[90m\]${VIRTUAL_ENV##*/}\[\e[0m\]"
  fi
  PS1+="${jobs_part}"
  if [[ -n "${SSH_TTY}" ]]; then
    PS1+="${sep}\[\e[90m\]${host_icon}\h\[\e[0m\]"
  fi
  PS1+="${sep}\[\e[90m\]\t\[\e[0m\]\n"

  if [[ "${exit_code}" -ne 0 ]]; then
    PS1+="\[\e[31m\]${err_icon} ${exit_code} \[\e[0m\]"
  fi
  if [[ "${USER}" == "root" ]]; then
    prompt_symbol="#"
  fi
  local count=$((SHLVL - ${__LOGIN_SHLVL:-${SHLVL}} + 1))
  if ((count < 1)); then
    PS1+="?"
    count=1
  fi
  for (( ; count > 0; count--)); do
    PS1+="${prompt_symbol}"
  done
  PS1+=" ${osc_b}"

  PS0=$'\[\e]133;C\a\]'
  PS2=$'\[\e]133;A;k=s\a\]\[\e[90m\]> \[\e[0m\]\[\e]133;B\a\]'
}

if [[ "${PROMPT_COMMAND:-}" != *"__prompt_command"* ]]; then
  PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
fi
