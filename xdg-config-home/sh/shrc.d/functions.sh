# shellcheck shell=sh

mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

cdls() {
  cd "$1" && ls -lA
}
