# shellcheck shell=sh
# Reference: https://github.com/mroth/evalcache

mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

cdls() {
  cd "$1" && ls -lA
}

cached() {
  _bin="$(command -v "$1" 2>/dev/null)" || return 0
  _sum="$(printf '%s' "$*" | cksum)"
  _cache="${XDG_CACHE_HOME:-${HOME}/.cache}/evalcache/$1-${_sum%% *}.sh"

  if [ ! -s "${_cache}" ] || [ "${_bin}" -nt "${_cache}" ]; then
    mkdir -p "${_cache%/*}"
    "$@" >"${_cache}" 2>/dev/null || rm -f "${_cache}"
  fi

  # shellcheck source=/dev/null
  [ -s "${_cache}" ] && . "${_cache}"
  unset _bin _sum _cache
}
