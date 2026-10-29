#!/bin/sh

set -o nounset
set -o errexit

defaults delete com.apple.desktopservices 2>/dev/null || true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
