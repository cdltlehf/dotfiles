#!/bin/sh

: ${XDG_CONFIG_HOME:="${HOME}/.config"}
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
