#!/bin/bash
set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_ROOT
export DOTFILES_DIR="$DOTFILES_ROOT"

if [ "$(basename "$DOTFILES_ROOT")" = "scripts" ]; then
    DOTFILES_ROOT="$(dirname "$DOTFILES_ROOT")"
else
    DOTFILES_DIR="$DOTFILES_DIR/scripts"
fi

# load utils
. "$DOTFILES_DIR/utils.sh"

# detect OS
os=""
if [[ "$(uname)" == "Linux" ]]; then
    os="linux"
elif [[ "$(uname)" == "Darwin" ]]; then
    os="osx"
else
    cerror "Unknown operating system!"
    exit 1
fi

installBaseList=true
installGuiMinList=true
installGuiFullList=true
installFonts=true
installMedia=true
installDevList=true
installGnomeList=false
installGnomeTerminalTheme=false
installMisc=true
installAlacritty=true
installBed=true
installRestic=true

if cmd_exists "gnome-shell"; then
    installGnomeList=true
fi
if cmd_exists "gnome-terminal"; then
    installGnomeTerminalTheme=true
fi

# ask user for individual configuration
if ask_yes "Do you want to customize configuration?"; then
    if ask_no "Do you want to install base applications?"; then
        installBaseList=false
    fi
    if ask_no "Do you want to install essential GUI applications?"; then
        installGuiMinList=false
    fi
    if ask_no "Do you want to install more GUI applications?"; then
        installGuiFullList=false
    fi
    if ask_no "Do you want to install custom fonts?"; then
        installFonts=false
    fi
    if ask_no "Do you want to install multimedia codecs and applications?"; then
        installMedia=false
    fi
    if ask_no "Do you want to install developer packages?"; then
        installDevList=false
    fi
    if cmd_exists "gnome-shell"; then
        if ask_no "Do you want to install gnome tools and configuration?"; then
            installGnomeList=false
        fi
    fi
    if cmd_exists "gnome-terminal"; then
        if ask_no "Do you want to install the gnome terminal theme?"; then
            installGnomeTerminalTheme=false
        fi
    fi
    if ask_no "Do you want to install miscellaneous tools)?"; then
        installMisc=false
    fi
    if ask_no "Do you want to install Alacritty (and rust)?"; then
        installAlacritty=false
    fi
    if ask_no "Do you want to install bed hex editor (and golang)?"; then
        installBed=false
    fi
    if ask_no "Do you want to install restic (and golang)?"; then
        installRestic=false
    fi
    # TODO: docker
fi

. "$DOTFILES_DIR/.$os/${os}_packages.sh"

echo -e "Done\n"
