#!/bin/bash
# shellcheck source=/dev/null

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#bash-completion
# https://github.com/junegunn/fzf

. "$NVM_DIR/bash_completion" 2> /dev/null
command -v fzf > /dev/null && eval "$(fzf --bash)"
# https://github.com/ajeetdsouza/zoxide
# if command -v zoxide > /dev/null 2>&1; then eval "$(zoxide init bash)"; fi
# https://github.com/pyenv/pyenv
# if command -v pyenv > /dev/null 2>&1; then eval "$(pyenv init - bash)"; fi
