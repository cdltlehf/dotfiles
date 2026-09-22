# shellcheck shell=sh
#
# Reference: https://brew.sh
# Reference: https://deno.com
# Reference: https://github.com/Misterio77/flavours
# Reference: https://github.com/conda-forge/miniforge
# Reference: https://github.com/eth-p/bat-extras
# Reference: https://github.com/junegunn/fzf
# Reference: https://github.com/nvm-sh/nvm
# Reference: https://github.com/pyenv/pyenv
# Reference: https://github.com/rust-lang/rustup
# Reference: https://mamba.readthedocs.io
# Reference: https://src.fedoraproject.org/rpms/setup/blob/rawhide/f/profile
# Reference: https://volta.sh
# Reference: https://wezfurlong.org/wezterm/shell-integration.html
# Reference: https://www.haskell.org/ghcup

###############################################################################
# XDG Base Directories
###############################################################################
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

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
export XDG_TEMPLATES_DIR="${XDG_CONFIG_HOME}/templates"

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
# Homebrew
###############################################################################
export HOMEBREW_NO_ENV_HINTS=1
if [ -z "${HOMEBREW_PREFIX:-}" ] && [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

###############################################################################
# PATH & Miscellaneous
###############################################################################
pathmunge() {
  [ -h "$1" ] && return

  case ":${PATH}:" in
    *":$1:"*) ;;
    *)
      if [ "$2" = "after" ]; then
        PATH="${PATH:+${PATH}:}$1"
      else
        PATH="$1${PATH:+:${PATH}}"
      fi
      ;;
  esac
}

pathmunge "${HOME}/.local/bin"
pathmunge "${HOME}/.local/share/mise/shims"
export PATH
unset -f pathmunge

###############################################################################
# FZF
###############################################################################
case "${LC_TERMINAL_GLYPHS:-ascii}" in
  nerdfont)
    fzf_prompt=" "
    fzf_pointer=""
    fzf_ellipsis="…"
    ;;
  unicode)
    fzf_prompt="❯ "
    fzf_pointer="❯"
    fzf_ellipsis="…"
    ;;
  *)
    fzf_prompt="> "
    fzf_pointer=">"
    fzf_ellipsis=".."
    ;;
esac

export FZF_DEFAULT_OPTS="\
  --height=8 \
  --style=minimal \
  --prompt=\"${fzf_prompt}\" \
  --pointer=\"${fzf_pointer}\" \
  --marker=\"+\" \
  --ellipsis=\"${fzf_ellipsis}\" \
  --color=16,prompt:blue,pointer:green,marker:green,info:8,hl:cyan,hl+:cyan:underline
"
unset fzf_prompt fzf_pointer fzf_ellipsis
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

export LS_COLORS="di=34:ln=36:ex=32:so=35:pi=33:bd=33:cd=33:su=31:sg=31:tw=34:ow=34:st=34:or=31:mi=31"
export LSCOLORS="exfxcxdxbxegedabagacad"

###############################################################################
# WezTerm
###############################################################################
SHELL_INTEGRATION="${XDG_DATA_HOME:-$HOME/.local/share}/wezterm/shell-integration/wezterm.sh"
# shellcheck source=/dev/null
[ -f "${SHELL_INTEGRATION}" ] && . "${SHELL_INTEGRATION}"
unset SHELL_INTEGRATION
