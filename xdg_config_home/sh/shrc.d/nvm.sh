#!/bin/sh
# https://github.com/nvm-sh/nvm


: "${XDG_DATA_HOME:="$HOME/.local/share"}"
# shellcheck source=/dev/null

export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
NODE_PATH=$(find "$XDG_DATA_HOME/nvm/versions/node" \
  -maxdepth 2 -name bin -print -quit 2> /dev/null)

[ -n "$NODE_PATH" ] && PATH="$NODE_PATH:$PATH"
unset -v NODE_PATH
