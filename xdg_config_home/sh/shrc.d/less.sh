#!/bin/sh

: "${XDG_DATA_HOME:="${HOME}/.local/share"}"
export LESSHIST="$XDG_DATA_HOME/less/history"
