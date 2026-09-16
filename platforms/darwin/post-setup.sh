#!/bin/bash
: "${__DOTFILES_SETUP:?Do not run directly}"

readonly SPOON_INSTALL_URL="https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"
readonly SPOONS_DIR="${XDG_CONFIG_HOME}/hammerspoon/Spoons"
readonly VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
readonly UBERSICHT_USER_DIR="${HOME}/Library/Application Support/Übersicht"

defaults delete com.apple.desktopservices 2>/dev/null || true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

defaults delete com.apple.screencapture 2>/dev/null || true
defaults write com.apple.screencapture disable-shadow -bool true

defaults delete com.apple.finder 2>/dev/null || true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowStatusBar -bool true

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleLanguages -array "en-US" "ko-KR"
defaults write NSGlobalDomain AppleLocale -string "en_KR"

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSUserDictionaryReplacementItems -array '()'

defaults delete com.apple.dock 2>/dev/null || true
defaults write com.apple.dock "autohide-delay" -float "0"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock persistent-apps -array '()'
defaults write com.apple.dock persistent-others -array '()'
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock static-only -bool true

defaults write org.hammerspoon.Hammerspoon MJConfigFile "${XDG_CONFIG_HOME}/hammerspoon/init.lua"

for app in "Finder" "Dock" "SystemUIServer"; do
  killall "${app}" &>/dev/null || true
done

symlink "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" "${HOME}/iCloud"

if [ ! -d "${SPOONS_DIR}/SpoonInstall.spoon" ]; then
  mkdir -p "${SPOONS_DIR}"
  tmp_zip=$(mktemp /tmp/SpoonInstall.XXXXXX)
  curl -fsSL "${SPOON_INSTALL_URL}" -o "${tmp_zip}"
  unzip -q "${tmp_zip}" -d "${SPOONS_DIR}"
  rm "${tmp_zip}"
fi

if [ -d "${VSCODE_USER_DIR}" ] || command -v code &>/dev/null; then
  mkdir -p "${VSCODE_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
fi
if [ -d "${XDG_CONFIG_HOME}/ubersicht/widgets" ]; then
  mkdir -p "${UBERSICHT_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/ubersicht/widgets" "${UBERSICHT_USER_DIR}/widgets"
fi

if [ -d "${XDG_CONFIG_HOME}/ubersicht/widgets" ]; then
  mkdir -p "${UBERSICHT_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/ubersicht/widgets" "${UBERSICHT_USER_DIR}/widgets"
fi
