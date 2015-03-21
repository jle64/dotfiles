#!/bin/sh
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf
