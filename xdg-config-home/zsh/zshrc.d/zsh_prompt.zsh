setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

if [[ -f "${XDG_DATA_HOME}/git/completion/git-prompt.sh" ]]; then
	source "${XDG_DATA_HOME}/git/completion/git-prompt.sh"
fi

_prompt_formatted_path() {
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
				print -n "${repo_name}:…/${parts[-2]}/${parts[-1]}"
			else
				print -n "${repo_name}:${subpath}"
			fi
		fi
	else
		local full_path="${PWD/#${HOME}/~}"
		local -a parts=(${(s:/:)full_path})
		if (( ${#parts} > 3 )); then
			print -n "…/${parts[-2]}/${parts[-1]}"
		else
			print -n "${full_path}"
		fi
	fi
}

if command -v __git_ps1 >/dev/null 2>&1; then
	precmd() {
		local virtualenv_part=""
		if [[ -n "${VIRTUAL_ENV}" ]]; then
			virtualenv_part="%F{8} · %F{4}${VIRTUAL_ENV:t}%f"
		fi
		local prompt_prefix=$'\n'"%F{5}%n%f%F{8} · %f%F{6}%m%f%F{8} · %F{3}$(_prompt_formatted_path)%f"
		local prompt_suffix="${virtualenv_part}%F{8} · %*%f"$'\n%(?.%f$ %f.%F{1}?%? %f)'
		__git_ps1 "${prompt_prefix}" "${prompt_suffix}" " \e[1;30m·\e[0m %s"
	}
else
	precmd() {
		local virtualenv_part=""
		if [[ -n "${VIRTUAL_ENV}" ]]; then
			virtualenv_part="%F{8} · %F{4}${VIRTUAL_ENV:t}%f"
		fi
		PS1=$'\n'"%F{5}%n%f%F{8} · %f%F{6}%m%f%F{8} · %F{3}$(_prompt_formatted_path)%f${virtualenv_part}%F{8} · %*%f"$'\n%(?.%f$ %f.%F{1}?%? %f)'
	}
fi

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
