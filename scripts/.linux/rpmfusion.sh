#!/bin/bash
set -e

# source: https://gist.github.com/eklitzke/f7565871c77d4707041117f4b1022990
install_rpmfusion() {
    . /etc/os-release
    local rpmname
    if ! rpm -qa rpmfusion-free-release | grep -q rpmfusion; then
        rpmname="rpmfusion-free-release-$VERSION_ID.noarch.rpm"
        sudo dnf install -y \
            https://download1.rpmfusion.org/free/fedora/"$rpmname" \
            &>> "$DOTFILES_LOG_FILE"
    fi
    if ! rpm -qa rpmfusion-nonfree-release | grep -q rpmfusion; then
        rpmname="rpmfusion-nonfree-release-$VERSION_ID.noarch.rpm"
        sudo dnf install -y \
            https://download1.rpmfusion.org/nonfree/fedora/"$rpmname" \
            &>> "$DOTFILES_LOG_FILE"
    fi
}

echo " [-] Installing RPM Fusion repositories..."

install_rpmfusion
