#!/bin/sh

# https://volta.sh
# https://github.com/nvm-sh/nvm
# https://deno.com
# https://github.com/conda-forge/miniforge
# https://github.com/eth-p/bat-extras
# https://github.com/Misterio77/flavours
# https://github.com/pyenv/pyenv
# https://github.com/rust-lang/rustup
# https://www.haskell.org/ghcup
# https://mamba.readthedocs.io
# https://brew.sh

###############################################################################
# XDG_DATA_HOME
###############################################################################
# export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
export LESSHIST="${XDG_DATA_HOME}/less/history"
export MAMBA_ROOT_PREFIX="${XDG_DATA_HOME}/mamba"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export TEXMFHOME="${XDG_DATA_HOME}/texmf"
export TEXMFLOCAL="${XDG_DATA_HOME}/texlive/texmf-local"
export TEXMFSYSCONFIG="${XDG_DATA_HOME}/texlive/texmf-config"
export TEXMFSYSVAR="${XDG_DATA_HOME}/texlive/texmf-var"
export TEXMFVAR="${XDG_DATA_HOME}/texlive/texmf-var"

###############################################################################
# XDG_CONFIG_HOME
###############################################################################
export FLAVOURS_CONFIG_FILE="${XDG_CONFIG_HOME}/flavours/config.toml"
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
export TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config"

###############################################################################
# ~/.local/opt
###############################################################################
export CARGO_HOME="${HOME}/.local/opt/cargo"
export JAVA_HOME="${HOME}/.local/opt/jvm/current"
export MINIFORGE_HOME="${HOME}/.local/opt/miniforge3"
export RUSTUP_HOME="${HOME}/.local/opt/rustup"
export TEXDIR="${HOME}/.local/opt/texlive/2024"
export VOLTA_HOME="${HOME}/.local/opt/volta"

###############################################################################
# ~/.local/bin
###############################################################################
export MISE_SHIMS_DIR="${HOME}/.local/share/mise/shims"
export PATH="${MISE_SHIMS_DIR}:${HOME}/.local/bin:${PATH}"

###############################################################################
# ~/.local/opt
###############################################################################
[ -e /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
