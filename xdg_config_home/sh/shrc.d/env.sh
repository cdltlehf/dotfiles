# environment variable
# shellcheck shell=sh

# https://volta.sh
# https://github.com/nvm-sh/nvm
# https://deno.com
# https://github.com/conda-forge/miniforge
# https://github.com/eth-p/bat-extras
# https://github.com/Misterio77/flavours
# https://github.com/pyenv/pyenv
# https://github.com/rust-lang/rustup
# https://www.haskell.org/ghcup

export PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

export JAVA_HOME="${HOME}/.local/opt/jvm/current"
export MINIFORGE_HOME="${HOME}/.local/opt/miniforge3"
export TEXDIR="$HOME/.local/opt/texlive/2024"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export TEXMFHOME="${XDG_DATA_HOME}/texmf"
export TEXMFLOCAL="${XDG_DATA_HOME}/texlive/texmf-local"
export TEXMFSYSCONFIG="${XDG_DATA_HOME}/texlive/texmf-config"
export TEXMFSYSVAR="${XDG_DATA_HOME}/texlive/texmf-var"
export TEXMFVAR="${XDG_DATA_HOME}/texlive/texmf-var"
export VOLTA_HOME="${XDG_DATA_HOME}/volta"

export TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config"

# export NVM_DIR="$XDG_DATA_HOME/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && bash "$NVM_DIR/nvm.sh" --no-use
# # shellcheck source=/dev/null
# NODE_PATH=$(find "$XDG_DATA_HOME/nvm/versions/node" \
#   -maxdepth 2 -name bin -print -quit 2> /dev/null)

# https://github.com/pyenv/pyenv
PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
if command -v pyenv > /dev/null; then
  eval "$(pyenv init --path)"
fi

# shellcheck source=/dev/null
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}"/node_repl_history

export LESSHIST="$XDG_DATA_HOME/less/history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}"/node_repl_history

command -v batman > /dev/null && eval "$(batman --export-env)"
export FLAVOURS_CONFIG_FILE="${XDG_CONFIG_HOME}/flavours/config.toml"
export PYENV_ROOT="$HOME/.pyenv"

# PATH="${NODE_PATH}:${PATH}"
# PATH="${PYENV_ROOT}/bin:${PATH}"
# PATH="${XDG_DATA_HOME}/fnm/bin:${PATH}"
PATH="${HOME}/.deno/bin:${PATH}"
PATH="${JAVA_HOME}/bin:${PATH}"
PATH="${MINIFORGE_HOME}/bin:${PATH}"
PATH="${VOLTA_HOME}/bin:${PATH}"
PATH="${CARGO_HOME}/bin:${PATH}"

PATH=$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)
export PATH
