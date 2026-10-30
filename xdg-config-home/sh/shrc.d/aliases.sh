# shellcheck shell=sh

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias rm='command rm -i'
alias mv='command mv -i'
alias cp='command cp -i'
alias ln='command ln -i'

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lha'

alias grep='command grep --color=auto'

command -v git >/dev/null 2>&1 && alias g='command git'
command -v bat >/dev/null 2>&1 && alias cat='command bat -pp'
if [ "${LC_TERMINAL_GLYPHS:-ascii}" = "nerdfont" ] && command -v lsd >/dev/null 2>&1; then
  alias ls='command lsd'
fi
[ "${TERM_PROGRAM:-}" = "WezTerm" ] && alias imgcat='wezterm imgcat'

case "$(__detect_os)" in
  darwin)
    alias xdg-open='open'
    ;;
  msys*)
    alias open='command start'
    alias xdg-open='command start'
    ;;
  *)
    if ! command -v open >/dev/null 2>&1 && command -v xdg-open >/dev/null 2>&1; then
      alias open='xdg-open'
    fi
    ;;
esac

alias reload='exec ${SHELL} --login'
