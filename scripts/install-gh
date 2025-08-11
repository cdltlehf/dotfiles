#!/bin/bash

cd /tmp
wget https://github.com/cli/cli/releases/download/v2.76.2/gh_2.76.2_linux_386.tar.gz
tar xvf gh_*.tar.gz
cd gh_*/

mkdir -p "${HOME}/.local/bin/"
mkdir -p "${HOME}/.local/share/man/man1/"
cp bin/* "${HOME}/.local/bin"
cp share/man/man1/* "${HOME}/.local/share/man/man1"
