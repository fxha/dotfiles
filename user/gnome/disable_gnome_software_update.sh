#!/bin/bash
set -e

# disable PackageKit/GNOME Software automatic update
dconf write /org/gnome/software/allow-updates false
dconf write /org/gnome/software/download-updates false

echo "ok"

exit 0
