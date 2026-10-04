# Reference: https://support.apple.com/guide/terminal/save-or-restore-sessions-trml1007/mac

_hist_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
[[ -d "${_hist_dir}" ]] || mkdir -p "${_hist_dir}"
export HISTFILE="${_hist_dir}/history"
unset _hist_dir

export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

export SHELL_SESSIONS_DISABLE=1
