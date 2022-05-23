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

symlink_home() {
  local source_file=${1}

  # If $source_file not exists, return with an error
  if [[ ! -e "$source_file" ]]; then return 1; fi
  local target_file="$HOME/$(basename "$source_file")"

  # If $target_file exists, ask to replace or not
  if [[ -e "$target_file" ]]; then
    local yn
    read -p "replace $target_file? (y/n) " yn
    case $yn in
      [Yy]* ) rm -rf "$target_file" ;;
      * ) return 1 ;;
    esac
  fi

  # Make a target symlink verbosely
  ln -s "$source_file" "$target_file"
  echo "$target_file -> $source_file"
}

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

echo "Make symbolic links of common dotfiles..."
for dotfile in "${DOTFILES_COMMON[@]}"; do
  symlink_home "$dotfile" || true
done
unset dotfile
echo "Done.\n"

# Array of dotfiles for Darwin (macos)
DOTFILES_DARWIN=(
  "$BASEDIR/macos/.hammerspoon/"
  # "$BASEDIR/macos/.skhdrc"
  "$BASEDIR/macos/.ubersichtrc"
  # "$BASEDIR/macos/.yabairc"
)

# Array of default configuration files for Darwin
MACOS_DEFAULTS=(
  # "$BASEDIR/macos/defaults/.macos"
  "$BASEDIR/macos/defaults/.macos.dock"
  "$BASEDIR/macos/defaults/.macos.screencapture"
  "$BASEDIR/macos/defaults/.macos.screensaver"
)

# Do platform dependent configurations
case $UNAME in
  # TODO: Be sudoer for some commands

  # Do configurations of Darwin (macos)
  # TODO: Brew things, macos defaults things, ...
  "Darwin")

  # XXX: These default files should be package independent
  echo "Set default configurations for macos."
  for defaults in "${MACOS_DEFAULTS}"; do
    command zsh $defaults
  done
  unset defaults

  echo "Make symbolic links of dotfiles for macos..."
  for dotfile in "${DOTFILES_DARWIN[@]}"; do
    symlink_home "$dotfile" || true
  done
  echo "Done.\n"
  unset dotfile

  # XXX: In general, the below code is redundant, since it is needed for git.
  xcode-select --install &> /dev/null || true

  # If there is no ssh key, make one.
  # XXX: Is it a best way to check whether a directory is empty?
  if [[ -d $HOME/.ssh ]] && [[ "$(ls -A $HOME/.ssh)" ]]; then
    true

  else
    if command -v ssh-keygen; then
      # https://stribika.github.io/2015/01/04/secure-secure-shell.html
      ssh-keygen -t ed25519 -a 100
    fi
  fi

  # Install Homebrew
  if ! command -v brew &> /dev/null; then
    # XXX: Instead of using `command bash`, it uses `/bin/bash`
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  [[ -f "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

  # TODO: Check and run `softwareupdate --all --install --force`
  # TODO: Check and run `sudo sotwareupdate --install-rosetta`

  echo "Install brew packages in $BASEDIR/macos/Brewfile"
  command -v brew &> /dev/null && brew bundle --file "$BASEDIR/macos/Brewfile"

  # TODO: Do package dependent things
  # Make the following applications default:
  # Google Chrome, iTerm, VLC, VOX, The Unarchiver
  # Set the following applications: Alfred4(?), Ubersicht, Hammerspoon
  # Run BetterDiscord

  ;;
esac

echo "Restart your login shell with \`exec \"\$SHELL\" --login\`."
unset -f symlink_home
unset UNAME
unset BASEDIR

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
