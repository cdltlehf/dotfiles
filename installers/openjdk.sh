#!/bin/bash
PREFIX="${HOME}/.local/opt/jvm"

URL="https://download.java.net/java/GA/jdk24.0.2/fdc5d0102fe0414db21410ad5834341f/12/GPL/openjdk-24.0.2_linux-x64_bin.tar.gz"

mkdir -p "${PREFIX}" || exit 1
cd "${PREFIX}" || exit 1
TARFILE="$(mktemp --suffix=.tar.gz)"
wget "${URL}" -O "${TARFILE}" || exit 1
TOPDIR="$(tar -tzf "${TARFILE}" | head -n 1 | cut -d '/' -f 1)"
tar -xzf "${TARFILE}" || exit 1
ln -snf "${TOPDIR}" "$(pwd)/current"

echo "Add ${PREFIX}/current/bin to your PATH."
