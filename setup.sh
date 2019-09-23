#!/usr/bin/env bash
set -eu

cd "$(dirname $(readlink -f $0))"
echo cd "$(dirname $(readlink -f $0))"

CONFIG="${XDG_CONFIG_HOME:-"$HOME"/.config}"
CACHE="${XDG_CACHE_HOME:-"$HOME"/.cache}"
DATA="${XDG_DATA_HOME:-"$HOME"/.local/share}"
EXEC="$HOME"/.local/bin
OS=$(uname)
FIREFOX="$HOME"/.mozilla/firefox

echo -e "\\n# Create conf symlinks"
for FILE in .*; do
	[ "$FILE" == "." ] && continue
	echo "$FILE" | grep -qE '^\.(\.|git|gitignore|gitmodules)$' && continue
	if [ "$OS" == "Haiku" ]; then
		TARGET_DIR=$CONFIG
		TARGET_FILE="$(echo "$FILE" | sed 's|^\.||;s|gitconfig|git/config|')"
	else
		TARGET_DIR="$HOME"
		TARGET_FILE="$FILE"
	fi
	[ -e "$TARGET_DIR"/"$TARGET_FILE" ] && echo \# "$TARGET_DIR"/"$TARGET_FILE" already exists && continue
	echo ln -s "$(readlink -f "$FILE")" "$TARGET_DIR"/"$TARGET_FILE"
done

for FILE in config/*; do
	TARGET_FILE="$(basename "$FILE")"
	TARGET_DIR="$CONFIG"
	[ -e "$TARGET_DIR"/"$TARGET_FILE" ] && echo \# "$TARGET_DIR"/"$TARGET_FILE" already exists && continue
	echo ln -s "$(readlink -f "$FILE")" "$TARGET_DIR"/"$TARGET_FILE"
done

for FILE in local/share/*; do
	TARGET_FILE="$(basename "$FILE")"
	TARGET_DIR="$DATA"
	[ -e "$TARGET_DIR"/"$TARGET_FILE" ] && echo \# "$TARGET_DIR"/"$TARGET_FILE" already exists && continue
	echo ln -s "$(readlink -f "$FILE")" "$TARGET_DIR"/"$TARGET_FILE"
done

if [ -f $FIREFOX/profiles.ini ]; then
	for DIR in $(awk -F = '/Path/ { print $2 }' $FIREFOX/profiles.ini); do
		TARGET_DIR=$FIREFOX/$DIR
		[ -e "$TARGET_DIR"/user.js ] && echo \# $TARGET_DIR/user.js already exists && continue
		echo ln -s "$(readlink -f firefox-user.js)" $TARGET_DIR/user.js
	done
fi

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
test -d "$EXEC" || echo mkdir -p ~/.local/bin
test -f "$EXEC"/z.sh || echo wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O "$EXEC"/z.sh
test -f "$EXEC"/z.fish || echo wget https://raw.githubusercontent.com/sjl/z-fish/master/z.fish -O "$EXEC"/z.fish
test -d "$CONFIG"/base16-shell || echo "git clone https://github.com/chriskempson/base16-shell "$CONFIG"/base16-shell"

if [ ! -d "$CONFIG"/zprezto ]; then
	echo -e "\\n# Setup zsh"
	echo "git clone --recursive git@github.com:sorin-ionescu/prezto.git $CONFIG/zprezto"
	echo "ln -s $CONFIG/zprezto/runcoms/zlogin $HOME/.zlogin"
	echo "ln -s $CONFIG/zprezto/runcoms/zshenv $HOME/.zshenv"
fi
