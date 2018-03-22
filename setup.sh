#!/bin/sh
set -eu
cd $(dirname $(realpath $0))

echo cd $(dirname $(realpath $0))

echo -e "\n# Create conf symlinks"
for file in .* .config/*; do
	echo $file | grep -qE '^\.(|\.|config|git|gitignore|gitmodules)$' && continue
	[ -e "$HOME"/"$file" ] && echo \# "$HOME"/"$file" already exists && continue
	echo ln -s "$(realpath "$file")" "$HOME"/"$file"
done

echo -e "\n# Import/update conf"
echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf"
echo "dconf load /com/gexperts/Tilix/ < tilix.dconf"
echo "xrdb -merge .Xresources"
echo "lesskey lesskey$(shuf -n 1 -e 1 2 3)-*"

echo -e "\n# Create cache directories"
test -d ~/.cache/vim || echo mkdir -p ~/.cache/vim/{backup,swap,undo}
test -d ~/.cache/emacs || echo mkdir -p ~/.cache/emacs

echo -e "\n# Add utilities"
test -d ~/.local/bin || echo mkdir -p ~/.local/bin
test -f ~/.local/bin/z.sh || echo wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/.local/bin/z.sh

if [ ! -d "$HOME"/.prezto ]; then
	echo -e "\n# Setup zsh"
	echo "git clone git@github.com:sorin-ionescu/prezto.git "$HOME"/.prezto"
	echo "ln -s "$HOME"/.prezto/runcoms/zprofile "$HOME"/.zprofile"
	echo "ln -s "$HOME"/.prezto/runcoms/zlogin "$HOME"/.zlogin"
	echo "ln -s "$HOME"/.prezto/runcoms/zshenv "$HOME"/.zshenv"
fi
