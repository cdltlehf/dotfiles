# Reference:
# - https://support.apple.com/guide/terminal/save-or-restore-sessions-trml1007/mac

[[ -d "${XDG_STATE_HOME}/bash" ]] || mkdir -p "${XDG_STATE_HOME}/bash"
export HISTFILE="${XDG_STATE_HOME}/bash/history"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s cmdhist

export SHELL_SESSIONS_DISABLE=1
