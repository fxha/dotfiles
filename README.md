# Dotfiles

Personal dotfiles and configurations for Fedora and Debian-based desktop distros.

## Structure

```
.                 - readme, installer and dotfiles
├── .bin          - shell scripts
├── .config       - application configurations
├── .gnupg        - GnuPG configuration
├── .local        - application and system configurations
├── misc          - dconf files and other miscellaneous things
├── packages      - application and extensions lists
├── scripts       - installation scripts and utilities - don't run these scripts directly.
│   ├── .linux    -
│   └── .osx      -
├── system        - miscellaneous system files and resources
├── user          - manually build and configuration scripts
└── .vim          - vim stuff
```

## Installing

```
git clone https://github.com/fxha/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

or

**Linux:**

```
bash -c "`wget -O - https://raw.githubusercontent.com/fxha/dotfiles/master/install`"
```

**macOS:**

```
bash -c "curl -LsS https://raw.githubusercontent.com/fxha/dotfiles/master/install`"
```

Please configure your preferred `pinentry` application in `~/.gnupg/gpg-agent.conf`.

## Available modules

- `dotfiles`: dotfiles and configurations
- `software and system configuration:` Linux only
  - `base`: essential CLI packages
  - `gui-min`: dconf editor, Firefox, KeePassXC and Seahorse
  - `gui-full`: more GUI applications
  - `media`: multimedia codecs and applications
  - `dev`: development dependencies for `c/c++`, `go` and `rust`
  - `fonts`: more fonts
  - `gnome`: gnome tools and basic configuration
  - `gnome terminal theme`: One Dark terminal theme
  - `misc`: miscellaneous tools
  - `alacritty`: a cross-platform, GPU-accelerated terminal emulator
  - `bed`: vim like HEX editor
  - `restic`: fast, secure, efficient backup program

## Manual build scripts

- `Code - OSS`: [Build instructions](user/code/README.md)
- Fedora post-installation cleanup script
- Gedit One Dark theme and configuration
- GNOME shell theme

## Local settings

You can expand the dotfiles and git configuration by editing the local files.

- `~/.aliases.local`
- `~/.bash_profile.local`
- `~/.bashrc.local`
- `~/.env.local`
- `~/.functions.local`
- `~/.gitconfig.local`
- `~/.vimrc.local`

## Sensitive information

Please store sensitive information in `~/.%file%.local` or `~/.secrets`.

## License

[MIT license](LICENSE)
