#!/bin/bash
set -e

# Dependencies:
#   apt-get: golang make
#   dnf install golang make

echo " [-] Building bed"

if [ -z "$GOPATH" ]; then
    echo "\$GOPATH is not set or empty."
    exit 1
fi

mkdir -p ~/.bin

echo "   [-] Downloading bed"
if [ -f "$GOPATH/src/github.com/itchyny/bed/Gopkg.lock" ]; then
    pushd "$GOPATH/src/github.com/itchyny/bed" > /dev/null
    git checkout -- Gopkg.lock
    popd > /dev/null    
fi
go get -u github.com/itchyny/bed/cmd/bed &>> "$DOTFILES_LOG_FILE"

pushd "$GOPATH/src/github.com/itchyny/bed" > /dev/null
echo "   [-] Building bed..."
make build &>> "$DOTFILES_LOG_FILE"
#cp build/bed ~/.bin/bed
popd > /dev/null
