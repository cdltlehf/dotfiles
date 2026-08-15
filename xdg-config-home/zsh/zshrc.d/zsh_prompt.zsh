setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' on %F{2}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' on %F{2}(%b|%a)%f'

precmd() {
	vcs_info
}

_PS1_1=$'\n'

# Username
if [[ "${USER}" == "root" ]]; then
	_PS1_1+='%F{1}%n%f'
else
	_PS1_1+='%F{5}%n%f'
fi

# Hostname
if [[ -n "${SSH_TTY}" ]]; then
	_PS1_1+=' at %F{1}%m%f'
else
	_PS1_1+=' at %F{6}%m%f'
fi

# Current working directory
_PS1_1+=' in %F{3}%~%f'

# Environment
_PS1_2='$([ -z $VIRTUAL_ENV ] && echo ""'
_PS1_2+='|| echo " via %F{4}"$VIRTUAL_ENV:t"%f")'

# Timestamp
_PS1_2+='  %F{8}# %*%f'

# Exit status
_PS1_2+=$'\n'
_PS1_2+='%(?.%f$ %f.%B%F{1}?%? %f%b)'

PS1='${_PS1_1}${vcs_info_msg_0_}${_PS1_2}'

# Continued prompt
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
