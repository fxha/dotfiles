#!/bin/bash
set -e

echo " [-] Apply GNOME settings"

# wm
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"

# enable workspace on all monitors
dconf write /org/gnome/shell/overrides/workspaces-only-on-primary false

# peripherals
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true

# privacy
dconf write /org/gnome/desktop/privacy/report-technical-problems false
dconf write /org/gnome/desktop/privacy/send-software-usage-stats false
dconf write /org/gnome/desktop/notifications/show-in-lock-screen false

dconf write /org/gnome/desktop/privacy/old-files-age 7
dconf write /org/gnome/desktop/privacy/recent-files-max-age 7

# desktop
dconf write /org/gnome/desktop/background/show-desktop-icons false

# gedit
dconf write /org/gnome/gedit/preferences/editor/tabs-size 2
dconf write /org/gnome/gedit/preferences/editor/insert-spaces true

# nautilus
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'icon-view'"
dconf write /org/gnome/nautilus/preferences/search-filter-time-type "'last_modified'"
dconf write /org/gnome/nautilus/preferences/search-view "'list-view'"
