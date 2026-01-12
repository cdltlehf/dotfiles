# shellcheck shell=sh

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
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lha'

# Colorize `grep`
alias grep='command grep --color=auto'
alias egrep='command egrep --color=auto'
alias fgrep='command fgrep --color=auto'

# third-party commands
command -v git > /dev/null 2>&1 && alias g='command git'
command -v bat > /dev/null 2>&1 && alias cat='command bat -pp'
if [ "${NERD_FONT:=0}" -eq 1 ]; then
  command -v lsd > /dev/null 2>&1 && alias ls='command lsd'
fi

command -v darwin-rebuild > /dev/null && alias darwin-rebuild switch --flake ${XDG_CONFIG_HOME}/nix#"aarch64-darwin"
command -v nix > /dev/null && alias dr='sudo nix run nix-darwin -- switch --flake "${XDG_CONFIG_HOME}/nix#aarch64-darwin"'

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
alias pyvenv='python3 -m venv ./.venv'
alias pyact='source ./.venv/bin/activate'

# Reload shell
alias reload='exec ${SHELL} --login'
