# Reference: https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
# Reference: https://zsh.sourceforge.io/Doc/Release/Parameters.html
# Reference: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# Reference: https://docs.brew.sh/Shell-Completion

typeset -U fpath

_brew_prefix="${HOMEBREW_PREFIX:-}"
if [[ -z "${_brew_prefix}" ]] && command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix 2>/dev/null)"
fi
if [[ -n "${_brew_prefix}" && -d "${_brew_prefix}/share/zsh/site-functions" ]]; then
  fpath=("${_brew_prefix}/share/zsh/site-functions" $fpath)
fi
unset _brew_prefix

fpath=(
  "${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/site-functions"
  "${XDG_DATA_HOME:-${HOME}/.local/share}/mise/completions"
  $fpath
)

_comp_cache="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
mkdir -p "${_comp_cache}"
autoload -Uz compinit
compinit -d "${_comp_cache}/zcompdump-${ZSH_VERSION}"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${_comp_cache}/zcompcache"
unset _comp_cache
