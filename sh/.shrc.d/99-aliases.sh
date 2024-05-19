#!/bin/sh

# Easier navigation
alias ..='command cd ..'
alias ...='command cd ../..'
alias ....='command cd ../../..'
alias .....='command cd ../../../..'

# Fool-proof aliases
alias rm='command rm -i'
alias mv='command mv -i'
alias cp='command cp -i'
alias ln='command ln -i'

# Replace `cat` with `bat`
if command -v bat > /dev/null 2>&1; then
  alias cat='command bat --plain --paging never --wrap character'
  export MANPAGER="command sh -c 'col -bx | bat -l man -p'"
fi

# Colorize `ls` & Replace `ls` with `lsd`
# Lsd
if command -v bat > /dev/null 2>&1; then
  alias ls='command lsd'
  alias lsd="command ls -lF --color=always --icon=always | grep --color=never '^[^\.]'"
else
  alias ls='command ls --color=auto'
  alias lsd='command ls -lF | grep --color=never '\''^d'\'''
fi
alias l='command ls -lFh'
alias la='command ls -lFAh'

# Colorize `grep`
alias grep='command grep --color=auto'
alias egrep='command egrep --color=auto'
alias fgrep='command fgrep --color=auto'

# Reload the shell as login shell
alias reload='exec ${SHELL} --login'

# open command
if ! command -v open > /dev/null 2>&1; then
  case $(uname) in
    MSYS*)
      alias open='command start'
      ;;
    *) ;;
  esac
fi

# Python virtual environment
alias ve='python3 -m venv ./.venv'
alias va='source ./.venv/bin/activate'

# Tmux alias
alias tm='tmux'
alias ta='tmux a'

jpt() {
  # shellcheck disable=SC2046
  jupyter notebook \
    --no-browser \
    --ip=0.0.0.0 \
    --port="$1" $(printf '%s' "$@" | cut -d ' ' -f 2- || true)
}

# Print PATH entries
# FIXME
case $0 in
  *zsh)
    alias path='printf \"${PATH:gs/:/\\n}\\n\"'
    ;;
  *bash)
    alias path='printf \"${PATH//:/\\n}\\n\"'
    ;;
  *) ;;
esac
