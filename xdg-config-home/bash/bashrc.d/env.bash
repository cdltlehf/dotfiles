export VIRTUAL_ENV_DISABLE_PROMPT=1
[[ "$(uname -s)" == "Darwin" ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# shellcheck source=/dev/null
source "$NVM_DIR/bash_completion" 2>/dev/null
# https://github.com/junegunn/fzf
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
command -v wezterm >/dev/null 2>&1 && eval "$(wezterm shell-completion --shell bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"
