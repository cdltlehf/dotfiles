#!/bin/sh

set -o nounset
set -o errexit

defaults delete com.apple.TextEdit 2>/dev/null || true
defaults write com.apple.TextEdit RichText -bool false
