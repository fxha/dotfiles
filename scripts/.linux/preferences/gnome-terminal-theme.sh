#!/bin/bash
set -e

echo " [-] Installing One-Dark GNOME Terminal theme"

dconf load /org/gnome/terminal/legacy/profiles:/:53ed2cf7-1cc5-4b08-a6ae-e6b6afd8974a/ < "$DOTFILES_ROOT/misc/dconf/gnome-terminal-one-dark.ini"

dconf write /org/gnome/terminal/legacy/profiles:/default "'53ed2cf7-1cc5-4b08-a6ae-e6b6afd8974a'"
dconf write /org/gnome/terminal/legacy/default-show-menubar false

# append our profile id if needed
profileList=$(dconf read /org/gnome/terminal/legacy/profiles:/list)
if [[ -z $profileList ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/list "['53ed2cf7-1cc5-4b08-a6ae-e6b6afd8974a']"
elif [[ $profileList != *"'53ed2cf7-1cc5-4b08-a6ae-e6b6afd8974a'"* ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/list "${profileList%]*}, '53ed2cf7-1cc5-4b08-a6ae-e6b6afd8974a']"
fi
