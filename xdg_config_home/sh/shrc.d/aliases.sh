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

# Colorize `ls`
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -lha'

if command -v git > /dev/null 2>&1; then
  alias g='git'
fi

# Replace `cat` with `bat`
if command -v bat > /dev/null 2>&1; then
  alias cat='command bat --plain --paging never --wrap character'
  export MANPAGER="command sh -c 'col -bx | bat -l man -p'"
fi

# Replace `ls` with `lsd`
if command -v lsd > /dev/null 2>&1; then
  alias ls='command lsd'
fi

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
alias ve='echo "ve alias is moved to pyenv" 1>&2'
alias va='echo "va alias is moved to pyact" 1>&2'
alias pyenv='python3 -m venv ./.venv'
alias pyact='source ./.venv/bin/activate'
