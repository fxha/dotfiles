#!/bin/bash
set -e

PACKAGES_BASE_LIST=(
    bash
    bash-completion
    curl
    dconf
    fuse
    git
    gnupg2
    htop
    lm_sensors
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
    vlc # rpmfusion
)

PACKAGES_DEV_LIST=(
    ccache
    cmake
    clang
    clang-tools-extra
    doxygen
    gcc
    gcc-c++
    gdb
    git
    golang
    make
    ninja-build
    openssl-devel
    valgrind
    # ⇣⇣⇣ dev/library dependencies ⇣⇣⇣
    fuse fuse-devel
    boost boost-devel
)

PACKAGES_GNOME_LIST=(
    chrome-gnome-shell
    gnome-tweak-tool
)

PACKAGES_MEDIA=(
    ffmpeg # rpmfusion
    gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good-extras gstreamer-ffmpeg
    vlc # rpmfusion
)

PACKAGES_MISC=(
    p7zip
    powertop
)

PACKAGES_LATEX=(
    pandoc
    pandoc-citeproc
    texlive
    texlive-xecjk
    texlive-filehook
    texlive-unicode-math
    texlive-ucharcat
    texlive-pagecolor
    texlive-babel-german
    texlive-ly1 texlive-mweights
    texlive-sourcecodepro
    texlive-sourcesanspro
    texlive-mdframed
    texlive-needspace
    texlive-titling
)
