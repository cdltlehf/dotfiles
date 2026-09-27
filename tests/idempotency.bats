#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
  export XDG_CONFIG_HOME="${BATS_TEST_DIRNAME:-.}/../xdg-config-home"
}

@test "zsh: idempotency across repeated loads" {
  local run1 run2
  run1="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -c '. "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  run2="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -c '. "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/zsh/.zshrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  [[ "${run1}" = "${run2}" ]]
}

@test "bash: idempotency across repeated loads" {
  local run1 run2
  run1="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" bash -c 'shopt -s expand_aliases; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  run2="$(PATH="/usr/bin:/bin:/usr/sbin:/sbin" bash -c 'shopt -s expand_aliases; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/bash/bashrc" >/dev/null 2>&1; alias | sort; echo "PATH:${PATH}"' || true)"
  [[ "${run1}" = "${run2}" ]]
}

@test "sh: PATH has no duplicate entries after multiple loads" {
  local path_entries dup_count
  path_entries="$( (PATH="/usr/bin:/bin:/usr/sbin:/sbin" sh -c '. "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; . "${XDG_CONFIG_HOME}/sh/shrc" >/dev/null; echo "${PATH}"' || true) | tr ":" "\n" || true)"
  dup_count="$( (printf "%s\n" "${path_entries}" | sort | uniq -d | wc -l || true) | tr -d " " || true)"
  [[ "${dup_count}" -eq 0 ]]
}
