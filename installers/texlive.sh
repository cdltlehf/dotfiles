#!/bin/bash

INSTALLER_PREFIX="${HOME}/.local/opt/texlive-installer"
PREFIX="${HOME}/.local/opt/texlive"

URL="https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"

mkdir -p "${INSTALLER_PREFIX}" || exit 1
cd "${INSTALLER_PREFIX}" || exit 1
wget -O - "${URL}" | tar -xzv -C "${INSTALLER_PREFIX}" || exit 1

# cd install-tl-* || exit 1
# ./install-tl -texdir "${PREFIX}"
