#!/usr/bin/env bats
# shellcheck shell=bash
# shellcheck disable=SC2016,SC2154,SC2292,SC2312

PATH_ORDER_REGEX='^([^:]*\.local/share/mise/shims):([^:]*\.local/bin):(/opt/homebrew/bin):.*:/usr/bin:'

setup() {
  export TEST_REPO_DIR="${BATS_TEST_DIRNAME:-.}/.."
  export XDG_CONFIG_HOME="${TEST_REPO_DIR}/xdg-config-home"
  export HOMEBREW_PREFIX="/opt/homebrew"
}

get_clean_path() {
  env -i HOME="${HOME}" XDG_CONFIG_HOME="${XDG_CONFIG_HOME}" PATH="/usr/bin:/bin" "$@" -c 'echo "${PATH}"'
}

@test "startup: zsh login shell orders PATH correctly" {
  [[ "$(get_clean_path zsh -l)" =~ ${PATH_ORDER_REGEX} ]]
}

@test "startup: zsh non-login shell orders PATH correctly" {
  [[ "$(get_clean_path zsh)" =~ ${PATH_ORDER_REGEX} ]]
}

@test "startup: bash login shell orders PATH correctly" {
  [[ "$(get_clean_path bash -l)" =~ ${PATH_ORDER_REGEX} ]]
}

@test "startup: posix sh login shell orders PATH correctly" {
  [[ "$(get_clean_path sh -l)" =~ ${PATH_ORDER_REGEX} ]]
}

@test "startup: zsh executes files in expected subsequence" {
  local trace_out
  trace_out="$("${TEST_REPO_DIR}/scripts/trace" zsh -l -i)"

  local expected=(
    "/etc/zprofile"
    "${XDG_CONFIG_HOME}/zsh/.zprofile"
    "${HOME}/.profile"
    "${XDG_CONFIG_HOME}/sh/env.sh"
    "/etc/zshrc"
    "${XDG_CONFIG_HOME}/zsh/.zshrc"
    "${XDG_CONFIG_HOME}/sh/shrc"
    "${XDG_CONFIG_HOME}/zsh/zshrc.d/env.zsh"
  )

  local pattern
  pattern="$(
    IFS='*'
    printf '.*%s' "${expected[*]}"
  )"
  [[ "${trace_out}" =~ ${pattern} ]]
  [ "$(grep -c "${XDG_CONFIG_HOME}/sh/env.sh" <<<"${trace_out}")" -eq 1 ]
  [ "$(grep -c "${XDG_CONFIG_HOME}/sh/shrc$" <<<"${trace_out}")" -eq 1 ]
}

@test "startup: bash executes files in expected subsequence" {
  local trace_out
  trace_out="$("${TEST_REPO_DIR}/scripts/trace" bash -l -i)"

  local expected=(
    "/etc/bashrc"
    "${HOME}/.profile"
    "${XDG_CONFIG_HOME}/sh/env.sh"
    "${HOME}/.bashrc"
    "${XDG_CONFIG_HOME}/sh/shrc"
    "${XDG_CONFIG_HOME}/bash/bashrc.d/env.bash"
  )

  local pattern
  pattern="$(
    IFS='*'
    printf '.*%s' "${expected[*]}"
  )"
  [[ "${trace_out}" =~ ${pattern} ]]
  [ "$(grep -c "${XDG_CONFIG_HOME}/sh/env.sh" <<<"${trace_out}")" -eq 1 ]
  [ "$(grep -c "${XDG_CONFIG_HOME}/sh/shrc$" <<<"${trace_out}")" -eq 1 ]
}

@test "startup: posix sh executes files in expected subsequence" {
  local trace_out
  trace_out="$("${TEST_REPO_DIR}/scripts/trace" sh -l -i)"

  local expected=(
    "/etc/bashrc"
    "${XDG_CONFIG_HOME}/sh/env.sh"
  )

  local pattern
  pattern="$(
    IFS='*'
    printf '.*%s' "${expected[*]}"
  )"
  [[ "${trace_out}" =~ ${pattern} ]]
  [ "$(grep -c "${XDG_CONFIG_HOME}/sh/env.sh" <<<"${trace_out}")" -eq 1 ]
}
