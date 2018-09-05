#!/bin/bash
set -e

#if cmd_exists "rustup"; then
#    echo "rustup already installed!"
#    return
#fi

# install rust
. "$DOTFILES_DIR/rust.sh"

# enable bash tab completion
mkdir -p /tmp/dotfiles
rustup completions bash > /tmp/dotfiles/rustup.bash-completion
sudo mv /tmp/dotfiles/rustup.bash-completion /etc/bash_completion.d/rustup.bash-completion
