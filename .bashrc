# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# Source auto-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# set useful options
shopt -s no_empty_cmd_completion cdable_vars checkwinsize cmdhist dotglob extglob hostcomplete huponexit lithist nocaseglob nocasematch globstar checkjobs histappend

# make less more friendly for non-text input files, see lesspipe(1)
which lesspipe &>/dev/null && eval "$(SHELL=/bin/sh lesspipe)"
which lesspipe.sh &>/dev/null && eval "$(SHELL=/bin/sh lesspipe.sh)"

# history
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT="[ %d/%m/%Y %H:%M:%S ]  "

# umask, different if root
[ $UID != 0 ] && umask 027 || umask 022

### Environment ###

# more colors to xterm
[[ $TERM==xterm ]] && export TERM=xterm-256color

# mail
export EMAIL="zanko@daemontux.org"
export MAILPATH=/var/spool/mail/$USER:$HOME/Mail

# locale
if [[ `locale -a | grep fr_FR.utf8` ]]
then
	export LANG=fr_FR.UTF-8
	export LC_ALL=$LANG
fi

# apps
function get_first_available() {
	for app in $@
	do
		if [[ $(which $app 2>/dev/null) ]]
		then
			echo $app
			break
		fi
	done
}

export EDITOR=`get_first_available vim vi nano emacs`
export VISUAL=$EDITOR
export PAGER=`get_first_available less most more`
export SYSTEMD_PAGER=cat
export BROWSER=firefox
export PLAYER=mplayer

# less
export LESS=-wR

### Aliases ###

alias ls="ls -hp --group-directories-first"
alias ll="ls -l"
alias lsb="ls -ail"
alias du="du -h"
alias df="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias psc="ps xawf -eo pid,user,cgroup,args"
alias em="emacs -nw"
alias pysh="ipython -p sh"
alias http_server="python3 -m http.server"
alias screenshot="import -screen ~/screenshot_$RANDOM.png"
alias screencast="ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq ~/screencast_$RANDOM.mpg"
alias is_spam="bogofilter -s -B -v"
alias is_not_spam="bogofilter -n -B -v"
alias say="espeak --stdin"
alias speak="xsel -o | espeak --stdin"
alias dire="espeak --stdin -v fr"
alias lire="xsel -o | espeak --stdin -v fr"
alias vnc_server="x11vnc -noxdamage  -display :0 -24to32 -scr always -xkb -shared -forever -loop -ncache 12 >/dev/null"
alias mtn2="mtn . -f /usr/share/fonts/TTF/DejaVuSans-Bold.ttf -g 10 -j 100  -r 8 -h 200 -k 000000 -o.jpg -O thumbs -w 1280"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias radio_Dogmazic="$PLAYER http://radio.musique-libre.org:8000/radio_dogmazic.ogg"
alias radio_404="$PLAYER http://www.erreur404.org/radio404.pls"
alias radio_FockNiouzes="$PLAYER http://www.fockniouzes.org/m3u/fockniouzes-ogg-128.m3u"
alias radio_OxyRadio="$PLAYER http://www.oxyradio.net/listen/hd-ogg.pls"
alias dmesg="dmesg -T|sed -e 's|\(^.*'`date +%Y`']\)\(.*\)|\x1b[0;34m\1\x1b[0m - \2|g'"

### Functions ###

mkcd() {
	mkdir -p "$1" && cd "$1"
}

mkbak() {
	cp -r "`echo $1 | sed "s/\/$//"`"{,.bak-`date +%F`}
}

man2pdf() {
	man -Tps $@ | ps2pdf - >${TMPDIR-/tmp}/$1.pdf && xdg-open ${TMPDIR-/tmp}/$1.pdf
}

smv() {
	scp $1 $2 && rm $1
}

sscp() {
	filename=$(echo $1 | cut -d ':' -f2)
	scp $1 . && scp $filename $2 && rm $filename 
}

get_redirs() {
	for url in $@;
		do echo $url;
		( wget -O /dev/null -S $url 3>&1 1>&2- 2>&3- ) | egrep "HTTP/|Location";
		echo "";
	done
}

img2txt() {
	cd ${TMPDIR-/tmp}

	import -depth 8 ocr.tif
	tesseract ocr.tif ocr -l fra
	cat ocr.txt | xsel -i -b
}

# Strip headers from S-NES roms
smc2sfc() {
	for file in *.smc *.swc
	do
		basename=`basename $file`
		[ -f $basename.sfc ] && dd if="$file" of="$basename.sfc" bs=512 skip=1
	done
}

random_mac() {
	if [ "$1" == "" ] || [ "$1" == "--help" ]
	then
		echo "Usage: random_mac interface"
		return
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

function nbrename() {
	if [ "$1" == "--help" ]
	then
		echo "Usage: nb_rename [min_number_lenght] [prefix] [suffix]"
		return
	fi
	i=0
	IFS=$'\n'
	for filename in `ls -1v`
	do
		lenght=${1-3}
		prefix=$2
		suffix=${3-$(extname $filename)}
		i=$(($i +1))
		newname=$i
		while [[ $(echo -n $newname | wc -m) <$lenght ]]
		do
			newname=0$newname
		done
		newname=$prefix$newname$suffix
		mv $filename $newname && echo "$filename > $newname" || return 1
	done
}

function extname() {
	echo .$(echo "$1" | awk -F. '{print $NF}' -)
}

function chroot_init() {
	[ $1 ] && cd "$1"
	[[ $PWD == "/" || ! -d dev || ! -d proc || ! -d sys || ! -x bin/bash ]] && echo "Not in a chrootable place" && return
	sudo mount -o bind /dev dev
	sudo mount -o bind /proc proc
	sudo mount -o bind /sys sys
	sudo sh -c 'cat /etc/resolv.conf > etc/resolv.conf'
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
	[ ! -z "$SSH_CONNECTION" ] && TITLE="[$USER@`hostname`] $TITLE"
	echo -ne "\e]0;$TITLE\007"
}

flash_videos()
{
        cd /proc/`pgrep -f flash`/fd && ls -l | grep /tmp/Flash
}

### Display ###

# prompt
[[ $UID != 0 ]] && USER_COLOR=32 || USER_COLOR=31
#export PS1='\[\033[$(echo $USER_COLOR)m\]\u\[\033[33m\]@\h \[\033[36m\]\W\[\033[35m\]$([[ `type -t get_git_branch` == function ]] && get_git_branch) \[\033[31m\]\$\[\033[0m\] '
export PS1='\[\033[$(echo $USER_COLOR)m\]\u\[\033[33m\]@\h \[\033[36m\]\W\[\033[35m\] \[\033[31m\]\$\[\033[0m\] '

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
	alias tree="tree -C"
	which colordiff &>/dev/null && alias diff=colordiff
	export KDE_COLOR_DEBUG=true
	export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;33m'  # begin bold
	export LESS_TERMCAP_me=$'\E[0m'           # end mode
	export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
	export LESS_TERMCAP_so=$'\E[01;31;5;31m'  # begin standout-mode - info box
	export LESS_TERMCAP_ue=$'\E[0m'           # end underline
	export LESS_TERMCAP_us=$'\E[38;5;31m'     # begin underline
fi

trap 'set +o functrace; set_title $BASH_COMMAND' DEBUG
PROMPT_COMMAND="set_title $SHELL"

### Debian stuff ###

#export DEBFULLNAME="Jonathan Lestrelin"
#export DEBEMAIL="$EMAIL"

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

### Source local definitions ###
source ~/.bashrc_*
