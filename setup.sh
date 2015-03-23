#!/bin/sh

for file in .*; do
	[ "$file" == "." -o "$file" == ".." ] && continue
	[ "$file" == ".git" -o "$file" == ".gitignore" ] && continue
	echo ln -s "$(realpath "$file")" "$HOME/$(basename "$file")"
done

echo dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf
echo dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf
