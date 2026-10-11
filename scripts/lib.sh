#!/bin/sh
#
# Reference: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/tput.html
# Reference: https://no-color.org
# Reference: https://protesilaos.com/emacs/modus-themes-colors

_scripts_base_dir="${BASE_DIR:-}"
if [ -z "${_scripts_base_dir}" ]; then
  if [ -f "./xdg-config-home/sh/lib.sh" ]; then
    _scripts_base_dir="$(pwd)"
  elif [ -f "../xdg-config-home/sh/lib.sh" ]; then
    _scripts_base_dir="$(cd .. && pwd)"
  else
    _scripts_base_dir="$(cd "$(dirname "$0")/.." && pwd)"
  fi
fi
# shellcheck source=xdg-config-home/sh/lib.sh
if [ -f "${_scripts_base_dir}/xdg-config-home/sh/lib.sh" ]; then
  . "${_scripts_base_dir}/xdg-config-home/sh/lib.sh"
fi
unset _scripts_base_dir

_c_red=''
_c_yellow=''
_c_cyan=''
_c_magenta=''
_c_reset=''

if [ -z "${NO_COLOR:-}" ] && [ -n "${TERM:-}" ] && [ "${TERM}" != "dumb" ]; then
  if command -v tput >/dev/null 2>&1; then
    _ncolors="$(tput colors 2>/dev/null || echo 0)"
    if [ "${_ncolors}" -ge 8 ] 2>/dev/null; then
      _c_red="$(tput setaf 1 2>/dev/null || true)"
      _c_yellow="$(tput setaf 3 2>/dev/null || true)"
      _c_cyan="$(tput setaf 6 2>/dev/null || true)"
      _c_magenta="$(tput setaf 5 2>/dev/null || true)"
      _c_reset="$(tput sgr0 2>/dev/null || true)"
    fi
    unset _ncolors
  fi
fi

error() {
  if [ -t 2 ]; then
    printf '%s[ERROR]%s %s\n' "${_c_red}" "${_c_reset}" "$*" >&2
  else
    printf '[ERROR] %s\n' "$*" >&2
  fi
}

warning() {
  if [ -t 2 ]; then
    printf '%s[WARN]%s  %s\n' "${_c_yellow}" "${_c_reset}" "$*" >&2
  else
    printf '[WARN]  %s\n' "$*" >&2
  fi
}

info() {
  if [ -t 1 ]; then
    printf '%s[INFO]%s  %s\n' "${_c_cyan}" "${_c_reset}" "$*"
  else
    printf '[INFO]  %s\n' "$*"
  fi
}

debug() {
  if [ "${DEBUG:-0}" = "1" ]; then
    if [ -t 2 ]; then
      printf '%s[DEBUG]%s %s\n' "${_c_magenta}" "${_c_reset}" "$*" >&2
    else
      printf '[DEBUG] %s\n' "$*" >&2
    fi
  fi
}

die() {
  error "$@"
  exit 1
}

detect_os() {
  __detect_os
}

detect_arch() {
  __detect_arch
}

has() {
  command -v "$1" >/dev/null 2>&1
}

run_hook() {
  _phase="$1"
  _base_dir="${BASE_DIR:-}"
  _os="${OS:-$(detect_os)}"

  if [ -n "${_base_dir}" ] && [ -n "${_os}" ]; then
    if [ -f "${_base_dir}/platforms/${_os}/${_phase}.sh" ]; then
      # shellcheck source=/dev/null
      . "${_base_dir}/platforms/${_os}/${_phase}.sh"
    fi
  fi

  unset _phase _base_dir _os
}

symlink() {
  _src="$1"
  _dest="$2"
  if [ "$(readlink "${_dest}" 2>/dev/null || true)" = "${_src}" ]; then
    unset _src _dest
    return 0
  fi
  if [ -e "${_dest}" ] || [ -L "${_dest}" ]; then
    mv -f "${_dest}" "${_dest}.$(date +%Y%m%d%H%M%S || true).bak"
  fi
  mkdir -p "$(dirname "${_dest}")"
  ln -s "${_src}" "${_dest}"
  unset _src _dest
}

download() {
  _url="$1"
  _dest="${2:--}"
  _mode="${3:-}"

  if [ "${_dest}" != "-" ]; then
    if [ -e "${_dest}" ]; then
      unset _url _dest _mode
      return 0
    fi
    mkdir -p "$(dirname "${_dest}")"
  fi

  # shellcheck disable=SC2310
  if has curl; then
    if ! curl -fsSL "${_url}" -o "${_dest}"; then
      warning "Failed to download ${_url}"
      [ "${_dest}" = "-" ] || rm -f "${_dest}"
      unset _url _dest _mode
      return 0
    fi
  elif has wget; then
    if ! wget -q -O "${_dest}" "${_url}"; then
      warning "Failed to download ${_url}"
      [ "${_dest}" = "-" ] || rm -f "${_dest}"
      unset _url _dest _mode
      return 0
    fi
  else
    warning "Neither curl nor wget is available to download ${_url}"
    [ "${_dest}" = "-" ] || rm -f "${_dest}"
    unset _url _dest _mode
    return 0
  fi

  if [ "${_dest}" != "-" ] && [ -n "${_mode}" ]; then
    chmod "${_mode}" "${_dest}"
  fi
  unset _url _dest _mode
}

prompt() {
  _message="$1"
  _default="${2:-}"
  _value=""

  if [ -n "${_default}" ]; then
    printf "%s [%s]: " "${_message}" "${_default}" >&2
  else
    printf "%s: " "${_message}" >&2
  fi
  if ! read -r _value; then
    unset _message _default _value
    return 1
  fi
  printf "%s\n" "${_value:-${_default}}"
  unset _message _default _value
}
