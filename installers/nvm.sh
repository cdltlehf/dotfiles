#!/bin/bash

XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
NVM_DIR="${NVM_DIR:-"$XDG_DATA_HOME/nvm"}"
mkdir -p "$NVM_DIR"
export PROFILE=/dev/null
url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh"
curl -o- "${url}" | bash
