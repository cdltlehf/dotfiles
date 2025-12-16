#!/bin/bash

: ${URL:="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"}
: ${PREFIX:="${HOME}/.local/opt/nvim-linux-x86_64"}

mkdir -p "${PREFIX}" || exit 1
cd "${PREFIX}" || exit 1
TARFILE="$(mktemp --suffix=.tar.gz)"
wget "${URL}" -O "${TARFILE}" || exit 1
tar -xzf "${TARFILE}" -C "${PREFIX}" --strip-components=1 || exit 1

echo "Add ${PREFIX}/bin to your PATH."
