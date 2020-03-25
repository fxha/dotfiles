#!/bin/bash
set -e

create_local_bash() {
    local filePath="$HOME/$1"
    if [ ! -e "$FILE_PATH" ] && [ -n "${1+x}" ]; then
        echo -e "#!/usr/bin/env bash\n" >> "$filePath"
    fi
}

setup_git() {
    echo " [-] git credentials"

    local gitName=""
    read -p "  Please enter your git name: " gitName

    local gitEmail=""
    read -p "  Please enter your git email: " gitEmail

    local gitSigningKey=""
    read -p "  Please enter your default git key-id to sign commits or empty to disable it: " gitSigningKey

    local gitSign="false"
    if ask_yes "  Do you want sign every commit by default?"; then
        gitSign="true"
    fi

    local enableGitName=""
    if [ -z "$gitName" ]; then
        gitName="your_name"
        enableGitName="#"
    fi

    local enableGitEmail=""
    if [ -z "$gitEmail" ]; then
        gitEmail="your_email"
        enableGitEmail="#"
    fi

    local enablegitSigningKey=""
    if [ -z "$gitSigningKey" ]; then
        gitSigningKey="your_signing_key"
        enablegitSigningKey="#"
    fi

    local enableGitSign=""
    if [ -z "$gitSign" ]; then
        gitSign="false"
        enableGitSign="#"
    fi

    echo "[user]" \
"
$enableGitName    name = $gitName
$enableGitEmail    email = $gitEmail
$enablegitSigningKey    signingkey = $gitSigningKey

[commit]
$enableGitSign    gpgsign = $gitSign" \
    >> "$HOME/.gitconfig.local"
}

export DOTFILES_ROOT
DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR="$DOTFILES_ROOT"

if [ "$(basename "$DOTFILES_ROOT")" = "scripts" ]; then
    DOTFILES_ROOT="$(dirname "$DOTFILES_ROOT")"
else
    DOTFILES_DIR="$DOTFILES_DIR/scripts"
fi

# load utils
. "$DOTFILES_DIR/utils.sh"

echo "Installing dotfiles..."

mkdir -p "$HOME/.bin"
mkdir -p "$HOME/.go/bin"
mkdir -p "$HOME/projects"

# root dotfiles
declare -a dotfileLinks=(
    "$DOTFILES_ROOT/.aliases"
    "$DOTFILES_ROOT/.bash_completion_helper.sh"
    "$DOTFILES_ROOT/.bash_logout"
    "$DOTFILES_ROOT/.bash_profile"
    "$DOTFILES_ROOT/.bash_prompt"
    "$DOTFILES_ROOT/.bashrc"
    "$DOTFILES_ROOT/.env"
    "$DOTFILES_ROOT/.functions"
    "$DOTFILES_ROOT/.gitconfig"
    "$DOTFILES_ROOT/.ssh_utils"
    "$DOTFILES_ROOT/.tmux.conf"
    "$DOTFILES_ROOT/.vimrc"
)

# link root dotfiles
for src in "${dotfileLinks[@]}"
do
    dst="$HOME/$(basename "${src}")"
    echo " [-] Linking $dst"
    link_file "$src" "$dst"
done

# copy local ssh config file
if [ ! -f "$HOME/.ssh_utils.local" ]; then
    cp "$DOTFILES_ROOT/.ssh_utils.local" "$HOME/.ssh_utils.local"

    if [ "$DOTFILES_NO_INTERACTION" = false ]; then
        if ask_no "Do you want to automatically start the SSH agent?"; then
            sed -i 's/#DISABLE_AUTO_SSH_AGENT=1/DISABLE_AUTO_SSH_AGENT=1/g' "$HOME/.ssh_utils.local"
        fi
    fi
fi

# link .profile to .bash_profile on Debain-based distros
if [ "$(uname)" == "Linux" ] && [ -n "$(command -v apt-get)" ]; then
    link_file "$DOTFILES_ROOT/.bash_profile" "$HOME/.profile"
fi

echo " [-] Linking custom files and directories..."

if [ "$(uname)" == "Linux" ]; then
    # custom install directories:
    mkdir -p "$HOME/.config/alacritty"
    link_file "$DOTFILES_ROOT/.config/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
    mkdir -p "$HOME/.config/Code - OSS/User"
    link_file "$DOTFILES_ROOT/.config/Code - OSS/User/settings.json" "$HOME/.config/Code - OSS/User/settings.json"
    mkdir -p "$HOME/.config/keepassxc"
    copy_file "$DOTFILES_ROOT/.config/keepassxc/keepassxc.ini" "$HOME/.config/keepassxc/keepassxc.ini"

    # don't copy/download QtCreator configuration and custom GNOME icons/theme because these themes are licensed under GPL.
    # please use private dotfiles and/or 'user/gnome/shell_theme_setup.sh'.
elif [ "$(uname)" == "Darwin" ]; then
    # TODO: macOS
    echo "Application configuration is currently not supported on macOS!"
fi

# set ownership to current user and permissions to read and write for current user only.
mkdir -p "$HOME/.gnupg"
chown -R "$(whoami)" "$HOME/.gnupg"
chmod -f 600 "$HOME/.gnupg/*" || true
chmod 700 "$HOME/.gnupg"
copy_file "$DOTFILES_ROOT/.gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
copy_file "$DOTFILES_ROOT/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

# TODO: setup '.ssh' and copy server configuration (ssh_config)

# create vim directory
mkdir -p "$HOME/.vim/after/syntax"
mkdir -p "$HOME/.vim/backups"
mkdir -p "$HOME/.vim/swaps"
mkdir -p "$HOME/.vim/undo"
link_file "$DOTFILES_ROOT/.vim/after/syntax/c.vim" "$HOME/.vim/after/syntax/c.vim"
link_file "$DOTFILES_ROOT/.vim/after/syntax/cpp.vim" "$HOME/.vim/after/syntax/cpp.vim"

# git credentials
if [[ "$DOTFILES_NO_INTERACTION" = false && ! -e "$HOME/.gitconfig.local" ]]; then
    setup_git
fi

# create .local config files if not already exists.
echo " [-] Create local config files"
create_local_bash ".secrets"
create_local_bash ".aliases.local"
create_local_bash ".bash_logout.local"
create_local_bash ".bash_profile.local"
create_local_bash ".bashrc.local"
create_local_bash ".env.local"
create_local_bash ".functions.local"
echo "" > "$HOME/.vimrc.local"

echo -e "Done\n"
