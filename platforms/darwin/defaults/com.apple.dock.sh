#!/bin/sh

set -o nounset
set -o errexit

defaults delete com.apple.dock 2>/dev/null || true
defaults write com.apple.dock "autohide-delay" -float "0"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock static-only -bool true
