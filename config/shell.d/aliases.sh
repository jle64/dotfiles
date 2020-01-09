alias l="ls"
alias ll="ls -lh"
alias l.="ls -ld .*"
alias la="ls -lhA"
alias lx="ls -lhAxb"          # sort by extension
alias lk="ls -lhASr"          # sort by size, biggest last
alias lt="ls -lhAtr"          # sort by date, most recent last
alias lsb="ls -ail"
alias g="egrep -i"
alias e="emacsclient -a '' -t"
alias vi="nvim"
alias vim="nvim"
alias sudo="sudo "            # allow to perform alias expansion
if which gio >/dev/null 2>&1; then
	alias open="gio open"
	alias trash="gio trash"
elif which xdg-open >/dev/null 2>&1; then
	alias open="xdg-open"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

if [ "$(uname)" = "Linux" ]; then
	alias dmesg="dmesg -T"
fi

### Color ###

alias ip="ip -c"
alias tree="tree -C"

if ls --version 2>/dev/null | grep -q GNU; then
	alias ls="ls --color=auto --group-directories-first"
fi

for cmd in grep egrep fgrep diff; do
	if $cmd --version 2>/dev/null | grep -q GNU; then
		alias $cmd="$cmd --color"
	fi
done

# show file descriptors pointing to flash plugin open videos
lsflash()
{
        for pid in $(pgrep -f flash); do
                find /proc/$pid/fd -lname '/tmp/* (deleted)' -ls
        done
}

alias vnc_server="x11vnc -noxdamage -display :0 -24to32 -scr always -xkb -shared -forever -loop -ncache 12 >/dev/null"
alias mtn2="LANG=C ~/.local/bin/mtn . -f /usr/share/fonts/TTF/DejaVuSans-Bold.ttf -g 10 -j 100  -r 8 -h 200 -k 000000 -o.jpg -O thumbs -w 1280"

