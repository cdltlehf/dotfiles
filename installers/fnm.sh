#!/bin/bash

BINPATH="${HOME}/.local/bin"

: XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
PREFIX="${XDG_DATA_HOME}/fnm"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "${PREFIX}" --skip-shell
ln -sni "${PREFIX}/fnm" "${BINPATH}/fnm"

echo "Add \`eval \"\$(fnm env)\"\` to your shell configuration file."
