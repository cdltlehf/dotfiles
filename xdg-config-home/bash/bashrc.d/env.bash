# Reference: https://github.com/junegunn/fzf
# Reference: https://wezfurlong.org/wezterm/
# Reference: https://github.com/ajeetdsouza/zoxide

export VIRTUAL_ENV_DISABLE_PROMPT=1

case "$(__detect_os)" in
  darwin) export BASH_SILENCE_DEPRECATION_WARNING=1 ;;
  *) ;;
esac

# shellcheck source=/dev/null
[[ -n "${NVM_DIR:-}" ]] && source "${NVM_DIR}/bash_completion" 2>/dev/null
__cached fzf --bash
__cached wezterm shell-completion --shell bash
__cached zoxide init bash --cmd cd
