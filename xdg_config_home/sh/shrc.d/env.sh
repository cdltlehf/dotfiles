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
# https://mamba.readthedocs.io/

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
export MAMBA_EXE="${HOME}/.local/bin/micromamba";

###############################################################################
# Update PATH, PKG_CONFIG_PATH, LD_LIBRARY_PATH
###############################################################################
BIN_DIRS="$(find ${HOME}/.local/opt -maxdepth 3 -type d -name bin 2> /dev/null || true)"
for bin_dir in ${BIN_DIRS}; do
  PATH="${bin_dir}:${PATH}"
done
unset BIN_DIRS bin_dir

PKG_CONFIG_DIRS="$(find ${HOME}/.local/opt -maxdepth 3 -type d -name pkgconfig 2> /dev/null || true)"
for pkg_config_dir in ${PKG_CONFIG_DIRS}; do
  PKG_CONFIG_PATH="${pkg_config_dir}:${PKG_CONFIG_PATH}"
done
unset PKG_CONFIG_DIRS pkg_config_dir

LD_LIBRARY_DIRS="$(find ${HOME}/.local/opt -maxdepth 3 -type d -name lib 2> /dev/null || true)"
LD_LIBRARY_DIRS="${LD_LIBRARY_DIRS} $(find ${HOME}/.local/opt -maxdepth 2 -type d -name lib64 2> /dev/null || true)"
for ld_library_dir in ${LD_LIBRARY_DIRS}; do
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ld_library_dir}"
done
unset LD_LIBRARY_DIRS ld_library_dir

if command -v tr > /dev/null && command -v awk > /dev/null && command -v paste > /dev/null; then
  PATH="$(echo "$PATH" | tr ':' '\n' | awk '!seen[$1]++' | paste -sd:)"
  LD_LIBRARY_PATH="$(echo "$LD_LIBRARY_PATH" | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)"
  PKG_CONFIG_PATH="$(echo "$PKG_CONFIG_PATH" | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)"
fi
export PATH
export PKG_CONFIG_PATH
export LD_LIBRARY_PATH

###############################################################################
# Shell integrations
# For shell-specific scripts, see `${XDG_CONFIG_HOME}/${SHELL}/${SHELL}rc.d/`
###############################################################################
# . "$HOME/.ghcup/env" 2> /dev/null || true
# command -v pyenv > eval "$(pyenv init --path)" > /dev/null 2>&1 || true
command -v batman > /dev/null && eval "$(batman --export-env)"
source "${MINIFORGE_HOME}/etc/profile.d/conda.sh" > /dev/null 2>&1 || true
