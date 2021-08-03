export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/Users/cdltlehf/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
export EDITOR='vim'

export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'dracula/zsh', as:theme

zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma/fast-syntax-highlighting"
zplug "plugins/vi-mode, from:oh-my-zsh"

# zplug "lib/key-bindings", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/tmux", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
