setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

if [[ -f "${XDG_DATA_HOME}/git/completion/git-prompt.sh" ]]; then
	source "${XDG_DATA_HOME}/git/completion/git-prompt.sh"
fi

_prompt_pretty_path() {
	local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
	local ellipsis="..."
	[[ "${glyphs}" != "ascii" ]] && ellipsis="…"

	local git_root subpath
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
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
		else
			local full_path="${PWD/#${HOME}/~}"
			local -a parts=(${(s:/:)full_path})
			if (( ${#parts} > 3 )); then
				print -n "${ellipsis}/${parts[-2]}/${parts[-1]}"
			else
				print -n "${full_path}"
			fi
		fi
	fi
}

precmd() {
	local exit_code=$?
	local glyphs="${LC_TERMINAL_GLYPHS:-ascii}"
	local sep="%F{8} . %f"
	local err_icon="!"
	if [[ "${glyphs}" != "ascii" ]]; then
		sep="%F{8} · %f"
	fi
	if [[ "${glyphs}" == "nerdfont" ]]; then
		err_icon=""
	fi

	local virtualenv_part=""
	if [[ -n "${VIRTUAL_ENV}" ]]; then
		virtualenv_part="${sep}%F{8}${VIRTUAL_ENV:t}%f"
	fi
	local host_part=""
	if [[ -n "${SSH_TTY}" ]]; then
		host_part="${sep}%F{8}%m%f"
	fi
	local user_part=""
	if [[ "${USER}" == "root" ]]; then
		user_part="%F{1}%n%f${sep}"
	fi
	local prompt_char="\$ "
	[[ "${USER}" == "root" ]] && prompt_char="# "
	local return_part=""
	if [[ ${exit_code} -ne 0 ]]; then
		return_part="%F{1}${err_icon} ${exit_code} %f"
	fi
	local git_output="$(git-prompt-codicon 2>/dev/null)"
	local git_part=""
	if [[ -n "${git_output}" ]]; then
		git_part="${sep}${git_output}"
	fi
	PS1=$'\n'"${user_part}%F{4}$(_prompt_pretty_path)%f${git_part}${virtualenv_part}${host_part}${sep}%F{8}%*%f"$'\n'"${return_part}${prompt_char}"
}

PS2="%F{8}> %f"

RPS1=""
update_vi_mode_indicator() {
	case $KEYMAP in
	vicmd | viopp)
		RPS1="%F{8}normal%f"
		echo -ne '\e[1 q'
		;;
	viins | main)
		RPS1=""
		echo -ne '\e[5 q'
		;;
	isearch) RPS1="%F{7}[/]%f" ;;
	*) RPS1="%F{1}[UNK]%f" ;;
	esac
	RPS2=$RPS1
	zle reset-prompt
}

hide_vi_mode_indicator() {
	RPS1=""
	RPS2=""
	zle reset-prompt
}

zle -N zle-line-init update_vi_mode_indicator
zle -N zle-line-finish hide_vi_mode_indicator
zle -N zle-keymap-select update_vi_mode_indicator
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

export KEYTIMEOUT=1
