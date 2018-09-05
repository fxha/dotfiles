#!/bin/bash
set -e

# Dependencies:
#   apt-get: golang
#   dnf install golang

# build and install restic
. "$DOTFILES_DIR/build_restic.sh"

# bash autocompletion
sudo ~/.bin/restic generate --bash-completion /etc/bash_completion.d/restic
