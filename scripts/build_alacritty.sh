#!/bin/bash
set -e

# Dependencies:
#   apt-get install cargo rustc cmake libfreetype6-dev libfontconfig1-dev xclip
#   dnf install cmake fcargo rust reetype-devel fontconfig-devel xclip

echo " [-] Building alacritty"

#cargo install --git https://github.com/jwilm/alacritty

mkdir -p /tmp/dotfiles
pushd /tmp/dotfiles > /dev/null
git clone https://github.com/jwilm/alacritty.git &>> "$DOTFILES_LOG_FILE"

pushd alacritty > /dev/null
echo "   This may take a while..."
cargo build --release &>> "$DOTFILES_LOG_FILE"
cargo install &>> "$DOTFILES_LOG_FILE"

# macOS
#make app
#cp -r target/release/osx/Alacritty.app /Applications/Alacritty.app

popd > /dev/null # alacritty
popd > /dev/null # /tmp/dotfiles
