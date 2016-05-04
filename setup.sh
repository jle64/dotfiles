#!/bin/sh
set -e
cd $(dirname $(realpath $0))

echo cd $(dirname $(realpath $0))

echo git submodule update --init --recursive

for file in .*; do
	[ "$file" = "." -o "$file" = ".." -o "$file" = ".config" ] && continue
	[ "$file" = ".git" -o "$file" = ".gitignore" -o "$file" = ".gitmodules" ] && continue
	[ -e "$HOME"/"$file" ] && echo \# "$HOME"/"$file" already exists && continue
	echo ln -s "$(realpath "$file")" "$HOME"/"$file"
done

for file in .config/*; do
	[ "$file" = "." -o "$file" = ".." ] && continue
	[ -e "$HOME"/.config/"$(basename "$file")" ] && echo \# "$HOME"/.config/"$file" already exists && continue
	echo ln -s "$(realpath "$file")" "$HOME"/.config/"$(basename "$file")"
done

echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf"
echo "lesskey $HOME/.lesskey"

echo ln -s "$(realpath prezto)" "$HOME"/.zprezto
