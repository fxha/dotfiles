#!/bin/bash
set -e

echo " [-] Apply Gnome Texteditor settings..."

if [ -n "$(command -v dconf)" ]; then
    dconf write /org/gnome/TextEditor/custom-font 'DejaVu Sans Mono 9'
    dconf write /org/gnome/TextEditor/highlight-current-line true
    dconf write /org/gnome/TextEditor/indent-style 'space'
    dconf write /org/gnome/TextEditor/restore-session false
    dconf write /org/gnome/TextEditor/style-scheme 'Adwaita-dark'
    dconf write /org/gnome/TextEditor/style-variant 'dark'
    dconf write /org/gnome/TextEditor/tab-width 2
    dconf write /org/gnome/TextEditor/use-system-font false
fi

exit 0
