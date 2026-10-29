#!/usr/bin/env bats
# shellcheck shell=bash

@test "AGENTS.md: conventions match the template" {
  cd "${BATS_TEST_DIRNAME:-.}/.."
  run sed '/^## This repository$/,$d' AGENTS.md
  [[ "${output}" == "$(<xdg-templates-dir/AGENTS.md)" ]]
}
