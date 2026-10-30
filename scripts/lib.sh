#!/bin/sh
#
# Reference: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/tput.html
# Reference: https://no-color.org/
# Reference: https://protesilaos.com/emacs/modus-themes-colors

# shellcheck source=xdg-config-home/sh/lib.sh
. "${BASE_DIR:?}/xdg-config-home/sh/lib.sh"

_c_red=''
_c_yellow=''
_c_cyan=''
_c_magenta=''
_c_reset=''

if [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
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

run_hook() {
  _hook="${BASE_DIR}/platforms/${OS:-$(detect_os)}/$1.sh"
  if [ -f "${_hook}" ]; then
    # shellcheck source=/dev/null
    . "${_hook}"
  fi
  unset _hook
}

symlink() {
  _src="$1"
  _dest="$2"
  if [ -n "${__DOTFILES_LINKS:-}" ]; then
    printf '%s\t%s\n' "${_src}" "${_dest}" >>"${__DOTFILES_LINKS}"
  fi
  if [ "$(readlink "${_dest}" 2>/dev/null || true)" != "${_src}" ]; then
    if [ -e "${_dest}" ] || [ -L "${_dest}" ]; then
      mv -f "${_dest}" "${_dest}.$(date +%Y%m%d%H%M%S || true).bak"
    fi
    mkdir -p "$(dirname "${_dest}")"
    ln -s "${_src}" "${_dest}"
  fi
  unset _src _dest
}

download() {
  _url="$1"
  _dest="${2:--}"
  _mode="${3:-}"
  _out="-"
  _failure=""

  if [ "${_dest}" != "-" ]; then
    if [ -n "${__DOTFILES_DOWNLOADS:-}" ]; then
      printf '%s\t%s\t%s\n' "${_url}" "${_dest}" "${_mode}" >>"${__DOTFILES_DOWNLOADS}"
    fi
    if [ -e "${_dest}" ] && [ -z "${__DOTFILES_REFRESH:-}" ]; then
      unset _url _dest _mode _out _failure
      return 0
    fi
    mkdir -p "$(dirname "${_dest}")"
    _out="${_dest}.tmp"
  fi

  if command -v curl >/dev/null; then
    curl -fsSL "${_url}" -o "${_out}" || _failure="Failed to download ${_url}"
  elif command -v wget >/dev/null; then
    wget -q -O "${_out}" "${_url}" || _failure="Failed to download ${_url}"
  else
    _failure="Neither curl nor wget is available to download ${_url}"
  fi

  if [ -n "${_failure}" ]; then
    warning "${_failure}"
    [ "${_out}" = "-" ] || rm -f "${_out}"
  elif [ "${_out}" != "-" ]; then
    [ -z "${_mode}" ] || chmod "${_mode}" "${_out}"
    mv -f "${_out}" "${_dest}"
  fi
  unset _url _dest _mode _out _failure
}
