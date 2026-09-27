#!/bin/bash

: "${__DOTFILES_SETUP:?Do not run directly}"
: "${XDG_CONFIG_HOME:?Do not run directly}"
: "${BASE_DIR:?Do not run directly}"

readonly SPOON_INSTALL_URL="https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"
readonly ZATHURA_APP_CONVERT_URL="https://raw.githubusercontent.com/homebrew-zathura/homebrew-zathura/refs/heads/master/convert-into-app.sh"
readonly SPOONS_DIR="${XDG_CONFIG_HOME}/hammerspoon/Spoons"
readonly VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
readonly UBERSICHT_USER_DIR="${HOME}/Library/Application Support/Übersicht"
readonly SHORTCUTS_PLIST_DIR="${BASE_DIR}/platforms/darwin/plists/shortcuts"

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

defaults write org.hammerspoon.Hammerspoon \
  MJConfigFile "${XDG_CONFIG_HOME}/hammerspoon/init.lua"

for app in "Finder" "Dock" "SystemUIServer"; do
  killall "${app}" &>/dev/null || true
done

symlink "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" "${HOME}/iCloud"

if [[ ! -d "${SPOONS_DIR}/SpoonInstall.spoon" ]]; then
  tmpfile="$(mktemp || true)"
  download "${SPOON_INSTALL_URL}" "${tmpfile}"
  unzip -q "${tmpfile}" -d "${SPOONS_DIR}"
  rm "${tmpfile}"
  unset tmpfile
fi

if [[ -d "${VSCODE_USER_DIR}" ]] || command -v code &>/dev/null; then
  mkdir -p "${VSCODE_USER_DIR}"
  symlink \
    "${XDG_CONFIG_HOME}/vscode/settings.json" \
    "${VSCODE_USER_DIR}/settings.json"
fi
if [[ -d "${XDG_CONFIG_HOME}/ubersicht/widgets" ]]; then
  mkdir -p "${UBERSICHT_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/ubersicht/widgets" "${UBERSICHT_USER_DIR}/widgets"
fi

if command -v shortcuts &>/dev/null; then
  if ! (shortcuts list 2>/dev/null || true) |
    grep -Fxq "Toggle High Dynamic Range"; then
    tmpdir=$(mktemp -d)
    plutil \
      -convert binary1 \
      "${SHORTCUTS_PLIST_DIR}/toggle_high_dynamic_range.plist" \
      -o "${tmpdir}/Toggle High Dynamic Range.unsigned.shortcut"
    shortcuts sign \
      --mode people-who-know-me \
      -i "${tmpdir}/Toggle High Dynamic Range.unsigned.shortcut" \
      -o "${tmpdir}/Toggle High Dynamic Range.shortcut"
    open "${tmpdir}/Toggle High Dynamic Range.shortcut"
    sleep 2
    rm -rf "${tmpdir}"
    unset tmpdir
  fi
fi

if command -v brew &>/dev/null && brew list zathura &>/dev/null; then
  if [[ ! -d "/Applications/Zathura.app" ]]; then
    (curl -fsSL "${ZATHURA_APP_CONVERT_URL}" || true) | sh
  fi
  zathura_lib_dir="$(brew --prefix zathura 2>/dev/null || true)/lib/zathura"
  mkdir -p "${zathura_lib_dir}"
  for plugin in cb djvu pdf-mupdf pdf-poppler ps; do
    plugin_prefix="$(
      brew --prefix "zathura-${plugin}" 2>/dev/null || true
    )"
    if [[ -n "${plugin_prefix}" ]] &&
      [[ -f "${plugin_prefix}/lib${plugin}.dylib" ]]; then
      ln -sf "${plugin_prefix}/lib${plugin}.dylib" "${zathura_lib_dir}/"
    fi
  done
  unset zathura_lib_dir plugin plugin_prefix
fi
