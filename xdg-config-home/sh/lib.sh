# shellcheck shell=sh
#
# Reference: https://src.fedoraproject.org/rpms/setup/blob/rawhide/f/profile
# Reference: https://github.com/mroth/evalcache

__pathmunge() {
  [ -d "$1" ] || return 0

  # Remove existing occurrences of $1 from PATH
  _clean_p=":${PATH}:"
  while true; do
    case "${_clean_p}" in
      *":$1:"*) _clean_p="${_clean_p%%:"$1":*}:${_clean_p#*:"$1":}" ;;
      *) break ;;
    esac
  done
  _clean_p="${_clean_p#:}"
  PATH="${_clean_p%:}"
  unset _clean_p

  if [ "${2:-}" = "after" ]; then
    PATH="${PATH:+${PATH}:}$1"
  else
    PATH="$1${PATH:+:${PATH}}"
  fi
}

__cached() {
  command -v "$1" >/dev/null 2>&1 || return 0
  _bin="$(command -v "$1" 2>/dev/null)"
  _sum="$(printf '%s' "$*" | cksum)"
  _cache="${XDG_CACHE_HOME:-${HOME}/.cache}/evalcache/${1##*/}-${_sum%% *}.sh"

  if [ ! -s "${_cache}" ] || [ "${_bin}" -nt "${_cache}" ]; then
    mkdir -p "${_cache%/*}"
    _tmp="${_cache}.$$.tmp"
    if "$@" >"${_tmp}" 2>/dev/null && [ -s "${_tmp}" ]; then
      mv -f "${_tmp}" "${_cache}"
    else
      rm -f "${_tmp}"
    fi
    unset _tmp
  fi

  # shellcheck source=/dev/null
  [ -s "${_cache}" ] && . "${_cache}"
  unset _bin _sum _cache
}

__detect_os() {
  uname -s | tr '[:upper:]' '[:lower:]'
}

__detect_arch() {
  uname -m | tr '[:upper:]' '[:lower:]'
}
