#!/bin/bash
set -e

echo " [-] Downloading and installing rust"

# skip confirmation prompt. Cargo's bin directory is already added to the environment path.
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
export PATH="$PATH:$HOME/.cargo/bin"

rustc --version

#rustup toolchain install nightly

rustup default stable &>> "$DOTFILES_LOG_FILE"
rustup update &>> "$DOTFILES_LOG_FILE"

#cargo +nightly install clippy
#cargo install rustfmt

#rustup component add rust-src
#rustup component add rls
