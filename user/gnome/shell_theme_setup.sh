#!/bin/bash
set -e

#######################################
## Shell: Flat-Plat-Blue-compact
## Icons: custom Arc-X-Icons, Arc-X-Icons and Paper
## Theme: custom X-Arc-White, Qogir Gtk Theme
#######################################

export LOG_FILE="/tmp/dotfiles-shell.log"

if [[ "$(id -u)" = 0 ]]; then
  echo "The script need to be run without root permissions." >&2
  exit 1
fi

# ask for root permissions
sudo -v

# keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# source: https://gist.github.com/cowboy/3118588
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

function cleanup() {
  if [ -d "/tmp/dotfiles-shell" ]; then
    echo "Deleting temporary files..."
    rm -rf /tmp/dotfiles-shell
  fi
}

function beforeExit() {
  echo -e "\n======================================="
  echo "[ERROR] One or more commands failed!"
  echo "[ERROR] Log file: $LOG_FILE"

  cleanup
}

trap beforeExit EXIT

echo -e "Setup started: $(date +'%Y-%m-%d %H:%M:%S')\n" > "$LOG_FILE"

# install prerequisites
echo " [-] Installing prerequisites..."
if [ -n "$(command -v apt-get)" ]; then
  sudo apt-get install -qqy \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    sassc &>> "$LOG_FILE"
elif [ -n "$(command -v dnf)" ]; then
  sudo dnf install -y \
    gtk-murrine-engine \
    gtk2-engines \
    sassc &>> "$LOG_FILE"
else
  echo "[ERROR] Not supported package manager!"
  exit 1
fi

# try to find our custom themes, otherwise use fallback icons and theme.
useCustomIcons=false
useCustomTheme=false

if [[ -d "~/.icons/custom_arc_icons" && -d "~/.icons/Paper" ]]; then
  useCustomIcons=true
fi

if [[ -d "~/.themes/custom_arc" ]]; then
  useCustomTheme=true
fi

mkdir -p /tmp/dotfiles-shell/
pushd /tmp/dotfiles-shell > /dev/null

# download and install themes
echo " [-] Downloading Flat-Plat-Blue shell theme..."
git clone https://github.com/peterychuang/Flat-Plat-Blue &>> "$LOG_FILE"

pushd Flat-Plat-Blue > /dev/null

# checkout latest tag
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
lastestTagName=$(git describe --tags "$latestTag")
echo "   Switching branch to $lastestTagName"
git checkout $latestTag &>> "$LOG_FILE"

echo " [-] Installing Flat-Plat-Blue shell theme..."
sudo ./install.sh -c standard -s compact &>> "$LOG_FILE"

popd > /dev/null # Flat-Plat-Blue

# download icons if needed
if [ "$useCustomIcons" = false ]; then
  echo " [-] Downloading Arc-X-Icons..."
  git clone https://gitlab.com/LinxGem33/Arc-X-Icons &>> "$LOG_FILE"
  pushd Arc-X-Icons > /dev/null

  echo " [-] Installing Arc-X-Icons..."
  sudo mv src/Paper /usr/share/icons/Paper
  sudo mv src/Arc-OSX-P /usr/share/icons/Arc-X-P

  popd > /dev/null # Arc-X-Icons
fi

# download theme if needed
if [ "$useCustomTheme" = false ]; then
  echo " [-] Downloading Qogir theme..."
  git clone https://github.com/vinceliuice/Qogir-theme &>> "$LOG_FILE"
  pushd Qogir-theme > /dev/null

  echo " [-] Customizing and installing Qogir theme..."

  # change titlebar color
  sed -i 's/{ $header_bg: rgba(#ffffff, 0.95); }/{ $header_bg: rgba(#e7e8eb, 0.95); }/g' src/_sass/_colors.scss
  sed -i 's/{ $header_bg: #ffffff; }/{ $header_bg: #e7e8eb; }/g' src/_sass/_colors.scss
  # TODO: close button bg is white

  # generate theme
  ./parse-sass.sh &>> "$LOG_FILE"

  sudo ./Install -c dark -t gnome &>> "$LOG_FILE" # use 'dark' to install the light theme :/

  popd > /dev/null # Qogir-theme
fi

popd > /dev/null # /tmp/dotfiles-shell


# enable user extensions and themes
dconf write /org/gnome/shell/disable-user-extensions false
enabledExtensions=$(dconf read /org/gnome/shell/enabled-extensions)
if [[ -z $enabledExtensions ]]; then
    dconf write /org/gnome/shell/enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
elif [[ $enabledExtensions != *"'user-theme@gnome-shell-extensions.gcampax.github.com'"* ]]; then
    dconf write /org/gnome/shell/enabled-extensions "${enabledExtensions%]*}, 'user-theme@gnome-shell-extensions.gcampax.github.com']"
fi

# change GTK theme
if [ "$useCustomTheme" = false ]; then
  dconf write /org/gnome/desktop/interface/gtk-theme "'Qogir-gnome-light'"
else
  dconf write /org/gnome/desktop/interface/gtk-theme "'Custom_arc'"
fi

# change icon theme
if [ "$useCustomTheme" = false ]; then
  dconf write /org/gnome/desktop/interface/icon-theme "'Arc-X-P'"
else
  dconf write /org/gnome/desktop/interface/icon-theme "'Custom_arc_icons'"
fi

# change shell theme
dconf write /org/gnome/shell/extensions/user-theme/name "'Flat-Plat-Blue-compact'"

echo "ok"
cleanup
trap - EXIT
exit 0
