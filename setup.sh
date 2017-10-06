#!/bin/sh
set -eu
cd $(dirname $(realpath $0))

echo cd $(dirname $(realpath $0))

for file in .* .config/* .local/bin/*; do
	echo $file | grep -qE '^\.(\.|config|local|git|gitignore|gitmodules)$' && continue
	[ -e "$HOME"/"$file" ] && echo \# "$HOME"/"$file" already exists && continue
	echo ln -s "$(realpath "$file")" "$HOME"/"$file"
done

echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf"
echo "dconf load /com/gexperts/Tilix/ < tilix.dconf"

if [ ! -d "$HOME"/.zprezto ]; then
	echo "git clone git@github.com:sorin-ionescu/prezto.git ~/.prezto"
	echo "ln -s "$HOME"/.prezto/runcoms/zprofile "$HOME"/.zprofile"
	echo "ln -s "$HOME"/.prezto/runcoms/zlogin "$HOME"/.zlogin"
	echo "ln -s "$HOME"/.prezto/runcoms/zshenv "$HOME"/.zshenv"
fi
