#!/bin/bash

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "${XDG_DATA_HOME}"
cd "${XDG_DATA_HOME}"
git clone "https://github.com/tmux/tmux.git"
cd tmux

sh autogen.sh
./configure --prefix="$HOME/.local"
make
