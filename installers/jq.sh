#!/bin/bash

: ${URL:="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64"}
: ${XDG_DATA_HOME:="${HOME}/.local/share"}
: ${PREFIX:="${HOME}/.local"}

mkdir -p "${XDG_DATA_HOME}"
mkdir -p "${PREFIX}/bin"

cd "${XDG_DATA_HOME}"
wget "${URL}"
chmod +x "jq-linux64"

ln -sf "$(pwd)/jq-linux64" "${PREFIX}/bin/jq"
