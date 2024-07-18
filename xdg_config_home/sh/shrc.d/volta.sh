#!/bin/sh
# https://docs.volta.sh

: "${XDG_DATA_HOME:="${HOME}/.local/share"}"
export VOLTA_HOME="${XDG_DATA_HOME}/volta"
export PATH="${VOLTA_HOME}/bin:${PATH}"

