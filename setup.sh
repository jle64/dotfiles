#!/bin/sh
set -eu
cd $(dirname $(realpath $0))

echo cd $(dirname $(realpath $0))

echo git submodule update --init --recursive

for file in .* .config/* .local/bin/*; do
	echo $file | grep -qE '^\.(\.|config|local|git|gitignore|gitmodules)$' && continue
	[ -e "$HOME"/"$file" ] && echo \# "$HOME"/"$file" already exists && continue
	echo ln -s "$(realpath "$file")" "$HOME"/"$file"
done

echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf"
echo "dconf load /com/gexperts/Tilix/ < tilix.dconf"
