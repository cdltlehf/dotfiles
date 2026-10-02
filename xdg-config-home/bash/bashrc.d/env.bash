# Reference: https://github.com/ajeetdsouza/zoxide

export VIRTUAL_ENV_DISABLE_PROMPT=1

[[ "$(uname -s || true)" == "Darwin" ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# shellcheck source=/dev/null
[[ -n "${NVM_DIR:-}" ]] && source "${NVM_DIR}/bash_completion" 2>/dev/null
cached fzf --bash
cached wezterm shell-completion --shell bash
cached zoxide init bash --cmd cd
