# https://github.com/junegunn/fzf

# shellcheck disable=SC2015
command -v fzf > /dev/null && eval "$(fzf --bash)" || true
