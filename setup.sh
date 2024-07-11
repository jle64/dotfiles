#!/usr/bin/env bash
set -eu

cd "$(dirname $(readlink -f $0))"
echo cd "$(dirname $(readlink -f $0))"

CONFIG="${XDG_CONFIG_HOME:-"$HOME"/.config}"
CACHE="${XDG_CACHE_HOME:-"$HOME"/.cache}"
DATA="${XDG_DATA_HOME:-"$HOME"/.local/share}"
EXEC="$HOME"/.local/bin
FIREFOX="$HOME"/.mozilla/firefox

echo -e "\\n# Create conf symlinks"
for FILE in *; do
	[ -f "$FILE" ] || [ "$FILE" == "dconf" ] && continue
	if [ "$FILE" == "firefox" ]; then
		for DIR in $FIREFOX/$(awk -F = '/Path/ { print $2 }' $FIREFOX/profiles.ini); do
			[ -d "$DIR" ] || DIR="$FIREFOX"/"$DIR"
			echo stow $FILE -t $DIR
		done
	else
		echo stow $FILE
	fi
done

echo -e "\\n# Import/update conf"
echo "dconf load /org/gnome/settings-daemon/plugins/media-keys/ < dconf/gnome-keybindings.dconf"
echo "dconf load /org/gnome/terminal/legacy/profiles:/ < dconf/gnome-terminal.dconf"
echo "dconf load /com/gexperts/Tilix/ < dconf/tilix.dconf"
echo "xrdb -merge X/.Xresources"

echo -e "\\n# Add utilities"
test -d "$EXEC" || echo mkdir -p "$EXEC"
test -f "$EXEC"/z.sh || echo curl https://raw.githubusercontent.com/rupa/z/master/z.sh > "$EXEC"/z.sh
test -d "$DATA"/nvim/site/autoload || echo mkdir -p "$DATA"/nvim/site/autoload
test -f "$DATA"/nvim/site/autoload/plug.vim || echo curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > "$DATA"/nvim/site/autoload/plug.vim
test -d "$CONFIG"/emacs || (echo git clone --depth 1 https://github.com/doomemacs/doomemacs "$CONFIG"/emacs && echo "$CONFIG"/emacs/bin/doom sync)
which fish &>/dev/null && fish -c 'type omf &>/dev/null || echo "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish"'
if [ ! -d "$CONFIG"/zprezto ]; then
	echo "git clone --recursive git@github.com:sorin-ionescu/prezto.git $CONFIG/zprezto"
	echo "ln -s $CONFIG/zprezto/runcoms/zlogin $HOME/.zlogin"
	echo "ln -s $CONFIG/zprezto/runcoms/zshenv $HOME/.zshenv"
fi
