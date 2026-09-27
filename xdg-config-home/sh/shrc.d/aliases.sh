# shellcheck shell=sh

# Easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Fool-proof aliases
alias rm='command rm -i'
alias mv='command mv -i'
alias cp='command cp -i'
alias ln='command ln -i'

# Colorize `ls`
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lha'

# Colorize `grep`
alias grep='command grep --color=auto'

# third-party commands
command -v git >/dev/null 2>&1 && alias g='command git'
command -v bat >/dev/null 2>&1 && alias cat='command bat -pp'
[ "${LC_TERMINAL_GLYPHS:-ascii}" = "nerdfont" ] && command -v lsd >/dev/null 2>&1 && alias ls='command lsd'
[ "${TERM_PROGRAM:-}" = "WezTerm" ] && alias imgcat='wezterm imgcat'

# Cross-platform open and xdg-open
if [ "$(uname -s || true)" = "Darwin" ]; then
  alias xdg-open='open'
elif ! command -v open >/dev/null 2>&1; then
  if command -v xdg-open >/dev/null 2>&1; then
    alias open='xdg-open'
  else
    case $(uname) in
      MSYS* | MINGW*)
        alias open='command start'
        alias xdg-open='command start'
        ;;
      *) ;;
    esac
  fi
fi

# Reload shell
alias reload='exec ${SHELL} --login'
