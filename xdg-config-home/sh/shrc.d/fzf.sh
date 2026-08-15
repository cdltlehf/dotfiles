# https://github.com/junegunn/fzf
# shellcheck shell=sh

export FZF_DEFAULT_OPTS="\
  --height=8 \
  --style=minimal \
  --color=16
"

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi
