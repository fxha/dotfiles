#!/bin/bash
set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CURRENT_DIR

echo " [-] Apply gedit settings..."

# Atom One Dark based theme with custom comment color
if [ ! -f "$HOME/.local/share/gedit/styles/theme_two_dark.xml" ]; then
    mkdir -p "$HOME/.local/share/gedit/styles"
    cp "$CURRENT_DIR/theme_two_dark.xml" "$HOME/.local/share/gedit/styles/theme_two_dark.xml"
fi

if [ -n "$(command -v dconf)" ]; then
    dconf write /org/gnome/gedit/preferences/editor/tabs-size 2
    dconf write /org/gnome/gedit/preferences/editor/insert-spaces true
fi

exit 0
