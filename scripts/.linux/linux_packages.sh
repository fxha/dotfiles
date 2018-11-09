#!/bin/bash
set -e

# detect package manager
isApt=false
if [ -n "$(command -v apt-get)" ]; then
    isApt=true
elif [ -n "$(command -v dnf)" ]; then
    isApt=false
else
    echo "[ERROR] Not supported package manager!"
    exit 1
fi

echo "Debian-based distro: $isApt"

# accept 'ttf-mscorefonts-installer' license
if [[ "$DOTFILES_NO_INTERACTION" = true && "$DOTFILES_ACCEPT_MSCOREFONTS_EULA" = false ]]; then
    echo "[ERROR] Cannot install 'ttf-mscorefonts-installer'"
    exit 1
elif [[ "$DOTFILES_ACCEPT_MSCOREFONTS_EULA" = false && "$isApt" = true && "$installFonts" = true ]]; then
    if ask_no "I have read the END-USER LICENSE AGREEMENT FOR MICROSOFT SOFTWARE (http://corefonts.sourceforge.net/eula.htm) and accept them to install Microsoft's TrueType core fonts. (y)"; then
        echo "[ERROR] Cannot install 'ttf-mscorefonts-installer'"
        exit 1
    fi
fi

# RPM Fusion
if [[ "$isApt" = false && "$DOTFILES_NO_INTERACTION" = true ]]; then
    . "$DOTFILES_DIR/.linux/rpmfusion.sh"
elif [[ "$isApt" = false ]]; then
    echo " [-] Checking for RPM Fusion repositories..."

    rpmfusion_available=true
    if ! rpm -qa rpmfusion-free-release | grep -q rpmfusion; then
        rpmfusion_available=false
    fi
    if ! rpm -qa rpmfusion-nonfree-release | grep -q rpmfusion; then
        rpmfusion_available=false
    fi
    if [[ "$rpmfusion_available" = false ]]; then
        if ask_yes "Do you want install RPM Fusion repositories?"; then
            . "$DOTFILES_DIR/.linux/rpmfusion.sh"
        else
            cerror "Please install RPM Fusion free and nonfree repositories before continuing."
            exit 1
        fi
    fi
fi

# include packages
if [ "$isApt" = true ]; then
	. "$DOTFILES_ROOT/packages/packages-apt.sh"
else
    . "$DOTFILES_ROOT/packages/packages-dnf.sh"
fi

# build package list
packageList=()
if [ "$installBaseList" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_BASE_LIST[@]}")
fi
if [ "$installGuiMinList" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_GUI_MIN_LIST[@]}")
fi
if [ "$installGuiFullList" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_GUI_FULL_LIST[@]}")
fi
if [ "$installMedia" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_MEDIA[@]}")
fi
if [ "$installDevList" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_DEV_LIST[@]}")
fi
if [ "$installGnomeList" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_GNOME_LIST[@]}")
fi
if [ "$installLatex" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_LATEX[@]}")
fi
if [ "$installMisc" = true ]; then
    packageList=("${packageList[@]}" "${PACKAGES_MISC[@]}")
fi

# apply user configuration
echo " [-] Downloading and installing packages..."
if [ -z "$packageList" ]; then
    echo "   [-] There's nothing to do."
else
    for package in "${packageList[@]}"; do
        echo -n "   - installing $package..."
        if [ "$isApt" = true ]; then
            sudo apt-get install -y \
                "$package" \
                &>> "$DOTFILES_LOG_FILE"
        else
            sudo dnf install -y \
                "$package" \
                &>> "$DOTFILES_LOG_FILE"
        fi
        echo -e " \x1b[32mok\x1b[0m"
    done
fi

# fonts
if [ "$installFonts" = true ]; then
    . "$DOTFILES_DIR/.linux/fonts.sh"
fi

# gnome settings
if [ "$installGnomeList" = true ]; then
    . "$DOTFILES_DIR/.linux/preferences/gnome.sh"
fi

# terminal settings and theme
if [ "$installGnomeTerminalTheme" = true ]; then
    . "$DOTFILES_DIR/.linux/preferences/gnome-terminal-theme.sh"
fi

# install rust and cargo
if [ "$installDevList" = true ]; then
    . "$DOTFILES_DIR/.linux/rust.sh"
fi

# install LaTeX template
if [ "$installLatex" = true ]; then
    mkdir -p "$HOME/.pandoc/templates"
    wget -O "$HOME/.pandoc/templates/eisvogel.latex" \
        https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex \
        &>> "$DOTFILES_LOG_FILE" || true
fi

# build applications from source
if [ "$installAlacritty" = true ]; then
    echo " [-] Installing alacritty dependencies"
    if [ "$installDevList" = false ]; then
        . "$DOTFILES_DIR/.linux/rust.sh"
    fi
    if [ "$isApt" = true ]; then
	    sudo apt-get install -y \
            cmake libfreetype6-dev libfontconfig1-dev xclip \
            &>> "$DOTFILES_LOG_FILE"
    else
        sudo dnf install -y \
            cmake freetype-devel fontconfig-devel xclip \
            &>> "$DOTFILES_LOG_FILE"
    fi
    . "$DOTFILES_DIR/.linux/alacritty.sh"
fi

if [ "$installBed" = true ]; then
    echo " [-] Installing bed dependencies"
    if [ "$isApt" = true ]; then
	    sudo apt-get install -y \
            golang make \
            &>> "$DOTFILES_LOG_FILE"
    else
        sudo dnf install -y \
            golang make \
            &>> "$DOTFILES_LOG_FILE"
    fi
    # NOTE: GOPATH variable must be set!
    . "$DOTFILES_DIR/build_bed.sh"
fi

if [ "$installRestic" = true ]; then
    echo " [-] Installing restic dependencies"
    if [ "$isApt" = true ]; then
	    sudo apt-get install -y \
            golang \
            &>> "$DOTFILES_LOG_FILE"
    else
        sudo dnf install -y \
            golang \
            &>> "$DOTFILES_LOG_FILE"
    fi
    . "$DOTFILES_DIR/.linux/restic.sh"
fi
