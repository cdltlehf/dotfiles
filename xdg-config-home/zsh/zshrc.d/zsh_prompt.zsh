setopt PROMPT_SUBST
ZLE_RPROMPT_INDENT=0

_PS1_1=$'\n'

# Username
if [[ "${USER}" == "root" ]] then
  _PS1_1+='%F{1}%n%f'
else
  _PS1_1+='%F{5}%n%f'
fi;

# Hostname
if [[ -n "${SSH_TTY}" ]]; then
  _PS1_1+=' at %F{1}%m%f'
else
  _PS1_1+=' at %F{6}%m%f'
fi;

# Current working directory
_PS1_1+=' in %F{3}%~%f'

# Git prompt
# _PS1_1+='$(__git_ps1 " on (%s)")'

# Environment
_PS1_2='$([ -z $VIRTUAL_ENV ] && echo ""'
_PS1_2+='|| echo " via %F{4}"$VIRTUAL_ENV:t"%f")'

# Timestamp
_PS1_2+='  %F{8}# %*%f'

# Exit status
_PS1_2+=$'\n'
_PS1_2+='%(?.%f$ %f.%B%F{1}?%? %f%b)'

# Continued prompt
# NOTE: It uses 256-color
PS2="%F{103}> %f"

if command -v __git_ps1 > /dev/null 2>&1; then
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUPSTREAM="auto"
  # GIT_PS1_STATESEPARATOR
  # GIT_PS1_COMPRESSSPARSESTATE
  # GIT_PS1_OMITSPARSESTATE
  # GIT_PS1_DESCRIBE_STYLE
  GIT_PS1_SHOWCOLORHINTS=1
  eval "precmd () { __git_ps1 '$_PS1_1' '$_PS1_2' ' on %s' }"
else
  PS1="$_PS1_1$_PS1_2"
fi

unset _PS1_1
unset _PS1_2

RPS1="%F{0}%K{3} INSERT %k%f"
update_vi_mode_indicator() {
  case $KEYMAP in
    vicmd|viopp ) RPS1="%F{0}%K{2} NORMAL %k%f"; echo -ne '\e[1 q';;
    viins|main ) RPS1="%F{0}%K{3} INSERT %k%f"; echo -ne '\e[5 q';;
    isearch ) RPS1="%F{7}[/]%k%f" ;; # Not working
    * ) RPS1="%B%F{1}[UNK]%k%f%b" ;;
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
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

export KEYTIMEOUT=1
