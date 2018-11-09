#!/bin/bash
set -e

PACKAGES_BASE_LIST=(
    bash
    bash-completion
    curl
    dconf-cli
    fuse
    git
    gnupg2
    htop
    lm-sensors
    pinentry-curses
    ranger
    rsync
    tmux
    tree
    vim
    wget
    xclip
)

PACKAGES_GUI_MIN_LIST=(
    dconf-editor
    firefox
    keepassxc
    seahorse
)

PACKAGES_GUI_FULL_LIST=(
    #gimp use latest flatpak version
    gnome-todo
    virt-manager
    vlc
)

PACKAGES_DEV_LIST=(
    build-essential
    ccache
    cmake
    clang
    clang-format
    clang-tidy
    doxygen
    gcc
    g++
    gdb
    git
    golang
    make
    ninja-build
    libssl-dev # openssl
    valgrind
    # ⇣⇣⇣ dev/library dependencies ⇣⇣⇣
    fuse libfuse-dev
    libboost-dev
)

PACKAGES_GNOME_LIST=(
    chrome-gnome-shell
    gnome-tweak-tool
)

PACKAGES_MEDIA=(
    ffmpeg
    libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-libav
    vlc
)

PACKAGES_MISC=(
    p7zip-full
    powertop
)

PACKAGES_LATEX=(
    pandoc
    pandoc-citeproc
    texlive-full
# TODO: complete the package list
)
