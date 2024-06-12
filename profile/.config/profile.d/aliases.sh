if [ "$(uname)" = "Linux" ]; then # TODO: check for gnu ls instead
	alias ls="ls --group-directories-first --hyperlink=auto"
	alias l="ls --group-directories-first --hyperlink=auto"
	alias ll="ls -lh --group-directories-first --hyperlink=auto"
else
	alias l="ls"
	alias ll="ls -lh"
fi
alias l.="ls -ld .*"
alias la="ls -lhA"
alias lx="ls -lhAxb"          # sort by extension
alias lk="ls -lhASr"          # sort by size, biggest last
alias lt="ls -lhAtr"          # sort by date, most recent last
alias lsb="ls -ail"
alias g="egrep -i"
alias e="emacs -nw"
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
	alias ls="ls --color=auto --group-directories-first --hyperlink=auto"
fi

for cmd in grep egrep fgrep diff; do
	if $cmd --version 2>/dev/null | grep -q GNU; then
		alias $cmd="$cmd --color"
	fi
done
