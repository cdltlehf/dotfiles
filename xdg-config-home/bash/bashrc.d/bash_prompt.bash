#!/bin/bash

if ! declare -F __git_ps1 >/dev/null 2>&1; then
	__git_ps1() {
		echo ""
	}
fi

__prompt_command() {
	local exit_code=$?
	PS1=$'\n'

	if [[ ${COLUMNS} -ge 80 ]]; then
		# Username
		if [[ "${USER}" == "root" ]]; then
			PS1+="\[\e[31m\]\u\[\e[0m\]"
		else
			PS1+="\[\e[35m\]\u\[\e[0m\]"
		fi

		if [[ ${COLUMNS} -ge 120 ]]; then
			# Hostname
			if [[ -n "${SSH_TTY}" ]]; then
				PS1+=" at \[\e[31m\]\h\[\e[0m\]"
			else
				PS1+=" at \[\e[36m\]\h\[\e[0m\]"
			fi
		fi
		PS1+=$" in "
	fi

	# Current working directory
	PS1+=$"\[\e[33m\]\w\[\e[0m\]"

	# Git prompt
	PS1+="$(__git_ps1 " on %s")"

	# Environment
	if [[ -n "${VIRTUAL_ENV}" ]]; then
		PS1+=" via \[\e[34m\]$(basename "${VIRTUAL_ENV}")\[\e[0m\]"
	fi

	# Timestamp
	PS1+='  \[\e[1;30m\]# \t\[\e[0m\]'
	PS1+="\n"

	# Return
	if [ "${exit_code}" -eq 0 ]; then
		PS1+="\$ "
	else
		PS1+="\[\e[31m\](${exit_code})$\[\e[0m\] "
	fi

	# Continued prompt
	# XXX: It uses 256-color
	PS2=$"\[\e[38;5;103m\]> \[\e[0m\]"
}

if [[ -z "${PROMPT_COMMAND}" ]]; then
	PROMPT_COMMAND="__prompt_command"
else
	PROMPT_COMMAND="${PROMPT_COMMAND}; __prompt_command"
fi
export PROMPT_COMMAND
