#!/bin/sh

set -o nounset
set -o errexit

readonly CONTROL_OPTION=786432
readonly FILL=237
readonly RETURN_TO_PREVIOUS_SIZE=239
readonly LEFT=240
readonly RIGHT=241

key_code() {
  case "$1" in
    h) echo 4 ;;
    j) echo 38 ;;
    k) echo 40 ;;
    l) echo 37 ;;
    *) return 1 ;;
  esac
}

hotkey() {
  _code="$(key_code "$2")"
  _char="$(printf '%d' "'$2")"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "{ enabled = 1; value = { parameters = (${_char}, ${_code}, ${CONTROL_OPTION}); type = standard; }; }"
}

defaults delete com.apple.symbolichotkeys 2>/dev/null || true
hotkey "${FILL}" k
hotkey "${RETURN_TO_PREVIOUS_SIZE}" j
hotkey "${LEFT}" h
hotkey "${RIGHT}" l
