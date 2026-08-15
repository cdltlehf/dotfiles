if command -v brew >/dev/null 2>&1; then
  local brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  [[ -d "${brew_prefix}/share/zsh/site-functions" ]] && fpath=("${brew_prefix}/share/zsh/site-functions" $fpath)
fi

fpath=(
  "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
  "${XDG_DATA_HOME:-$HOME/.local/share}/mise/completions"
  $fpath
)

[[ -d "${XDG_CACHE_HOME}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME}/zsh"
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
