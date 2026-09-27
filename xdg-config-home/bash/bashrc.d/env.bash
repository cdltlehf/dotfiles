# Reference: https://github.com/nvm-sh/nvm
# Reference: https://github.com/junegunn/fzf
# Reference: https://wezfurlong.org/wezterm/shell-integration.html
# Reference: https://github.com/ajeetdsouza/zoxide

export VIRTUAL_ENV_DISABLE_PROMPT=1
[[ "$(uname -s || true)" == "Darwin" ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# shellcheck source=/dev/null
[[ -n "${NVM_DIR:-}" ]] && source "${NVM_DIR}/bash_completion" 2>/dev/null
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash || true)"
command -v wezterm >/dev/null 2>&1 && eval "$(wezterm shell-completion --shell bash || true)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd || true)"
