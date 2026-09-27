# Reference: https://support.apple.com/guide/terminal/save-or-restore-sessions-trml1007/mac

state_bash_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
[[ -d "${state_bash_dir}" ]] || mkdir -p "${state_bash_dir}"
export HISTFILE="${state_bash_dir}/history"
unset state_bash_dir
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s cmdhist

export SHELL_SESSIONS_DISABLE=1
