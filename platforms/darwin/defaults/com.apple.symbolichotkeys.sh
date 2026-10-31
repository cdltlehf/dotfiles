#!/bin/sh

set -o nounset
set -o errexit

readonly CONTROL=262144
readonly CONTROL_OPTION=786432

readonly MISSION_CONTROL=32
readonly APPLICATION_WINDOWS=34
readonly MOVE_LEFT_A_SPACE=79
readonly MOVE_RIGHT_A_SPACE=81
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
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>${_char}</integer><integer>${_code}</integer><integer>${CONTROL_OPTION}</integer></array><key>type</key><string>standard</string></dict></dict>"
}

special_hotkey() {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>$2</integer><integer>$3</integer></array><key>type</key><string>standard</string></dict></dict>"
}

special_hotkey "${MISSION_CONTROL}" 126 "${CONTROL}"
special_hotkey "${APPLICATION_WINDOWS}" 125 "${CONTROL}"
special_hotkey "${MOVE_LEFT_A_SPACE}" 123 "${CONTROL}"
special_hotkey "${MOVE_RIGHT_A_SPACE}" 124 "${CONTROL}"

hotkey "${FILL}" k
hotkey "${RETURN_TO_PREVIOUS_SIZE}" j
hotkey "${LEFT}" h
hotkey "${RIGHT}" l
