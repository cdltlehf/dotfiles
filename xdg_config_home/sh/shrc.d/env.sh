# environment variable
# shellcheck shell=sh

# https://volta.sh
export VOLTA_HOME="${XDG_DATA_HOME}/volta"
export PATH="${VOLTA_HOME}/bin:${PATH}"

# https://github.com/nvm-sh/nvm
export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && bash "$NVM_DIR/nvm.sh" --no-use
# shellcheck source=/dev/null
NODE_PATH=$(find "$XDG_DATA_HOME/nvm/versions/node" \
  -maxdepth 2 -name bin -print -quit 2> /dev/null)
[ -n "$NODE_PATH" ] && export PATH="${NODE_PATH}:${PATH}"

# https://deno.com
export PATH="${HOME}/.deno/bin:${PATH}"

# https://github.com/pyenv/pyenv
PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
if command -v pyenv > /dev/null; then
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init --path)"
fi

# https://github.com/rust-lang/rustup
# shellcheck source=/dev/null
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# https://www.haskell.org/ghcup
# shellcheck source=/dev/null
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}"/node_repl_history

# Proxy
export PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

export LESSHIST="$XDG_DATA_HOME/less/history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}"/node_repl_history

# https://github.com/eth-p/bat-extras
command -v batman > /dev/null && eval "$(batman --export-env)"
