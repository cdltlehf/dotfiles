#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
  export XDG_CONFIG_HOME="${BATS_TEST_DIRNAME:-.}/../xdg-config-home"
}

@test "zsh: idempotency" {
  local run1 run2
  run1="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -c '. "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  run2="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -c '. "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  [[ "${run1}" = "${run2}" ]]
}

@test "bash: idempotency" {
  local run1 run2
  run1="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" bash -c 'shopt -s expand_aliases; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  run2="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" bash -c 'shopt -s expand_aliases; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  [[ "${run1}" = "${run2}" ]]
}
