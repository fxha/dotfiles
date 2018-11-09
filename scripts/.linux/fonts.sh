#!/bin/bash
set -e

if [ -z "${isApt+x}" ]; then
    echo "[ERROR] \$isApt is not set."
    exit 1
fi

echo " [-] Installing fonts..."

if [ "$isApt" = true ]; then
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    sudo apt-get install -y \
        fonts-dejavu \
        fonts-droid-fallback \
        fonts-firacode \
        fonts-noto \
        fonts-roboto \
        fonts-open-sans \
        ttf-mscorefonts-installer \
        fonts-ubuntu \
        &>> "$DOTFILES_LOG_FILE"

# Adobe Source Code Pro
echo "   [-] Installing Adobe Source Code Pro font..."
mkdir -p "$HOME/.local/share/fonts/source-code-pro"
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git "$HOME/.local/share/fonts/source-code-pro" &>> "$DOTFILES_LOG_FILE"
fc-cache -f -v "$HOME/.local/share/fonts/source-code-pro" > /dev/null
else
    sudo dnf install -y \
        adobe-source-code-pro-fonts \
        adobe-source-sans-pro-fonts \
        dejavu-sans-fonts \
        google-droid-sans-fonts \
        google-droid-sans-mono-fonts \
        google-noto-sans-fonts \
        google-noto-serif-fonts \
        google-roboto-fonts \
        mozilla-fira-mono-fonts \
        mozilla-fira-sans-fonts \
        open-sans-fonts \
        ubuntu-title-fonts \
        &>> "$DOTFILES_LOG_FILE"

    # Microsoft's Core Fonts (http://mscorefonts2.sourceforge.net/)
    sudo dnf install -y \
        https://rpmfind.net/linux/sourceforge/m/ms/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm \
        &>> "$DOTFILES_LOG_FILE"
fi
