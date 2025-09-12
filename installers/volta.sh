#!/bin/bash

: ${URL:="https://get.volta.sh"}
: ${VOLTA_HOME:="${HOME}/.volta"}

curl "${URL}" | bash -s -- --skip-setup

echo "Run \`${VOLTA_HOME}/bin/volta install node\` to install node"
