#!/bin/bash
set -e

# Dependencies:
#   apt-get: golang
#   dnf install golang

echo " [-] Building restic"
echo "   - Downloading restic..."
#unset GOPATH
git clone https://github.com/restic/restic /tmp/dotfiles/restic &>> "$DOTFILES_LOG_FILE"

pushd /tmp/dotfiles/restic > /dev/null

# extract go version
goVersionStr=$(go version)
goRegex="(go[0-9].[0-9]+(.[0-9])?)"

echo "      Found: $goVersionStr"

if [[ $goVersionStr =~ $goRegex ]]; then
    goVersion="$BASH_REMATCH[1]"
else
    echo "[ERROR] Invalid go version."
    exit 1
fi

echo "   - Building restic..."

# for Go versions < 1.11, the option -mod=vendor needs to be removed.
if [[ "$goVersion" < "go1.11" ]]; then
    echo "restic build <1.11" >> "$DOTFILES_LOG_FILE"
    go run build.go
else
    echo "restic build  >=1.11" >> "$DOTFILES_LOG_FILE"
    go run -mod=vendor build.go
fi

mkdir -p ~/.bin
cp restic ~/.bin/restic

popd > /dev/null
