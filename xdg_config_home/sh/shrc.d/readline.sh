#!/bin/sh

: "${XDG_CONFIG_HOME:="${HOME}/.config"}"
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
