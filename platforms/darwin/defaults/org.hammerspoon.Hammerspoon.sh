#!/bin/sh

set -o nounset
set -o errexit

defaults write org.hammerspoon.Hammerspoon MJConfigFile \
  -string "${XDG_CONFIG_HOME:-${HOME}/.config}/hammerspoon/init.lua"
