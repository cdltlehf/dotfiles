#!/bin/sh

set -o nounset
set -o errexit

: "${__DOTFILES_SETUP:?Do not run directly}"
: "${XDG_CONFIG_HOME:?Do not run directly}"
: "${BASE_DIR:?Do not run directly}"

readonly SPOON_INSTALL_URL="https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"
readonly ZATHURA_APP_CONVERT_URL="https://raw.githubusercontent.com/homebrew-zathura/homebrew-zathura/refs/heads/master/convert-into-app.sh"
readonly SPOONS_DIR="${XDG_CONFIG_HOME}/hammerspoon/Spoons"
readonly VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
readonly UBERSICHT_USER_DIR="${HOME}/Library/Application Support/Übersicht"
readonly SHORTCUTS_DIR="${BASE_DIR}/platforms/darwin/shortcuts"
readonly PREFERENCES_DIR="${BASE_DIR}/platforms/darwin/preferences"
readonly SYMBOLIC_HOTKEYS_PLIST="${HOME}/Library/Preferences/com.apple.symbolichotkeys.plist"
readonly KARABINER_TEMPLATES_DIR="${BASE_DIR}/xdg-config-home/karabiner/templates"
readonly KARABINER_RULES_DIR="${BASE_DIR}/xdg-config-home/karabiner/assets/complex_modifications"
readonly HOTKEY_SELECT_PREVIOUS_INPUT_SOURCE=60
readonly HOTKEY_SELECT_NEXT_INPUT_SOURCE=61

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
  killall "${app}" >/dev/null 2>&1 || true
done
unset app

if [ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  symlink "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" "${HOME}/iCloud"
fi

if [ ! -d "${SPOONS_DIR}/SpoonInstall.spoon" ]; then
  tmpdir="$(mktemp -d)"
  if [ -n "${tmpdir}" ] && [ -d "${tmpdir}" ]; then
    download "${SPOON_INSTALL_URL}" "${tmpdir}/SpoonInstall.zip"
    unzip -q "${tmpdir}/SpoonInstall.zip" -d "${SPOONS_DIR}"
    rm -rf "${tmpdir}"
  fi
  unset tmpdir
fi

# shellcheck disable=SC2310
if [ -d "${VSCODE_USER_DIR}" ] || has code; then
  mkdir -p "${VSCODE_USER_DIR}"
  symlink \
    "${XDG_CONFIG_HOME}/vscode/settings.json" \
    "${VSCODE_USER_DIR}/settings.json"
fi
if [ -d "${XDG_CONFIG_HOME}/ubersicht/widgets" ]; then
  mkdir -p "${UBERSICHT_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/ubersicht/widgets" "${UBERSICHT_USER_DIR}/widgets"
fi

if [ -f "${SYMBOLIC_HOTKEYS_PLIST}" ]; then
  for hotkey_id in "${HOTKEY_SELECT_PREVIOUS_INPUT_SOURCE}" "${HOTKEY_SELECT_NEXT_INPUT_SOURCE}"; do
    plutil -replace "AppleSymbolicHotKeys.${hotkey_id}.enabled" -bool false "${SYMBOLIC_HOTKEYS_PLIST}" 2>/dev/null || true
  done
  unset hotkey_id
fi

if [ -d "${PREFERENCES_DIR}" ]; then
  for plist in "${PREFERENCES_DIR}"/*.plist; do
    [ -f "${plist}" ] || continue
    domain="$(basename "${plist}" .plist)"
    defaults import "${domain}" "${plist}" 2>/dev/null || true
  done
  unset plist domain
fi

# shellcheck disable=SC2310
if has shortcuts; then
  if ! (shortcuts list 2>/dev/null || true) |
    grep -Fxq "Toggle High Dynamic Range"; then
    tmpdir="$(mktemp -d)"
    if [ -n "${tmpdir}" ] && [ -d "${tmpdir}" ]; then
      plutil \
        -convert binary1 \
        "${SHORTCUTS_DIR}/toggle_high_dynamic_range.plist" \
        -o "${tmpdir}/Toggle High Dynamic Range.unsigned.shortcut"
      shortcuts sign \
        --mode people-who-know-me \
        -i "${tmpdir}/Toggle High Dynamic Range.unsigned.shortcut" \
        -o "${tmpdir}/Toggle High Dynamic Range.shortcut"
      open "${tmpdir}/Toggle High Dynamic Range.shortcut"
      sleep 2
      rm -rf "${tmpdir}"
    fi
    unset tmpdir
  fi
fi

# shellcheck disable=SC2310
if has brew && brew list zathura >/dev/null 2>&1; then
  if [ ! -d "/Applications/Zathura.app" ]; then
    download "${ZATHURA_APP_CONVERT_URL}" | sh
  fi
  zathura_lib_dir="$(brew --prefix zathura 2>/dev/null || true)/lib/zathura"
  mkdir -p "${zathura_lib_dir}"
  for plugin in cb djvu pdf-mupdf pdf-poppler ps; do
    plugin_prefix="$(
      brew --prefix "zathura-${plugin}" 2>/dev/null || true
    )"
    if [ -n "${plugin_prefix}" ] &&
      [ -f "${plugin_prefix}/lib${plugin}.dylib" ]; then
      ln -sf "${plugin_prefix}/lib${plugin}.dylib" "${zathura_lib_dir}/"
    fi
  done
  unset zathura_lib_dir plugin plugin_prefix
fi

# shellcheck disable=SC2310
if has erb && [ -d "${KARABINER_TEMPLATES_DIR}" ]; then
  for template in "${KARABINER_TEMPLATES_DIR}"/*.erb; do
    [ -f "${template}" ] || continue
    target="${KARABINER_RULES_DIR}/$(basename "${template}" .erb)"
    if [ ! -f "${target}" ]; then
      mkdir -p "${KARABINER_RULES_DIR}"
      erb "${template}" >"${target}"
    fi
  done
  unset template target
fi
