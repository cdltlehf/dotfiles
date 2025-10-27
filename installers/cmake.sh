#!/bin/bash
PREFIX=${XDG_DATA_HOME}/cmake
URL="https://github.com/Kitware/CMake/releases/download/v4.2.0-rc1/cmake-4.2.0-rc1-linux-x86_64.tar.gz"

TARFILE="$(mktemp --suffix=.tar.gz)"
wget "${URL}" -O "${TARFILE}" || exit 1
mkdir -p "${PREFIX}" || exit 1
tar -xzf "${TARFILE}" -C "${PREFIX}" --strip-components=1
ln -s "${PREFIX}/bin/cmake" "${HOME}/.local/bin/cmake"
rm "${TARFILE}"
