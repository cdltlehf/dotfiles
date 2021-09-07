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

