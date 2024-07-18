#!/bin/bash

tmpdir=$(mktemp -d)
trap 'rm -rf -- "${tmpdir}"' EXIT
git clone --depth=1 https://github.com/vim/vim.git "${tmpdir}"
cd "${tmpdir}"/src || exit 1
./configure --prefix="$HOME/.local" --with-local-dir="$HOME/.local"
make install
