#!/bin/bash
set -e

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub org.gimp.GIMP
#sudo flatpak install flathub org.libreoffice.LibreOffice
sudo flatpak install flathub com.github.marktext.marktext
