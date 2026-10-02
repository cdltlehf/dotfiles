#!/usr/bin/env bats
# shellcheck shell=bash
# shellcheck disable=SC2016,SC2154,SC2292,SC2312
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
