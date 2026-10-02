#!/usr/bin/env bats
# shellcheck shell=bash
# shellcheck disable=SC2016,SC2154
# Reference: https://bats-core.readthedocs.io/

setup() {
  export TEST_REPO_DIR="${BATS_TEST_DIRNAME:-.}/.."
  export XDG_CONFIG_HOME="${TEST_REPO_DIR}/xdg-config-home"
  export HOMEBREW_PREFIX="/opt/homebrew"
}

@test "startup: zsh login shell orders PATH correctly" {
  local path_val
  path_val="$(env -i HOME="${HOME}" PATH="/usr/bin:/bin" zsh -l -c 'echo "${PATH}"')"
  # mise shims and .local/bin must precede homebrew, which must precede /usr/bin
  [[ "${path_val}" =~ ^([^:]*\.local/share/mise/shims):([^:]*\.local/bin):(/opt/homebrew/bin):.*:/usr/bin: ]]
}

@test "startup: zsh non-login shell orders PATH correctly" {
  local path_val
  path_val="$(env -i HOME="${HOME}" PATH="/usr/bin:/bin" zsh -c 'echo "${PATH}"')"
  [[ "${path_val}" =~ ^([^:]*\.local/share/mise/shims):([^:]*\.local/bin):(/opt/homebrew/bin):.*:/usr/bin: ]]
}

@test "startup: bash login shell orders PATH correctly" {
  local path_val
  path_val="$(env -i HOME="${HOME}" PATH="/usr/bin:/bin" bash -l -c 'echo "${PATH}"')"
  [[ "${path_val}" =~ ^([^:]*\.local/share/mise/shims):([^:]*\.local/bin):(/opt/homebrew/bin):.*:/usr/bin: ]]
}

@test "startup: posix sh login shell orders PATH correctly" {
  local path_val
  path_val="$(env -i HOME="${HOME}" PATH="/usr/bin:/bin" sh -l -c 'echo "${PATH}"')"
  [[ "${path_val}" =~ ^([^:]*\.local/share/mise/shims):([^:]*\.local/bin):(/opt/homebrew/bin):.*:/usr/bin: ]]
}
