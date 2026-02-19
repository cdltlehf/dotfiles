#!/bin/bash
# shellcheck source=/dev/null

# https://github.com/junegunn/fzf
# https://github.com/nvm-sh/nvm?tab=readme-ov-file#bash-completion

export VIRTUAL_ENV_DISABLE_PROMPT=1
[ "$(uname -s)" == 'Darwin' ] && export BASH_SILENCE_DEPRECATION_WARNING=1

source "$NVM_DIR/bash_completion" 2> /dev/null
command -v fzf > /dev/null 2>&1 && eval "$(fzf --bash)"
command -v wezterm > /dev/null 2>&1 && eval "$(wezterm shell-completion --shell bash)"

# https://github.com/ajeetdsouza/zoxide
# if command -v zoxide > /dev/null 2>&1; then eval "$(zoxide init bash)"; fi
# https://github.com/pyenv/pyenv
# if command -v pyenv > /dev/null 2>&1; then eval "$(pyenv init - bash)"; fi
