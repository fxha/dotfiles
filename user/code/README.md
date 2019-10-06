# Visual Studio Code - OSS

Execute `user/code/install_code_oss.sh` or use this guide.

## Requirements

**Debian-based:**

```sh
$ sudo dnf install -y make gcc gcc-c++ glibc-devel git-core libgnome-keyring-devel tar libX11-devel libxkbfile-dev libsecret-1-dev python createrepo rpmdevtools fakeroot nodejs
```

**RHEL:**

```sh
$ sudo dnf install -y make gcc gcc-c++ glibc-devel git-core libgnome-keyring-devel tar libX11-devel libxkbfile-devel libsecret-devel python createrepo rpmdevtools fakeroot nodejs
```

Install yarn and download repository:

```
sudo npm i -g yarn
git clone https://github.com/Microsoft/vscode.git

cd vscode
yarn

#yarn run watch
```

## Build binaries

```sh
$ yarn run gulp vscode-linux-x64-min
```

## Packages

```sh
$ yarn run gulp vscode-linux-x64-build-rpm # or -deb
```

## Enable extensions

**product.json:**

```
"extensionsGallery": {
  "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
  "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
  "itemUrl": "https://marketplace.visualstudio.com/items"
}

```

## Issues

### Too many files open

**$ sudo vim /etc/sysctl.conf:**

```
fs.inotify.max_user_watches=524288
```

or

**$ sudo vim /etc/security/limits.conf:**

```
<username>            soft    nofile          65536
<username>            hard    nofile          65536
```
