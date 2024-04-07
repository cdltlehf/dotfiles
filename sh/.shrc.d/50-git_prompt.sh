#!/bin/sh
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
# export GIT_PS1_STATESEPARATOR
# export GIT_PS1_COMPRESSSPARSESTATE
# export GIT_PS1_OMITSPARSESTATE
# export GIT_PS1_DESCRIBE_STYLE
export GIT_PS1_SHOWCOLORHINTS=1
[ -f $HOME/.local/share/git-prompt.sh ] && . $HOME/.local/share/git-prompt.sh
