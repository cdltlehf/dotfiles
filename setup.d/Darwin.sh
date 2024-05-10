#!/bin/bash
# Array of default configuration files for Darwin

# TODO: Be sudoer for some commands
macos_defaults=(
  "${basedir}/macos/defaults/.macos"
  "${basedir}/macos/defaults/.macos.application"
  "${basedir}/macos/defaults/.macos.dock"
  "${basedir}/macos/defaults/.macos.finder"
  "${basedir}/macos/defaults/.macos.keyboard"
  "${basedir}/macos/defaults/.macos.menubar"
  "${basedir}/macos/defaults/.macos.screencapture"
  "${basedir}/macos/defaults/.macos.screensaver"
)

# Array of dotfiles for Darwin (macos)
dotfiles_darwin=(
  "${basedir}/macos/.hammerspoon/"
  # "${basedir}/macos/.skhdrc"
  "${basedir}/macos/.ubersichtrc"
  # "${basedir}/macos/.yabairc"
)

# System Configurations
sudo scutil --set ComputerName
sudo scutil --set HostName
sudo scutil --set LocalHostName

# NOTE: These default files should be brew package independent
echo "Run \`default ...\` commands for macos."
for defaults in "${macos_defaults[@]}"; do
  command zsh "${defaults}"
done
unset defaults

echo "Make symbolic links of dotfiles for macos..."
for dotfile in "${dotfiles_darwin[@]}"; do
  symlink_home "${dotfile}" || true
done
echo "Done."
unset dotfile

# NOTE: In general, the below code is redundant since git needs it
xcode-select --install &> /dev/null || true

# If there is no ssh key, make one.
if [[ -d ${HOME}/.ssh ]] && [[ -n "$(ls -A "${HOME}/.ssh")" ]]; then
  true
elif command -v ssh-keygen; then
  # https://stribika.github.io/2015/01/04/secure-secure-shell.html
  ssh-keygen -t ed25519 -a 100
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
read -rp "Install rosetta? (Y/n) " yn
case $yn in
  [Yy]* | " " ) sudo softwareupdate --install-rosetta || true ;;
esac
unset yn

echo "Install brew packages in ${basedir}/macos/Brewfile"
command -v brew &> /dev/null \
  && brew bundle --file "${basedir}/macos/Brewfile"

# iTerm
echo "Add terminfo. It may override local terminfo"
tic -x "${basedir}/term/xterm-256color-italic.terminfo"
tic -x "${basedir}/term/tmux-256color.terminfo"

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
