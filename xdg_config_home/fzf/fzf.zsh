# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cdltlehf/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/cdltlehf/.fzf/bin"
fi

source <(fzf --zsh)
