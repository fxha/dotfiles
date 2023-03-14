#!/bin/bash
set -e

#######################################
## Shell: Flat Remix GNOME
## Icons: Papirus Remix based on Papirus
## Theme: Qogir GTK Theme
#######################################

export LOG_FILE="/tmp/dotfiles-shell.log"

if [[ "$(id -u)" = 0 ]]; then
  echo "The script need to be run without root permissions." >&2
  exit 1
fi

# Ask for root permissions
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
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

# Install prerequisites
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

mkdir -p /tmp/dotfiles-shell/
pushd /tmp/dotfiles-shell > /dev/null

# ====================================================
# Shell theme
#
echo " [-] Downloading Flat-Remix-Gnome shell theme..."
git clone https://github.com/daniruiz/flat-remix-gnome &>> "$LOG_FILE"

pushd flat-remix-gnome > /dev/null

# echo " [-] Building Flat-Remix-Gnome shell theme..."
# make &>> "$LOG_FILE"
# ./generate-color-theme.sh Blue '#2777ff' '#ffffff' &>> "$LOG_FILE"

echo " [-] Installing Flat-Remix-Gnome shell theme..."
[[ -d /usr/share/themes/Flat-Remix-Blue-Light-fullPanel ]] && sudo rm -rf /usr/share/themes/Flat-Remix-Blue-Light-fullPanel
sudo mv themes/Flat-Remix-Blue-Light-fullPanel /usr/share/themes/Flat-Remix-Blue-Light-fullPanel

popd > /dev/null # Flat-Remix-Gnome

# ====================================================
# Icon themes
#
echo " [-] Downloading Papirus icon theme..."
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git &>> "$LOG_FILE"
pushd papirus-icon-theme > /dev/null

echo " [-] Installing Papirus icon theme..."
[[ -d /usr/share/icons/Papirus ]] && sudo rm -rf /usr/share/icons/Papirus
sudo mv Papirus /usr/share/icons/Papirus

popd > /dev/null # papirus-icon-theme

echo " [-] Downloading Papirus Remix icon theme..."
git clone https://gitlab.com/sira313/papirus-remix.git &>> "$LOG_FILE"

echo " [-] Installing Papirus Remix icon theme..."
[[ -d /usr/share/icons/papirus-remix ]] && sudo rm -rf /usr/share/icons/papirus-remix
sudo mv papirus-remix /usr/share/icons/papirus-remix

# ====================================================
# GTK theme
#
echo " [-] Downloading Qogir theme..."
git clone https://github.com/vinceliuice/Qogir-theme.git &>> "$LOG_FILE"
pushd Qogir-theme > /dev/null

echo " [-] Customizing and installing Qogir theme..."

# Change titlebar color
sed -i 's/{ $header_bg: rgba(#ffffff, 0.95); }/{ $header_bg: rgba(#e7e8eb, 0.95); }/g' src/_sass/_colors.scss
sed -i 's/{ $header_bg: #ffffff; }/{ $header_bg: #e7e8eb; }/g' src/_sass/_colors.scss

# Build theme
./parse-sass.sh &>> "$LOG_FILE"

./install.sh -c light -t default -i gnome --tweaks square --libadwaita &>> "$LOG_FILE"
./install.sh -c dark -t default -i gnome --tweaks square --libadwaita &>> "$LOG_FILE"
popd > /dev/null # Qogir-theme

popd > /dev/null # /tmp/dotfiles-shell

# Enable user extensions and themes
dconf write /org/gnome/shell/disable-user-extensions false
enabledExtensions=$(dconf read /org/gnome/shell/enabled-extensions)
if [[ -z $enabledExtensions ]]; then
    dconf write /org/gnome/shell/enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
elif [[ $enabledExtensions != *"'user-theme@gnome-shell-extensions.gcampax.github.com'"* ]]; then
    dconf write /org/gnome/shell/enabled-extensions "${enabledExtensions%]*}, 'user-theme@gnome-shell-extensions.gcampax.github.com']"
fi

# Apply themes
dconf write /org/gnome/desktop/interface/gtk-theme "'Qogir-Light'"
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-remix'"
dconf write /org/gnome/shell/extensions/user-theme/name "'Flat-Remix-Blue-Light-fullPanel'"

echo "ok"
cleanup
trap - EXIT
exit 0
