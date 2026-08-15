setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' on %F{2}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' on %F{2}(%b|%a)%f'

precmd() {
	vcs_info
}

_prompt_user() {
	if [[ "${USER}" == "root" ]]; then
		print -n "%F{1}%n%f"
	else
		print -n "%F{5}%n%f"
	fi
}

_prompt_host() {
	if [[ -n "${SSH_TTY}" ]]; then
		print -n " at %F{1}%m%f"
	else
		print -n " at %F{6}%m%f"
	fi
}

_prompt_virtualenv() {
	[[ -z "${VIRTUAL_ENV}" ]] && return
	print -n " via %F{4}${VIRTUAL_ENV:t}%f"
}

PS1=$'\n$(_prompt_user)$(_prompt_host) in %F{3}%~%f${vcs_info_msg_0_}$(_prompt_virtualenv)  %F{8}# %*%f\n%(?.%f$ %f.%B%F{1}?%? %f%b)'

PS2="%F{103}> %f"

RPS1="%F{0}%K{3} INSERT %k%f"
update_vi_mode_indicator() {
	case $KEYMAP in
	vicmd | viopp)
		RPS1="%F{0}%K{2} NORMAL %k%f"
		echo -ne '\e[1 q'
		;;
	viins | main)
		RPS1="%F{0}%K{3} INSERT %k%f"
		echo -ne '\e[5 q'
		;;
	isearch) RPS1="%F{7}[/]%k%f" ;;
	*) RPS1="%B%F{1}[UNK]%k%f%b" ;;
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
