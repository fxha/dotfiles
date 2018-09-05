#!/bin/bash
set -e

ask_yes() {
    local _user_answer
    read -p "$1 (y/n) " _user_answer
    [[ "$_user_answer" =~ ^[Yy]$ ]]
}
ask_no() {
    local _user_answer
    read -p "$1 (y/n) " _user_answer
    ! [[ "$_user_answer" =~ ^[Yy]$ ]]
}

cmd_exists() {
    command -v "$1" &> /dev/null
}

# Source: https://github.com/bendrucker/dotfiles/blob/master/scripts/bootstrap [MIT]

# Colorized output
cinfo() {
    echo -e "\x1b[32m$1\x1b[0m"
}
cwarn() {
    echo -e "\x1b[33m[WARNING] $1\x1b[0m"
}
cerror() {
    echo -e "\x1b[31m[ERROR] $1\x1b[0m"
}

link_file () {
  local src="$1" dst="$2"

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink "$dst")"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

	    cat << EOF
File already exists: $dst ($(basename "$src")), what do you want to do?
 [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?
EOF
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite="${overwrite:-$overwrite_all}"
    backup="${backup:-$backup_all}"
    skip="${skip:-$skip_all}"

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      echo " [-] removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "$dst.backup"
       echo " [-] moved $dst to $dst.backup"
    fi

    if [ "$skip" == "true" ]
    then
       echo " [-] skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
     echo " [-] linked $1 to $2"
  fi
}

copy_file () {
  local src="$1" dst="$2"

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink "$dst")"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

	    cat << EOF
File already exists: $dst ($(basename "$src")), what do you want to do?
 [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?
EOF
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite="${overwrite:-$overwrite_all}"
    backup="${backup:-$backup_all}"
    skip="${skip:-$skip_all}"

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      echo " [-] removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "$dst.backup"
       echo " [-] moved $dst to $dst.backup"
    fi

    if [ "$skip" == "true" ]
    then
       echo " [-] skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    cp "$1" "$2"
     echo " [-] copied $1 to $2"
  fi
}
