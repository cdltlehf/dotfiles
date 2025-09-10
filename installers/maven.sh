#!/bin/bash

: ${URL:="https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.zip"}
: ${XDG_DATA_HOME:="${HOME}/.local/share"}
: ${PREFIX:="${HOME}/.local"}

mkdir -p "${XDG_DATA_HOME}"
mkdir -p "${PREFIX}/bin"

cd "${XDG_DATA_HOME}"
wget "${URL}"
unzip "$(basename "${URL}")"
rm -f "$(basename "${URL}")"

cd apache-maven-*

ln -sf "$(pwd)/bin/mvn" "{$PREFIX}/bin/mvn"
ln -sf "$(pwd)/bin/mvnDebug" "{$PREFIX}/bin/mvnDebug"
ln -sf "$(pwd)/bin/mvnyjp" "{$PREFIX}/bin/mvnyjp"
