# Reference:
# - https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md
# - https://vt100.net/docs/vt510-rm/DECSCUSR.html

setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

_prompt_pretty_path() {
	local git_root="$1"
	local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
	local ellipsis="..."
	[[ "${glyphs}" != "ascii" ]] && ellipsis="…"

	local subpath
	if [[ -n "${git_root}" ]]; then
		local repo_name="${git_root:t}"
		subpath="${PWD#${git_root}}"
		subpath="${subpath#/}"
		if [[ -z "${subpath}" ]]; then
			print -n "${repo_name}"
		else
			local -a parts=(${(s:/:)subpath})
			if (( ${#parts} > 2 )); then
				print -n "${repo_name}/${ellipsis}/${parts[-2]}/${parts[-1]}"
			else
				print -n "${repo_name}/${subpath}"
			fi
		fi
	else
		if [[ "${PWD}" == "${HOME}" ]]; then
			print -n "${HOME}"
		elif [[ "${PWD}" == "${HOME}"/* ]]; then
			local home_subpath="${PWD#${HOME}/}"
			local -a parts=(${(s:/:)home_subpath})
			if (( ${#parts} > 2 )); then
				print -n "~/${ellipsis}/${parts[-2]}/${parts[-1]}"
			else
				print -n "~/${home_subpath}"
			fi
		else
			local sys_subpath="${PWD#/}"
			local -a parts=(${(s:/:)sys_subpath})
			if (( ${#parts} > 2 )); then
				print -n "/${ellipsis}/${parts[-2]}/${parts[-1]}"
			else
				print -n "${PWD}"
			fi
		fi
	fi
}

_prompt_char() {
	local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
	if [[ "${USER}" == "root" ]]; then
		print -n "# "
		return
	fi

	case ${KEYMAP} in
	vicmd | viopp)
		if [[ "${glyphs}" == "unicode" ]]; then
			print -n "❮ "
		elif [[ "${glyphs}" == "nerdfont" ]]; then
			print -n " "
		else
			print -n "< "
		fi
		;;
	*)
		if [[ "${glyphs}" == "unicode" ]]; then
			print -n "❯ "
		elif [[ "${glyphs}" == "nerdfont" ]]; then
			print -n " "
		else
			print -n "> "
		fi
		;;
	esac
}

precmd() {
	local exit_code=$?
	print -n $'\e]133;D;'"${exit_code}"$'\a'
	local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
	local sep="%F{8} . %f"
	local err_icon="!"
	local job_icon="&"
	if [[ "${glyphs}" != "ascii" ]]; then
		sep="%F{8} · %f"
	fi
	if [[ "${glyphs}" == "unicode" ]]; then
		err_icon="✖"
		job_icon="✦"
	elif [[ "${glyphs}" == "nerdfont" ]]; then
		err_icon=""
		job_icon=""
	fi

	local git_root
	git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
	local git_part=""
	if [[ -n "${git_root}" ]]; then
		local git_output="$(git-prompt-codicon 2>/dev/null)"
		if [[ -n "${git_output}" ]]; then
			git_part="${sep}${git_output}"
		fi
	fi

	local virtualenv_part=""
	if [[ -n "${VIRTUAL_ENV}" ]]; then
		virtualenv_part="${sep}%F{8}${VIRTUAL_ENV:t}%f"
	fi
	local jobs_part="%(1j|${sep}%F{8}${job_icon} %j%f|)"
	local host_part=""
	if [[ -n "${SSH_TTY}" ]]; then
		host_part="${sep}%F{8}%m%f"
	fi
	local user_part=""
	if [[ "${USER}" == "root" ]]; then
		user_part="%F{red}%n%f${sep}"
	fi
	local return_part=""
	if [[ ${exit_code} -ne 0 ]]; then
		return_part="%F{red}${err_icon} ${exit_code} %f"
	fi
	local osc_a=$'%{\e]133;A\a%}'
	local osc_b=$'%{\e]133;B\a%}'
	PS1=$'\n'"${osc_a}${user_part}%F{blue}$(_prompt_pretty_path "${git_root}")%f${git_part}${virtualenv_part}${jobs_part}${host_part}${sep}%F{8}%*%f"$'\n'"${return_part}"'$(_prompt_char)'"${osc_b}"
}

PS2=$'%{\e]133;A;k=s\a%}%F{8}> %f%{\e]133;B\a%}'

RPS1=""
update_vi_mode_indicator() {
	case $KEYMAP in
	vicmd | viopp)
		echo -ne '\e[1 q'
		;;
	viins | main)
		echo -ne '\e[5 q'
		;;
	esac
	zle reset-prompt
}

hide_vi_mode_indicator() {
	zle reset-prompt
}

zle -N zle-line-init update_vi_mode_indicator
zle -N zle-line-finish hide_vi_mode_indicator
zle -N zle-keymap-select update_vi_mode_indicator
echo -ne '\e[5 q'
preexec() {
	print -n $'\e]133;C\a'
	echo -ne '\e[5 q'
}

export KEYTIMEOUT=1
