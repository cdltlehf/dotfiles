#!/usr/bin/env bash

# Treat unset variables and parameters as an error
# (= `set -u`)
set -o nounset 

# Exit immediately
# (= `set -e`)
set -o errexit 

# Print a trace of commands
# set -o xtrace # (= `set -x`)

# Get base directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get kernel name
UNAME=$(uname --kernel-name)

# Update dotfiles
# command -v git > /dev/null && (cd "$BASEDIR" && git pull origin main);

# Array of common dotfiles
DOTFILES_COMMON=(
  "$BASEDIR/bash/.bash_profile"
  "$BASEDIR/bash/.bash_prompt"
  "$BASEDIR/bash/.bashrc"

  "$BASEDIR/etc/.inputrc"

  "$BASEDIR/sh/.aliases"
  "$BASEDIR/sh/.profile"

  "$BASEDIR/tmux/.tmux.conf"

  "$BASEDIR/vim/.vim/"

  "$BASEDIR/zsh/.zshrc"
  "$BASEDIR/zsh/.zsh_prompt"
)

# Array of dotfiles for Darwin (macos)
DOTFILES_DARWIN=(
  "$BASEDIR/macos/.skhdrc"
  "$BASEDIR/macos/.hammerspoon/"
  "$BASEDIR/macos/.yabairc"
)

# Make symbolic links for common dotfiles
for dotfile in "${DOTFILES_COMMON[@]}"; do
  basename="$(basename "$dotfile")"
  if [[ -e "$dotfile" ]]; then
    ln --interactive --symbolic "$dotfile" "$HOME/$basename"
  fi
  unset basename
done
unset dotfile

# Do platform dependent configurations
case $UNAME in
  # Do configurations for Darwin (macos)
  "Darwin")
    for dotfile in "${DOTFILES_DARWIN[@]}"; do
      basename="$(basename "$dotfile")"
      if [[ -e "$dotfile" ]]; then
        ln --interactive --symbolic "$dotfile" "$HOME/$basename"
      fi
      unset basename
    done
    unset dotfile
    ;;
esac

echo "Done. Restart your login shell with \`exec \$SHELL --login\`."
unset UNAME
unset BASEDIR

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
