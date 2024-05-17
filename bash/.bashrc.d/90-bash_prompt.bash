#!/bin/bash
# shellcheck disable=2016

export VIRTUAL_ENV_DISABLE_PROMPT

if ! declare -F __git_ps1 > /dev/null 2>&1; then
  echo "placeholder __git_ps1"
  __git_ps1() {
    echo ""
  }
fi

__prompt_command() {
  local exit_code=$?
  PS1=$'\n'

  # Username
  if [[ "${USER}" == "root" ]]; then
    PS1+="\[\033[31m\]\u\[\033[0m\]"
  else
    PS1+="\[\033[35m\]\u\[\033[0m\]"
  fi;

  # Hostname
  if [[ -n "${SSH_TTY:+}" ]]; then
    PS1+=" at \[\033[31m\]\h\[\033[0m\]"
  else
    PS1+=" at \[\033[36m\]\h\[\033[0m\]"
  fi;

  # Current working directory
  PS1+=$" in \[\033[33m\]\w\[\033[0m\]"

  # Git prompt
  PS1+="$(__git_ps1 " on %s")"

  # Environment
  if ! [[ -z "${VIRTUAL_ENV:+}" ]]; then
    PS1+=" via \[\033[34m\]"$(basename "$VIRTUAL_ENV")"\[\033[0m\]"
  fi;

  PS1+="\n"

  # Return
  if [ "${exit_code}" -eq 0 ]; then
    PS1+="\$ "
  else
    PS1+="\[\033[31m\](${exit_code})$\[\033[0m\] "
  fi;

  # Continued prompt
  # XXX: It uses 256-color
  PS2=$"\[\033[38;5;103m\]> \[\033[0m\]"
}

PROMPT_COMMAND=__prompt_command

# vim:ts=2:sts=2:sw=2:et:sta:fdm=marker:fdl=0
