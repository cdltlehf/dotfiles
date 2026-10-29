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
readonly DEFAULTS_DIR="${BASE_DIR}/platforms/darwin/defaults"
readonly SHORTCUTS_DIR="${BASE_DIR}/platforms/darwin/shortcuts"
readonly KARABINER_TEMPLATES_DIR="${BASE_DIR}/xdg-config-home/karabiner/templates"
readonly KARABINER_RULES_DIR="${BASE_DIR}/xdg-config-home/karabiner/assets/complex_modifications"

for script in "${DEFAULTS_DIR}"/*.sh; do
  [ -f "${script}" ] || continue
  "${script}"
done
unset script

/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
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

if [ -d "${VSCODE_USER_DIR}" ] || command -v code >/dev/null; then
  mkdir -p "${VSCODE_USER_DIR}"
  symlink \
    "${XDG_CONFIG_HOME}/vscode/settings.json" \
    "${VSCODE_USER_DIR}/settings.json"
fi
if [ -d "${XDG_CONFIG_HOME}/ubersicht/widgets" ]; then
  mkdir -p "${UBERSICHT_USER_DIR}"
  symlink "${XDG_CONFIG_HOME}/ubersicht/widgets" "${UBERSICHT_USER_DIR}/widgets"
fi

if command -v shortcuts >/dev/null; then
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

if command -v brew >/dev/null && brew list zathura >/dev/null 2>&1; then
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

if command -v erb >/dev/null && [ -d "${KARABINER_TEMPLATES_DIR}" ]; then
  mkdir -p "${KARABINER_RULES_DIR}"
  for template in "${KARABINER_TEMPLATES_DIR}"/*.erb; do
    [ -f "${template}" ] || continue
    target="${KARABINER_RULES_DIR}/$(basename "${template}" .erb)"
    erb "${template}" >"${target}"
  done
  unset template target
fi
