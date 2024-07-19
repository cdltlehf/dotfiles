#!/bin/sh
# https://github.com/nvm-sh/nvm


: "${XDG_DATA_HOME:="$HOME/.local/share"}"
# shellcheck source=/dev/null

export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -f "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
NODE_PATH=$(echo $NVM_DIR/versions/node/*/bin(N) | head -1)
[ -n "$NODE_PATH" ] && PATH="$NODE_PATH:$PATH"
unset -v NODE_PATH
