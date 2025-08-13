#!/bin/bash

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "${XDG_DATA_HOME}"
cd "${XDG_DATA_HOME}"
git clone --depth=1 https://github.com/mirror/ncurses.git
cd ncurses

./configure --prefix="$HOME/.local"
make install
