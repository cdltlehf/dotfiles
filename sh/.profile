#!/usr/bin/env sh
## XXX: This file must be POSIX compliant, but never be guaranteed

# User specific environment
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH

# Set locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Disable special behaviors
if tty >/dev/null 2>&1; then
  stty stop ''; stty start ''
fi

# Inspect processes on GPUs
nvidia-ps() {
_pids="$(nvidia-smi pmon -c 1 | awk '/^#/{next}{if ($2 != "-") print $2}')"
if [[ -n "$_pids" ]]; then
  echo "$_pids" | xargs ps "$@"
else
  echo "No processes are running."
fi
unset _pids
}

# Alias podman to docker
if ! command docker 2> /dev/null; then
  alias docker='podman'
  alias docker-run='podman-run'
fi

# Source shell-independent dotfiles
for file in "$HOME"/.{aliases}; do
  [ -f "$file" ] && . "$file"
done;
unset file;

# vim:ts=2:sts=2:sw=2:et:sta:fdm=marker:fdl=0
