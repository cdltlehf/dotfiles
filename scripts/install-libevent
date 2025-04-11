#!/bin/bash

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "${XDG_DATA_HOME}"
cd "${XDG_DATA_HOME}"
git clone --depth=1 "https://github.com/libevent/libevent.git"
cd libevent

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
make install
