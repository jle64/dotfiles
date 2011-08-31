# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load auto-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# Source local definitions
[ -f ~/.bashrc_local ] && source ~/.bashrc_local


# set useful options
shopt -s no_empty_cmd_completion cdable_vars checkwinsize cmdhist dotglob extglob hostcomplete huponexit lithist nocaseglob nocasematch globstar checkjobs histappend

# make less more friendly for non-text input files, see lesspipe(1)
which lesspipe &>/dev/null && eval "$(SHELL=/bin/sh lesspipe)"

# history
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT="[ %d/%m/%Y %H:%M:%S ]  "

# umask, different if root
[ $UID != 0 ] && umask 027 || umask 022

### Environment ###

# mail
export MAILPATH=/var/spool/mail/$USER:$HOME/Mail

# manpath
#export MANPATH=`manpath`
#export MANPATH=~/Applications/pkg-toolkit-linux-i386/pkg/man:$MANPATH

# locale
if [[ `locale -a | grep fr_FR.utf8` ]]
then
	export LANG=fr_FR.UTF-8
	export LC_ALL=$LANG
fi

# apps
#which nano &>/dev/null && export EDITOR=nano && export VISUAL=$EDITOR
#which emacs &>/dev/null && export EDITOR="emacs -nw" && export VISUAL=$EDITOR
which vim &>/dev/null && export EDITOR=vim && export VISUAL=$EDITOR
which less &>/dev/null && export PAGER=less
which most &>/dev/null && export PAGER=most
#which lynx &>/dev/null && export BROWSER=lynx
which firefox &>/dev/null && export BROWSER=firefox
#which firefox-nightly &>/dev/null && export BROWSER=firefox-nightly
which mplayer &>/dev/null && export PLAYER=mplayer

### Aliases ###

alias ls="ls -hp --group-directories-first"
alias ll="ls -l"
alias lsb="ls -ail"
alias du="du -h"
alias df="df -h"
alias psc="ps xawf -eo pid,user,cgroup,args"
alias em="emacs -nw"
alias pysh="ipython -p sh"
alias http_server="python3 -m http.server"
alias screenshot="xwd -root > ~/screenshot_$RANDOM.xwd"
alias screencast="ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq ~/screencast_$RANDOM.mpg"
alias is_spam="bogofilter -s -B -v"
alias is_not_spam="bogofilter -n -B -v"
alias say="espeak --stdin"
alias dire="espeak --stdin -v fr"
alias lire="xsel -o | espeak --stdin -v fr"
alias vnc_server="x11vnc -noxdamage  -display :0 -24to32 -scr always -xkb -shared -forever -loop -ncache 12 >/dev/null"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias radio_Dogmazic="$PLAYER http://radio.musique-libre.org:8000/radio_dogmazic.ogg"
alias radio_404="$PLAYER http://www.erreur404.org/radio404.pls"
alias radio_FockNiouzes="$PLAYER http://www.fockniouzes.org/m3u/fockniouzes-ogg-128.m3u"
alias radio_OxyRadio="$PLAYER http://www.oxyradio.net/listen/hd-ogg.pls"

### Functions ###

mkcd() {
	mkdir -p "$@" && cd "$@"
}

man2pdf() {
	man -Tps $@ | ps2pdf - >${TMPDIR-/tmp}/$1.pdf && xdg-open ${TMPDIR-/tmp}/$1.pdf
}

man2html() {
	man -Thtml $@ >${TMPDIR-/tmp}/$1.html && ${BROWSER-xdg-open} ${TMPDIR-/tmp}/$1.html
}

img2txt() {
	cd ${TMPDIR-/tmp}

	import -depth 8 ocr.tif
	tesseract ocr.tif ocr -l fra
	cat ocr.txt | xsel -i -b
}

smc2sfc() {
	for file in *.smc *.swc
	do
		basename=`basename $file`
		[ -f $basename.sfc ] && dd if="$file" of="$basename.sfc" bs=512 skip=1
	done
}

random_mac() {
	if [ "$1" == "" ]
	then
		echo "Usage: random_mac interface"
		return 1
	fi
	MAC=`echo $RANDOM | md5sum | sed -r 's/^(.{12}).*$/\1/; s/([0-9a-f]{2})/\1:/g; s/:$//;'`
	sudo ifconfig $1 down
	sudo ifconfig $1 hw ether $MAC
	if [ $? == 0 ]
	then
		echo "New mac address is $MAC"
	fi
	sudo ifconfig $1 up
}

