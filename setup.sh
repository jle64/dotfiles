#!/bin/bash
set -eu
cd "$(dirname $(realpath $0))"

echo cd "$(dirname $(realpath $0))"

CONFIG="${XDG_CONFIG_HOME:-"$HOME"/.config}"
CACHE="${XDG_CACHE_HOME:-"$HOME"/.cache}"
OS=$(uname)

echo -e "\\n# Create conf symlinks"
for FILE in .*; do
	echo "$FILE" | grep -qE '^\.(|\.|git|gitignore|gitmodules)$' && continue
	if [ "$OS" == "Haiku" ]; then
		TARGET_DIR=$CONFIG
		TARGET_FILE="$(echo "$FILE" | sed 's|^\.||;s|gitconfig|git/config|')"
	else
		TARGET_DIR="$HOME"
		TARGET_FILE="$FILE"
	fi
	[ -e "$TARGET_DIR"/"$TARGET_FILE" ] && echo \# "$TARGET_DIR"/"$TARGET_FILE" already exists && continue
	echo ln -s "$(realpath "$FILE")" "$TARGET_DIR"/"$TARGET_FILE"
done

for FILE in config/*; do
	TARGET_FILE="$(basename "$FILE")"
	TARGET_DIR="$CONFIG"
	[ -e "$TARGET_DIR"/"$TARGET_FILE" ] && echo \# "$TARGET_DIR"/"$TARGET_FILE" already exists && continue
	echo ln -s "$(realpath "$FILE")" "$TARGET_DIR"/"$TARGET_FILE"
done

echo -e "\\n# Import/update conf"
echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf"
echo "dconf load /com/gexperts/Tilix/ < tilix.dconf"
echo "xrdb -merge .Xresources"
echo "lesskey lesskey"

echo -e "\\n# Create cache directories"
test -d "$CACHE"/vim || echo mkdir -p "$CACHE"/vim/{backup,swap,undo}
test -d "$CACHE"/emacs || echo mkdir -p "$CACHE"/emacs

echo -e "\\n# Add utilities"
test -d ~/.local/bin || echo mkdir -p ~/.local/bin
test -f ~/.local/bin/z.sh || echo wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/.local/bin/z.sh
test -d "$CONFIG"/base16-shell || echo "git clone https://github.com/chriskempson/base16-shell ${CONFIG}/base16-shell"

if [ ! -d "$CONFIG"/zprezto ]; then
	echo -e "\\n# Setup zsh"
	echo "git clone --recursive git@github.com:sorin-ionescu/prezto.git $CONFIG/zprezto"
	echo "ln -s $CONFIG/zprezto/runcoms/zlogin $HOME/.zlogin"
	echo "ln -s $CONFIG/zprezto/runcoms/zshenv $HOME/.zshenv"
fi
