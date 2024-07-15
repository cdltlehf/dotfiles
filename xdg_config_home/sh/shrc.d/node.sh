#!/bin/sh

: "${XDG_DATA_HOME:="${HOME}/.local/share"}"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}"/node_repl_history
