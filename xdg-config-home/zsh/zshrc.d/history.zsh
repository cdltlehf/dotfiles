# Reference:
# - https://support.apple.com/guide/terminal/save-or-restore-sessions-trml1007/mac

[[ -d "${XDG_STATE_HOME}/zsh" ]] || mkdir -p "${XDG_STATE_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
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
