#!/usr/bin/env bash -eu

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
UNAME=$(uname)

# Update dotfiles
# command -v git > /dev/null && (cd "$BASEDIR" && git pull origin main);

# Array of common dotfiles
DOTFILES_COMMON=(
  "$BASEDIR/bash/.bash_profile"
  "$BASEDIR/bash/.bash_prompt"
  "$BASEDIR/bash/.bashrc"

  "$BASEDIR/etc/.inputrc"

  "$BASEDIR/git/.gitconfig"

  "$BASEDIR/sh/.aliases"
  "$BASEDIR/sh/.profile"
  "$BASEDIR/sh/.shrc"

  "$BASEDIR/tmux/.tmux.conf"

  "$BASEDIR/vim/.vim/"

  "$BASEDIR/zsh/.zshrc"
  "$BASEDIR/zsh/.zsh_prompt"
)

# Array of dotfiles for Darwin (macos)
DOTFILES_DARWIN=(
  "$BASEDIR/macos/.hammerspoon/"
  "$BASEDIR/macos/.skhdrc"
  "$BASEDIR/macos/.ubersichtrc"
  "$BASEDIR/macos/.yabairc"
)

symlink_home() {
  local source_file=${1}

  # If $source_file not exists, return with an error
  if [[ ! -e "$source_file" ]]; then return 1; fi
  local target_file="$HOME/$(basename "$source_file")"

  # If $target_file exists, ask to replace or not
  if [[ -e "$target_file" ]]; then
    local yn
    read -p "replace $target_file? " yn
    case $yn in
      [Yy]* ) rm -rf "$target_file" ;;
      * ) return 1 ;;
    esac
  fi

  # Make a target symlink verbosely
  ln -s "$source_file" "$target_file"
  echo "$target_file -> $source_file"
}

# Make symbolic links for common dotfiles
for dotfile in "${DOTFILES_COMMON[@]}"; do
  symlink_home "$dotfile" || true
done
unset dotfile

# Do platform dependent configurations
case $UNAME in
  # Do configurations for Darwin (macos)
  # TODO: Brew things, macos defaults things, ...
  "Darwin")
    for dotfile in "${DOTFILES_DARWIN[@]}"; do
      symlink_home "$dotfile" || true
    done
    unset dotfile
    ;;
esac

echo "Done. Restart your login shell with \`exec \"\$SHELL\" --login\`."
unset -f symlink_home
unset UNAME
unset BASEDIR

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
