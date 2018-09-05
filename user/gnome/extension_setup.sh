#!/bin/bash
set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
export DOTFILES_ROOT

# restore extension settings
echo "Restoring GNOME extension settings"
dconf write /org/gnome/shell/disable-user-extensions false
dconf load /org/gnome/shell/extensions/dash-to-dock/ < "$DOTFILES_ROOT/misc/dconf/dash-to-dock.ini"
dconf load /org/gnome/shell/extensions/dynamic-panel-transparency/ < "$DOTFILES_ROOT/misc/dconf/dynamic-panel-transparency.ini"
dconf load /org/gnome/shell/extensions/sound-output-device-chooser/ < "$DOTFILES_ROOT/misc/dconf/sound-output-device-chooser.ini"

exit 0
