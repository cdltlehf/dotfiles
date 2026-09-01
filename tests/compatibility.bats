#!/usr/bin/env bats
# shellcheck shell=bash
# Reference: https://bats-core.readthedocs.io/
#
# Test Anything Protocol (TAP) v13 test suite for dotfiles compatibility baseline.

# shellcheck disable=SC2329
version_ge() { printf '%s\n%s\n' "$2" "$1" | sort -V -C; }

@test "vim >= 9.1"   { version_ge "$(vim --version | awk 'NR==1{print $5}')" 9.1; }
@test "nvim >= 0.10" { version_ge "$(nvim --version | awk 'NR==1{print $2}' | tr -d v)" 0.10; }
@test "git >= 2.38"  { version_ge "$(git --version | awk '{print $3}')" 2.38; }
@test "tmux >= 3.2"  { version_ge "$(tmux -V | awk '{print $2}')" 3.2; }
@test "zsh >= 5.8"   { zsh -c 'autoload -Uz is-at-least && is-at-least 5.8 $ZSH_VERSION'; }
