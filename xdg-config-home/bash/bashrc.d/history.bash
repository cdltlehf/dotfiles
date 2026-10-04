# Reference: https://support.apple.com/guide/terminal/save-or-restore-sessions-trml1007/mac

_state_bash_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
[[ -d "${_state_bash_dir}" ]] || mkdir -p "${_state_bash_dir}"
export HISTFILE="${_state_bash_dir}/history"
unset _state_bash_dir
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s cmdhist

export SHELL_SESSIONS_DISABLE=1
