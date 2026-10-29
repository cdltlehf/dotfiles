#!/bin/sh

set -o nounset
set -o errexit

defaults delete com.apple.screencapture 2>/dev/null || true
defaults write com.apple.screencapture disable-shadow -bool true
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
