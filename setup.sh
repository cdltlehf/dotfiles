#!/bin/bash -ue

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
  local source_file=$1

  # If ${source_file} not exists, return with an error
  if [[ ! -e "${source_file}" ]]; then return 1; fi
  local target_file
  target_file="${HOME}/$(basename "$source_file")"

  # If the symlink exists, return 0
  if [[ -L "${target_file}" ]] &&
    [[ $(readlink "${target_file}") == "${source_file}" ]]; then
        return 0;
  fi

  # If ${target_file} exists, ask to replace or not
  if [[ -e "${target_file}" ]]; then

    local yn
    read -rp \
      "Move ${target_file} to ${target_file}.$(date +%s)? (y/n) " yn
    case ${yn} in
      # [Yy]* ) rm -rf "${target_file}" ;;
      [Yy]* ) mv ${target_file} "${target_file}.$(date +%s)" ;;
      * ) return 1 ;;
    esac
  fi

  # Make a target symlink verbosely
  ln -s "${source_file}" "${target_file}"
  echo "${target_file} -> ${source_file}"
}

# Array of common dotfiles
# TODO: Think about how to deal with ~/.config
DOTFILES_COMMON=(
  "${BASEDIR}/bash/.bash_profile"
  "${BASEDIR}/bash/.bash_prompt"
  "${BASEDIR}/bash/.bashrc"

  "${BASEDIR}/etc/.inputrc"

  "${BASEDIR}/git/.gitconfig"

  "${BASEDIR}/sh/.aliases"
  "${BASEDIR}/sh/.profile"
  "${BASEDIR}/sh/.shrc"

  "${BASEDIR}/tmux/.tmux.conf"

  "${BASEDIR}/vim/.vim/"

  "${BASEDIR}/zsh/.zshrc"
  "${BASEDIR}/zsh/.zsh_prompt"
)

# Array of common XDG_CONFIG_HOME dotfiles
DOTFILES_COMMON=(
  "${BASEDIR}/bash/.bash_profile"
  "${BASEDIR}/bash/.bash_prompt"
  "${BASEDIR}/bash/.bashrc"

  "${BASEDIR}/etc/.inputrc"

  "${BASEDIR}/git/.gitconfig"

  "${BASEDIR}/sh/.aliases"
  "${BASEDIR}/sh/.profile"
  "${BASEDIR}/sh/.shrc"

  "${BASEDIR}/tmux/.tmux.conf"

  "${BASEDIR}/vim/.vim/"
  "${BASEDIR}/config/.config/"

  "${BASEDIR}/zsh/.zshrc"
  "${BASEDIR}/zsh/.zsh_prompt"
)

echo "Make symbolic links of common dotfiles..."
for dotfile in "${DOTFILES_COMMON[@]}"; do
  symlink_home "${dotfile}" || true
done
unset dotfile
echo "Done."

# Array of dotfiles for Darwin (macos)
DOTFILES_DARWIN=(
  "${BASEDIR}/macos/.hammerspoon/"
  # "${BASEDIR}/macos/.skhdrc"
  "${BASEDIR}/macos/.ubersichtrc"
  # "${BASEDIR}/macos/.yabairc"
)

# Array of default configuration files for Darwin
MACOS_DEFAULTS=(
  # "${BASEDIR}/macos/defaults/.macos"
  "${BASEDIR}/macos/defaults/.macos.dock"
  "${BASEDIR}/macos/defaults/.macos.screencapture"
  "${BASEDIR}/macos/defaults/.macos.screensaver"
  "${BASEDIR}/macos/defaults/.macos.keyboard"
)

# Do platform dependent configurations
case ${UNAME} in
  # TODO: Be sudoer for some commands

  # Do configurations of Darwin (macos)
  "Darwin")
  echo "Set configurations for macos."

  # System Configurations
  sudo scutil --set ComputerName
  sudo scutil --set HostName
  sudo scutil --set LocalHostName

  # NOTE: These default files should be brew package independent
  echo "Run \`default ...\` commands for macos."
  for defaults in "${MACOS_DEFAULTS[@]}"; do
    command zsh "${defaults}"
  done
  unset defaults

  echo "Make symbolic links of dotfiles for macos..."
  for dotfile in "${DOTFILES_DARWIN[@]}"; do
    symlink_home "${dotfile}" || true
  done
  echo "Done."
  unset dotfile

  # NOTE: In general, the below code is redundant since git needs it
  xcode-select --install &> /dev/null || true

  # If there is no ssh key, make one.
  if [[ -d ${HOME}/.ssh ]] && [[ -n "$(ls -A "${HOME}/.ssh")" ]]; then
    true
  else
    if command -v ssh-keygen; then
      # https://stribika.github.io/2015/01/04/secure-secure-shell.html
      ssh-keygen -t ed25519 -a 100
    fi
  fi

  # Install Homebrew
  if ! command -v brew &> /dev/null; then
    echo "Install Homebrew"
    /bin/bash -c \
      "$(curl -fsSL
          https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # TODO: Check and run `softwareupdate --all --install --force`
  read -rp "Install rosetta? (y/n) " yn
  case $yn in
    [Yy]* ) sudo softwareupdate --install-rosetta || true ;;
  esac
  unset yn

  echo "Install brew packages in ${BASEDIR}/macos/Brewfile"
  command -v brew &> /dev/null \
    && brew bundle --file "${BASEDIR}/macos/Brewfile"

  # iTerm
  echo "Add terminfo. It may override local terminfo"
  tic -x "${BASEDIR}/term/xterm-256color-italic.terminfo"
  tic -x "${BASEDIR}/term/tmux-256color.terminfo"

  read -rp "Open iTerm? (y/n) " yn
  case $yn in
    [Yy]* ) open -a iTerm ;;
  esac
  unset yn
  echo "Do followings for iTerm settings:"
  cat <<END
iTerm2 > Preferences... > Profiles > Other Actions... > Import JSON Profiles..."
END

  # Hammerspoon
  read -rp "Open Hammerspoon? (y/n) " yn
  case $yn in
    [Yy]* ) open -a Hammerspoon ;;
  esac
  unset yn

  echo "Do followings for Hammerspoon settings:"
  echo "Hammerspoon > Preferences... > Launch Hammerspoon at login (enable)"
  echo "Hammerspoon > Preferences... > Enable Accessibility"

  # BetterDiscord
  read -rp "Open BetterDiscord? (y/n) " yn
  case $yn in
    [Yy]* ) open -a BetterDiscord ;;
  esac
  unset yn

  echo "Do followings for Hammerspoon settings:"
  echo "Hammerspoon > Preferences... > Launch Hammerspoon at login (enable)"
  echo "Hammerspoon > Preferences... > Enable Accessibility"

  # TODO: Do package dependent things
  # Make the following applications default:
  # Google Chrome, iTerm, VLC, VOX, The Unarchiver
  # Set the following applications: Alfred4(?), Ubersicht, Hammerspoon

  ;;
esac

echo "Restart your login shell with \`exec \"\${SHELL}\" --login\`"
unset -f symlink_home
unset UNAME
unset BASEDIR

# vim:ft=sh:ts=2:sts=2:sw=2:et:sta