function numerical_rename() {
	if [ "$1" == "" ]
	then
		echo "Usage: numerical_rename min_numbers_lenght prefix suffix"
		return 1
	fi
	i=0
	for filename in `ls -v`
	do
		i=$(($i +1))
		newname=$i
		while [[ `echo -n $newname|wc -m` <$1 ]]
		do
			newname=0$newname
		done
		newname=$2$newname$3
		mv $filename $newname && echo "$filename > $newname" || return 1
	done
}

function thumbnail_all() {
	if [ "$1" == "" ]
	then
		echo "Usage: thumbnail_all destination_directory"
		return 1
	fi
	for filename in **
	do
		totem-video-thumbnailer -g 20 -j -s 300 "$filename" "$1/$filename.jpg"
	done
}

function chroot_init() {
	[[ $PWD == "/" || ! -d dev || ! -d proc || ! -d sys || ! -x bin/bash ]] && echo "Not in a chrootable place" && return
	sudo mount -o bind /dev dev
	sudo mount -o bind /proc proc
	sudo mount -o bind /sys sys
	sudo sh -c 'cat /etc/resolv.conf > etc/resolv.conf'
	sudo sh -c 'grep -v rootfs /proc/mounts > etc/mtab'
	sudo chroot .
}

function get_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# set title
# adapted from http://v3.sk/~lkundrak/blog/entries/bashrc.html
set_title() {
	[ "$TERM" != "xterm" ] && return
	TITLE="$@"

	if [ "$1" = fg ]
	then
		MATCH='^\[.*\]\+'
		[ -n "$2" ] && MATCH="$(echo $2 | sed 's/^%\([0-9]*\)/^\\[\1\\]/')"
		TITLE="$(jobs | grep "$MATCH" | sed 's/^[^ ]* *[^ ]* *//')"
	fi
	#TITLE="$TITLE ($USER@`hostname``pwd`)"
	echo -ne "\e]0;$TITLE\007"
}

get_flash_videos()
{
        cd /proc/`pgrep -f flash`/fd && ls -l | grep /tmp/Flash
}

### Display ###

# prompt
[[ $UID != 0 ]] && USER_COLOR=32 || USER_COLOR=31
export PS1='\[\033[`echo $USER_COLOR`m\]\u\[\033[33m\]@\h \[\033[36m\]\W\[\033[35m\]$([[ `type -t get_git_branch` == function ]] && get_git_branch) \[\033[31m\]\$\[\033[0m\] '

# color
export CLICOLOR=true
if [ "$TERM" != "dumb" ]
then
	eval "`dircolors -b`"
	alias ls="`alias ls | cut -d \' -f 2` --color=auto"
	alias grep="grep --color=auto"
	alias egrep="egrep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias most="most -c"
	alias less="less -R"
	alias tree="tree -C"
	which colordiff &>/dev/null && alias diff=colordiff
	export KDE_COLOR_DEBUG=true
	export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
	export LESS_TERMCAP_me=$'\E[0m'           # end mode
	export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
	export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
	export LESS_TERMCAP_ue=$'\E[0m'           # end underline
	export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

trap 'set +o functrace; set_title $BASH_COMMAND' DEBUG
PROMPT_COMMAND="set_title $SHELL"

### Debian stuff ###

export DEBFULLNAME="Jonathan Lestrelin"
export DEBEMAIL="zanko@daemontux.org"

### ArchLinux stuff ###

function pacman-disowned() {
	tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
	db=$tmp/db
	fs=$tmp/fs

	mkdir "$tmp"
	trap  'rm -rf "$tmp"' EXIT

	pacman -Qlq | sort -u > "$db"

	find /bin /etc /lib /lib64 /sbin /usr \
	! -path '/usr/share/mime/*' \
	! -path '/etc/ssl/certs/*' \
	! -path '/etc/fonts/*' \
	! -path '/etc/gconf/*' \
	! -name lost+found \
	! -name '*.cache'
	\( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

	comm -23 "$fs" "$db"
}

[ -f /usr/share/pkgtools/pkgfile-hook.bash ] && . /usr/share/pkgtools/pkgfile-hook.bash

### NetBSD stuff ###

#export PKG_PATH="ftp://ftp.NetBSD.org/pub/pkgsrc/packages/NetBSD/amd64/5.0_2009Q2/All"

### FreeBSD stuff ###

#export PACKAGESITE=ftp://ftp.freebsd.org/pub/FreeBSD/ports/i386/packages-stable/Latest/

# list files unknown of the packages database
#alias pkg-list-orphans="find /usr/local /usr/X11R6 -type f | xargs pkg_which -v | fgrep '?'"

### OpenBSD stuff ###

#export PKG_PATH=ftp://ftp.arcane-networks.fr/pub/OpenBSD/4.4/packages/i386/
#export FETCH_PACKAGES=yes
