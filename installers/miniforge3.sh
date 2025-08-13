#!/bin/bash
PREFIX=${MINIFORGE_HOME:-"${HOME}/miniforge3"}

URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

TEMPFILE="$(mktemp /tmp/miniforge-XXXXXX.sh)"
wget -O "${TEMPFILE}" "${URL}"
bash "${TEMPFILE}" -p "${PREFIX}"
