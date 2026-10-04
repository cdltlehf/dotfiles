#!/usr/bin/env bats
# shellcheck shell=bash
#
# Reference: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
# Reference: https://zsh.sourceforge.io/Doc/Release/Files.html

setup() {
  export TRACE_SCRIPT="${BATS_TEST_DIRNAME:-.}/../scripts/trace"
}

# Asserts that the first colon-separated list contains the second colon-separated list
# as a subsequence. Subsequence matching is required because machine-specific directories
# and system files vary, whereas the dotfiles ordering contract MUST remain invariant.
assert_subsequence() {
  local IFS=":"
  # shellcheck disable=SC2086,SC2206
  local -a actual=($1)
  # shellcheck disable=SC2086
  set -- $2
  for item in "${actual[@]}"; do
    [[ "${item}" == "$1" ]] && shift
    [[ $# -eq 0 ]] && break
  done
  [[ $# -eq 0 ]]
}

@test "trace: bash login" {
  local expected="${HOME}/.bash_profile"
  expected="${expected}:${HOME}/.profile"
  expected="${expected}:${HOME}/.bashrc"
  expected="${expected}:${HOME}/.config/sh/shrc"
  expected="${expected}:${HOME}/.config/sh/shrc.d/aliases.sh"
  expected="${expected}:${HOME}/.config/bash/bashrc.d/bash_prompt.bash"

  run "${TRACE_SCRIPT}" bash
  [[ "${status}" -eq 0 ]]
  assert_subsequence "${output}" "${expected}"
}

@test "trace: zsh login" {
  local expected="${HOME}/.config/zsh/.zprofile"
  expected="${expected}:${HOME}/.profile"
  expected="${expected}:${HOME}/.config/zsh/.zshrc"
  expected="${expected}:${HOME}/.config/sh/shrc"
  expected="${expected}:${HOME}/.config/sh/shrc.d/aliases.sh"
  expected="${expected}:${HOME}/.config/zsh/zshrc.d/completion.zsh"
  expected="${expected}:${HOME}/.config/zsh/zshrc.d/env.zsh"
  expected="${expected}:${HOME}/.config/zsh/zshrc.d/history.zsh"
  expected="${expected}:${HOME}/.config/zsh/zshrc.d/zsh_prompt.zsh"

  run "${TRACE_SCRIPT}" zsh
  [[ "${status}" -eq 0 ]]
  assert_subsequence "${output}" "${expected}"
}

@test "trace: bash non-login" {
  local expected="${HOME}/.bashrc"
  expected="${expected}:${HOME}/.config/sh/shrc"
  expected="${expected}:${HOME}/.config/sh/shrc.d/aliases.sh"

  run "${TRACE_SCRIPT}" bash -i
  [[ "${status}" -eq 0 ]]
  [[ "${output}" != *"${HOME}/.bash_profile"* ]]
  [[ "${output}" != *"${HOME}/.profile"* ]]
  assert_subsequence "${output}" "${expected}"
}

@test "trace: zsh non-login" {
  local expected="${HOME}/.config/zsh/.zshrc"
  expected="${expected}:${HOME}/.config/sh/shrc"
  expected="${expected}:${HOME}/.config/sh/shrc.d/aliases.sh"

  run "${TRACE_SCRIPT}" zsh -i
  [[ "${status}" -eq 0 ]]
  [[ "${output}" != *"${HOME}/.config/zsh/.zprofile"* ]]
  [[ "${output}" != *"${HOME}/.profile"* ]]
  assert_subsequence "${output}" "${expected}"
}

@test "trace: bash path" {
  local brew_bin="${HOMEBREW_PREFIX:-/opt/homebrew}/bin"
  local expected="${HOME}/.local/bin"
  expected="${expected}:${HOME}/.local/share/mise/shims"
  expected="${expected}:${brew_bin}"
  expected="${expected}:/usr/bin"

  local path_out
  path_out="$(bash -l -c 'echo "${PATH}"')"
  assert_subsequence "${path_out}" "${expected}"
}

@test "trace: zsh path" {
  local brew_bin="${HOMEBREW_PREFIX:-/opt/homebrew}/bin"
  local expected="${HOME}/.local/bin"
  expected="${expected}:${HOME}/.local/share/mise/shims"
  expected="${expected}:${brew_bin}"
  expected="${expected}:/usr/bin"

  local path_out
  path_out="$(zsh -l -c 'echo "${PATH}"')"
  assert_subsequence "${path_out}" "${expected}"
}
