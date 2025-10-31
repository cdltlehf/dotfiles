#!/bin/bash

PREFIX="${HOME}/.local/opt/fzf"
URL="https://github.com/junegunn/fzf.git"

git clone --depth 1 "${URL}" "${PREFIX}" || exit 1
cd "${PREFIX}" || exit 1
./install --bin
