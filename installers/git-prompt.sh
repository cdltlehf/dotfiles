#!/bin/sh

URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
mkdir -p "${XDG_DATA_HOME:="$HOME/.local/share"}/git"
curl -L "${URL}" -o "${XDG_DATA_HOME}/git/git-prompt.sh"
