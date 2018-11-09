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

# root dotfiles
declare -a dotfileLinks=(
    "$DOTFILES_ROOT/.aliases"
    "$DOTFILES_ROOT/.bash_profile"
    "$DOTFILES_ROOT/.bash_prompt"
    "$DOTFILES_ROOT/.bashrc"
    "$DOTFILES_ROOT/.env"
    "$DOTFILES_ROOT/.functions"
    "$DOTFILES_ROOT/.gitconfig"
    "$DOTFILES_ROOT/.vimrc"
)

# link root dotfiles
for src in "${dotfileLinks[@]}"
do
    dst="$HOME/$(basename "${src}")"
    echo " [-] Linking $dst"
    link_file "$src" "$dst"
done

echo " [-] Linking custom files and directories..."

# set ownership to current user and permissions to read and write for current user only.
mkdir -p "$HOME/.gnupg"
chown -R "$(whoami)" "$HOME/.gnupg"
chmod -f 600 "$HOME/.gnupg/*" || true
chmod 700 "$HOME/.gnupg"
copy_file "$DOTFILES_ROOT/.gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
copy_file "$DOTFILES_ROOT/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

# .vim directory
mkdir -p "$HOME/.vim/after/syntax"
mkdir -p "$HOME/.vim/backups"
mkdir -p "$HOME/.vim/swaps"
mkdir -p "$HOME/.vim/undo"
link_file "$DOTFILES_ROOT/.vim/after/syntax/c.vim" "$HOME/.vim/after/syntax/c.vim"
link_file "$DOTFILES_ROOT/.vim/after/syntax/cpp.vim" "$HOME/.vim/after/syntax/cpp.vim"

# git credentials
if [[ "$DOTFILES_QUIET" = false && ! -e "$HOME/.gitconfig.local" ]]; then
    setup_git
fi

# create .local config files if not already exists.
echo " [-] Create local config files"
create_local_bash ".secrets"
create_local_bash ".aliases.local"
create_local_bash ".bash_profile.local"
create_local_bash ".bashrc.local"
create_local_bash ".env.local"
create_local_bash ".functions.local"
echo "" > "$HOME/.vimrc.local"

echo -e "Done\n"
