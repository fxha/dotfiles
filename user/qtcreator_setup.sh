#!/bin/bash
set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
export DOTFILES_ROOT

read -p "Are you sure to run the QtCreator configuration script? " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# load utils
. "$DOTFILES_ROOT/scripts/utils.sh"

echo " [-] Coping QtCreator configuration..."
mkdir -p "$HOME/.config/QtProject/qtcreator/beautifier/clangformat/Chromium"
mkdir -p "$HOME/.config/QtProject/qtcreator/codestyles/Cpp"
mkdir -p "$HOME/.config/QtProject/qtcreator/styles"

copy_file "$DOTFILES_ROOT/.config/QtProject/qtcreator/QtCreator.ini" "$HOME/.config/QtProject/qtcreator/QtCreator.ini"
copy_file "$DOTFILES_ROOT/.config/QtProject/qtcreator/beautifier/clangformat/Chromium/.clang-format" "$HOME/.config/QtProject/qtcreator/beautifier/clangformat/Chromium/.clang-format"
copy_file "$DOTFILES_ROOT/.config/QtProject/qtcreator/codestyles/Cpp/qt2.xml" "$HOME/.config/QtProject/qtcreator/codestyles/Cpp/qt2.xml"

# GPL 3.0
wget -O "$HOME/.config/QtProject/qtcreator/styles/SublimeMaterial.xml" https://raw.githubusercontent.com/foxoman/sublimematerial/master/SublimeMaterial.xml

exit 0
