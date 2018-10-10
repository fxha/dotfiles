#!/bin/bash
set -e

# Dependencies:
#   apt-get install git npm nodejs build-essential python2 make libx11-dev libxkbfile-dev libsecret-1-dev fakeroot
#   dnf install make gcc gcc-c++ glibc-devel git-core libgnome-keyring-devel tar libX11-devel python nodejs (createrepo rpmdevtools fakeroot)
#   npm i -g yarn

echo "Checking dependencies..."

if [ -n "$(command -v apt-get)" ]; then
    sudo apt-get install -y -qq \
        git npm nodejs build-essential python2.7 make \
        libx11-dev libxkbfile-dev libsecret-1-dev
    sudo npm i -g yarn
elif [ -n "$(command -v dnf)" ]; then
    sudo dnf install -y \
        make gcc gcc-c++ glibc-devel git-core python nodejs \
        libgnome-keyring-devel tar libX11-devel \
        libXScrnSaver > /dev/null
    sudo npm i -g yarn
else
    echo "Not supported package manager! Skipping..."
fi

CODE_PATH="/tmp/dotfiles/vscode"

mkdir -p /tmp/dotfiles
pushd /tmp/dotfiles > /dev/null
git clone https://github.com/Microsoft/vscode.git "$CODE_PATH"
pushd vscode > /dev/null

# checkout latest tag
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
lastestTagName=$(git describe --tags "$latestTag")
echo "Switching branch to $lastestTagName"
git checkout $latestTag

echo "Bulding Code - OSS..."

# install dependencies
yarn

# build code binaries
yarn run gulp vscode-linux-x64-min

mkdir -p ~/.bin
mv /tmp/dotfiles/VSCode-linux-x64 ~/.bin/vscode
ln -sf ~/.bin/vscode/code-oss ~/.bin/code-oss

# create desktop file
mkdir -p ~/.local/share/pixmaps
cp "$CODE_PATH/resources/linux/code.png" "$HOME/.local/share/pixmaps/code-oss.png"
cp "$DOTFILES_ROOT/.local/share/applications/code_oss.desktop" "$HOME/.local/share/applications/code-oss.desktop"

rm -rf /tmp/dotfiles/vscode
echo -e "Done\n"

popd > /dev/null # vscode
popd > /dev/null # /tmp/dotfiles

exit 0
