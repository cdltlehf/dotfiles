#!/usr/bin/env bats
# shellcheck shell=bash

assert_version_ge() {
  local name="$1" min="$2" actual="$3"
  if [[ -z "${actual}" ]]; then
    echo "${name}: not installed" >&2
    return 1
  fi
  if ! printf '%s\n%s\n' "${min}" "${actual}" | sort -V -C; then
    echo "${name}: ${actual} < ${min}" >&2
    return 1
  fi
}

readonly VIM_MIN="9.1"
readonly NVIM_MIN="0.10"
readonly GIT_MIN="2.38"
readonly TMUX_MIN="3.2"
readonly ZSH_MIN="5.8"

VIM_VER="$(vim --version | awk 'NR==1{print $5}' || true)"
NVIM_VER="$(nvim --version | awk 'NR==1{sub(/^v/,"",$2); print $2}' || true)"
GIT_VER="$(git --version | awk '{print $3}' || true)"
TMUX_VER="$(tmux -V | awk '{print $2}' || true)"
ZSH_VER="$(zsh --version | awk 'NR==1{print $2}' || true)"
readonly VIM_VER NVIM_VER GIT_VER TMUX_VER ZSH_VER

@test "vim: ${VIM_VER} >= ${VIM_MIN}" { assert_version_ge "vim" "${VIM_MIN}" "${VIM_VER}"; }
@test "nvim: ${NVIM_VER} >= ${NVIM_MIN}" { assert_version_ge "nvim" "${NVIM_MIN}" "${NVIM_VER}"; }
@test "git: ${GIT_VER} >= ${GIT_MIN}" { assert_version_ge "git" "${GIT_MIN}" "${GIT_VER}"; }
@test "tmux: ${TMUX_VER} >= ${TMUX_MIN}" { assert_version_ge "tmux" "${TMUX_MIN}" "${TMUX_VER}"; }
@test "zsh: ${ZSH_VER} >= ${ZSH_MIN}" { assert_version_ge "zsh" "${ZSH_MIN}" "${ZSH_VER}"; }
