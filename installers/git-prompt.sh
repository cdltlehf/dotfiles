#!/bin/sh

: "${XDG_DATA_HOME:="$HOME/.local/share"}"
URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

mkdir -p "${XDG_DATA_HOME}"
curl "${URL}" -o "${XDG_DATA_HOME}/git-prompt.sh" 
