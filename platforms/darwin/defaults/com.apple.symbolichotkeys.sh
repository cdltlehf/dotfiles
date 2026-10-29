#!/bin/sh

set -o nounset
set -o errexit

readonly CONTROL_OPTION=786432

hotkey() {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "{ enabled = 1; value = { parameters = ($2, $3, ${CONTROL_OPTION}); type = standard; }; }"
}

defaults delete com.apple.symbolichotkeys 2>/dev/null || true
hotkey 237 107 40 # Fill: k
hotkey 239 106 38 # Return to Previous Size: j
hotkey 240 104 4  # Left: h
hotkey 241 108 37 # Right: l
