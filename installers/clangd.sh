#!/bin/bash
PREFIX="${HOME}/.local/opt/clangd"
URL="https://github.com/clangd/clangd/releases/download/20.1.8/clangd-linux-20.1.8.zip"

mkdir -p "${PREFIX}"
cd $(mktemp -d)
wget "${URL}"
unzip "$(basename "${URL}")" -d "${PREFIX}"
cd "${PREFIX}"

latest="$(ls -d * 2>/dev/null | sort -V | tail -n1)"
ln -sfnv "${latest}" "current"
ln -sfnv "$(realpath current/bin)"/* "${HOME}/.local/bin"
