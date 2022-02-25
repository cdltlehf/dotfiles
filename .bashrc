# .bashrc
# if [ -z "$TMUX" ]; then
  # tmux attach || tmux
  # exit
# fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if tty >/dev/null 2>&1; then
    stty stop '' # disable Ctrl-s special behavior
    stty start '' # disable Ctrl-q special behavior
fi

# inspect processes on GPUs
nvidia-ps() {
    _pids="$(nvidia-smi pmon -c 1 | awk '/^#/{next}{if ($2 != "-") print $2}')"
    if  [ -n "$_pids" ]; then
        echo "$_pids" | xargs ps "$@"
    else
        echo "No processes are running."
    fi
    unset _pids
}

# alias podman to docker
if ! command docker 2> /dev/null; then
    alias docker='podman'
    alias docker-run='podman-run'
fi

# for safety...
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'

# color {{{1
background=40\;42\;54
current_line=68\;71\;90
foreground=248\;248\;242
comment=98\;114\;164
cyan=139\;233\;253
green=80\;250\;123
orange=255\;184\;108
pink=255\;121\;198
purple=189\;147\;249
red=255\;85\;85
yellow=241\;250\;140
# }}}

PS1=$'\n'
PS1+=$"\[\033[38;2;${pink}m\]\u\[\033[0m\] at "
PS1+=$"\[\033[38;2;${yellow}m\]\h\[\033[0m\] in "
PS1+=$"\[\033[38;2;${green}m\]\w\[\033[0m\]"
# PS1+='$(prompt_git ${cyan} ${purple})'
PS1+=$'\n'
PS1+=$"\[\033[38;2;${foreground}m\]$ \[\033[0m\]"
# PS2="%F{${comment}}> %f"
