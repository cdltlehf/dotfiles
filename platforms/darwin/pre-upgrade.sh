#!/bin/bash

: "${__DOTFILES_UPGRADE:?Do not run directly}"

softwareupdate --list 2>/dev/null || true
