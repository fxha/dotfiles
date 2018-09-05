#!/bin/bash
set -e

# Dependencies:
#   apt-get install cargo rustc cmake libfreetype6-dev libfontconfig1-dev xclip
#   dnf install cmake fcargo rust reetype-devel fontconfig-devel xclip

# build and install alacritty
. "$DOTFILES_DIR/build_alacritty.sh"

# create desktop file
mkdir -p "$HOME/.local/share/applications"
link_file "$DOTFILES_ROOT/.local/share/applications/alacritty.desktop" "$HOME/.local/share/applications/alacritty.desktop"

# set Alacritty as default terminal; issues on Fedora/Wayland.
#if cmd_exists "dconf"; then
#    # sh -c env WAYLAND_DISPLAY= alacritty
#    dconf write /org/gnome/desktop/applications/terminal/exec "'alacritty'"
#fi
