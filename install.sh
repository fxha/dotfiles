#!/bin/bash
set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_ROOT
export DOTFILES_LOG_FILE="/tmp/dotfiles.log"

function cleanup() {
    if [ -d "/tmp/dotfiles" ]; then
        rm -rf /tmp/dotfiles
    fi
}

function beforeExit() {
    echo -e "\n======================================="
    echo "[ERROR] One or more commands failed!"
    echo "[ERROR] Log file: $DOTFILES_LOG_FILE"

    echo "Deleting temporary files..."
    cleanup
}

echo " ------------------------------------------------------------"
echo "< Dotfiles - Felix Häusler - https://github.com/fxha/dotfiles >"
echo " ------------------------------------------------------------"
echo ""
echo "                     __     __  ____ __      "
echo "                 ___/ /__  / /_/ _(_) /__ ___"
echo "                / _  / _ \/ __/ _/ / / -_|_-<"
echo "                \_,_/\___/\__/_//_/_/\__/___/"
echo ""

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<EOF

Usage: $(basename "$0")
        -h, --help    prints this help message
        --root        installs dotfiles for the root user
                      please execute with 'sudo' or 'sudo su -'

See the README for documentation.
EOF
    exit 0
fi

trap beforeExit EXIT
trap 'echo -e "\nAborting..."; cleanup; trap - EXIT; exit 1' INT

echo -e "dotfile setup started: $(date +'%Y-%m-%d %H:%M:%S')\n" > "$DOTFILES_LOG_FILE"

if [[ "$(id -u)" = 0 ]]; then
    if [[ -n "$SUDO_USER" && "$1" != "--root" ]]; then
        echo "The script need to be run without root permissions." >&2
        trap - EXIT
        exit 1
    else
        echo -e "\x1b[33mCurrent installation path is '$HOME'. Please run the setup without root permissions to install to local user if needed.\x1b[0m"
    fi
elif [[ "$(id -u)" != 0 && "$1" == "--root" ]]; then
    echo "The script need to be run with root permissions." >&2
    trap - EXIT
    exit 1
fi

# Bash on Windows (cygwin or mingw)
if [[ "$(uname)" == "CYGWIN"* || "$(uname)" == "MINGW"* ]]; then
    echo -e "                           windows"
    echo ""

    read -p "Do you want install dotfiles? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$DOTFILES_ROOT/scripts/install_dotfiles_windows.sh"
    fi

    trap - EXIT
    exit 0
fi

# ask for root permissions
sudo -v

# keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# source: https://gist.github.com/cowboy/3118588
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

read -p "Do you want install dotfiles? (y/n) " _installDotfiles
if [[ "$_installDotfiles" = "y" ]]; then
    "$DOTFILES_ROOT/scripts/install_dotfiles.sh"
fi

# reload bash profile
. ~/.bashrc

read -p "Do you want install additional software and/or system configuration? (y/n) " _installApps
if [[ "$_installApps" = "y" ]]; then
    "$DOTFILES_ROOT/scripts/install_packages.sh"
fi

echo "Deleting temporary files..."
cleanup

trap - EXIT
exit 0
