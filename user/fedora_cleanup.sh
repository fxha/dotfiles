#!/bin/bash
set -e

read -p "Are you sure to run the Fedora cleanup script? " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo " [-] Cleaning packages..."
sudo dnf remove -y \
    telnet \
    httpd
#sudo dnf remove -y \
#    cheese \
#    evolution \
#    gnome-getting-started-docs \
#    gnome-maps \
#    gnome-weather \
#    yelp > /dev/null

# TODO: Removing the packages above will remove many packages too...
# TODO: Remove gnome-boxes without removing libvirt and qemu

# ensure evolution-data-server is installed and the system is not broken
echo " [-] Ensure GNOME dependencies..."
sudo dnf install -y evolution-data-server > /dev/null

# disable PackageKit/GNOME Software automatic update
echo " [-] Disabling PackageKit/GNOME Software automatic update"
dconf write /org/gnome/software/allow-updates false
dconf write /org/gnome/software/download-updates false

# clean PackageKit cache
echo " [-] Cleaning PackageKit cache..."
sudo pkcon refresh force -c -1 &> /dev/null

# try to disable evolution services without removing evolution-data-server
echo " [-] Shutting down evolution services"
sudo systemctl --user mask evolution-addressbook-factory.service evolution-calendar-factory.service evolution-source-registry.service

# TODO: This may break GNOME dependencies
#sudo dnf remove \
#    gnome-software \
#    gnome-online-miners
#    simple-scan \
#    tracker-miners

exit 0
