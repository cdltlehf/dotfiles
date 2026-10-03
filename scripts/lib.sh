#!/bin/sh

err() {
  printf "%s\n" "$*" >&2
}

die() {
  err "$*"
  exit 1
}

detect_os() {
  uname -s | tr '[:upper:]' '[:lower:]'
}

detect_arch() {
  uname -m | tr '[:upper:]' '[:lower:]'
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
      err "Warning: failed to download ${_url}"
      [ "${_dest}" = "-" ] || rm -f "${_dest}"
      unset _url _dest _mode
      return 0
    fi
  elif has wget; then
    if ! wget -q -O "${_dest}" "${_url}"; then
      err "Warning: failed to download ${_url}"
      [ "${_dest}" = "-" ] || rm -f "${_dest}"
      unset _url _dest _mode
      return 0
    fi
  else
    err "Warning: neither curl nor wget is available to download ${_url}"
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
