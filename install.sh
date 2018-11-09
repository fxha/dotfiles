#!/bin/bash
set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_ROOT
export DOTFILES_LOG_FILE="/tmp/dotfiles.log"

DOTFILES_NO_INTERACTION=false
DOTFILES_ACCEPT_MSCOREFONTS_EULA=false
DOTFILES_ARG_ROOT=false
DOTFILES_ARG_HELP=false

export overwrite_all=false
export backup_all=false
export skip_all=false

# source: https://stackoverflow.com/a/14203146
for i in "$@"
do
case $i in
    --no-interaction)
    DOTFILES_NO_INTERACTION=true
    export overwrite_all=true
    ;;
    --accept-mscorefonts-eula)
    DOTFILES_ACCEPT_MSCOREFONTS_EULA=true
    ;;
    --root)
    DOTFILES_ARG_ROOT=true
    ;;
    -h|--help)
    DOTFILES_ARG_HELP=true
    ;;
    --log-path=*)
    export DOTFILES_LOG_FILE="${i#*=}"
    shift # skip =* value
    ;;
    *)
    # unknown options
    ;;
esac
done

export DOTFILES_NO_INTERACTION
export DOTFILES_ACCEPT_MSCOREFONTS_EULA

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

if [[ "$DOTFILES_ARG_HELP" = true ]]; then
    cat <<EOF

Usage: $(basename "$0") [options]

Options:
  -h, --help                  Print this help message
  --root                      Install dotfiles for the root user
                              Please execute with 'sudo' or 'sudo su -'
  --accept-mscorefonts-eula   Accept the Microsoft's TrueType core fonts license
  --no-interaction            Automatically full installation without user interaction
  --log-path=%file%           Set log directory

See the README for documentation.
EOF
    exit 0
fi

trap beforeExit EXIT
trap 'echo -e "\nAborting..."; cleanup; trap - EXIT; exit 1' INT

echo -e "dotfile setup started: $(date +'%Y-%m-%d %H:%M:%S')\n" > "$DOTFILES_LOG_FILE"

if [[ "$(id -u)" = 0 ]]; then
    if [[ -n "$SUDO_USER" && "$DOTFILES_ARG_ROOT" = false ]]; then
        echo "The script need to be run without root permissions." >&2
        trap - EXIT
        exit 1
    else
        echo -e "\x1b[33mCurrent installation path is '$HOME'. Please run the setup without root permissions to install to local user if needed.\x1b[0m"
    fi
elif [[ "$(id -u)" != 0 && "$DOTFILES_ARG_ROOT" = true ]]; then
    echo "The script need to be run with root permissions." >&2
    trap - EXIT
    exit 1
fi

# Bash on Windows (cygwin or mingw)
if [[ "$(uname)" == "CYGWIN"* || "$(uname)" == "MINGW"* ]]; then
    echo -e "                           windows"
    echo ""

    if [ "$DOTFILES_NO_INTERACTION" = false ]; then
        read -p "Do you want install dotfiles? (y/n) " -n 1 -r
        echo ""
    else
        REPLY="y"
    fi

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

if [ "$DOTFILES_NO_INTERACTION" = false ]; then
    read -p "Do you want install dotfiles? (y/n) " _installDotfiles
else
    _installDotfiles="y"
fi

if [[ "$_installDotfiles" = "y" ]]; then
    "$DOTFILES_ROOT/scripts/install_dotfiles.sh"
fi

# reload bash profile
. ~/.bashrc

if [ "$DOTFILES_NO_INTERACTION" = false ]; then
    read -p "Do you want install additional software and/or system configuration? (y/n) " _installApps
else
    _installApps="y"
fi

if [[ "$_installApps" = "y" ]]; then
    "$DOTFILES_ROOT/scripts/install_packages.sh"
fi

echo "Deleting temporary files..."
cleanup

trap - EXIT
exit 0
