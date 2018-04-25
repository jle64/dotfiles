alias l="ls"
alias ll="ls -lh"
alias l.="ls -ld .*"
alias la="ls -lhA"
alias lx="ls -lhAxb"          # sort by extension
alias lk="ls -lhASr"          # sort by size, biggest last
alias lt="ls -lhAtr"          # sort by date, most recent last
alias lsb="ls -ail"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias g="egrep -i"
alias e="emacs -nw"
alias vi="vim"
alias parallel="parallel --will-cite"
alias ip="ip -c"
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
	alias dmesg="dmesg -TL"
fi

### Color ###

if ls --version 2>/dev/null | grep -q GNU; then
	alias ls="ls --color=auto --group-directories-first"
fi

if grep -V 2>/dev/null | grep -q GNU; then
	alias grep="grep --color=auto"
	alias egrep="egrep --color=auto"
	alias fgrep="fgrep --color=auto"
fi
alias tree="tree -C"

if which colordiff >/dev/null 2>&1; then
	alias diff=colordiff
fi

