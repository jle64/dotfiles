# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# Source auto-completion
for DIR in /etc /usr/share/bash-completion /usr/local/share/bash-completion; do
	[ -f ${DIR}/bash_completion ] && source ${DIR}/bash_completion
done

# make less more friendly for non-text input files, see lesspipe(1)
which lesspipe &>/dev/null && eval "$(SHELL=/bin/sh lesspipe)"
which lesspipe.sh &>/dev/null && eval "$(SHELL=/bin/sh lesspipe.sh)"

# set shell options
shopt -s autocd
shopt -s cdable_vars
shopt -u cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u direxpand
shopt -u dirspell
shopt -s dotglob
shopt -s execfail
shopt -s expand_aliases
shopt -u extdebug
shopt -s extglob
shopt -s extquote
shopt -u failglob
shopt -s force_fignore
shopt -u globstar
shopt -s gnu_errfmt
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s hostcomplete
shopt -s huponexit
shopt -s interactive_comments
shopt -u lastpipe
shopt -s lithist
shopt -u login_shell
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -u nocaseglob
shopt -u nocasematch
shopt -u nullglob
shopt -s progcomp
shopt -s promptvars
shopt -u restricted_shell
shopt -u shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

# history
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
CYAN=$(echo -e '\e[0;36m')
NORMAL=$(echo -e '\e[0m')
HISTTIMEFORMAT="${CYAN}[ %d/%m/%Y %H:%M:%S ]${NORMAL}  "

# umask, different if root
[ $UID != 0 ] && umask 027 || umask 022

### Environment ###

# mail
export EMAIL="jonathan.lestrelin@gmail.com"
export MAILPATH=/var/spool/mail/$USER:$HOME/Mail
export DEBFULLNAME="Jonathan Lestrelin"
export DEBEMAIL="$EMAIL"

# locale
if [[ `locale -a | grep fr_FR.utf8` ]]
then
	export LANG=fr_FR.utf8
fi

export EDITOR=vim
export PAGER=less
export SYSTEMD_PAGER=cat
export GIT_PAGER=cat
export BROWSER=firefox

# less
export LESS=-wR

### Aliases ###

alias ll="ls -lh"
alias l="ll"
alias l.="ls -d .*"
alias la="ls -lA"
alias lx="ls -lAxb"          # sort by extension
alias lk="ls -lASr"          # sort by size, biggest last
alias lt="ls -lAtr"          # sort by date, most recent last
alias lsb="ls -ail"
alias sl="ls"
alias cta="cat"
alias df="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias g='egrep -i'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias open="xdg-open"
alias trash="gvfs-trash"
alias search="tracker-search"
alias em="emacs -nw"
alias vi="vim"

### Functions ###

cl() {
	cd "$1" && ls
}

md() {
	mkdir -p "$1" && cd "$1"
}

h() {
	test -z $1 && history || history | egrep -i $1
}

function get_git_branch() {
	GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
	[[ $PWD != $HOME ]] && [[ -d .git ]] && echo $GIT_BRANCH
}

# set title
# adapted from http://v3.sk/~lkundrak/blog/entries/bashrc.html
set_title() {
	[ "$TERM" != "xterm-256color" ] && return
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

# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func () {
	local x2 the_new_dir adir index
	local -i cnt

	if [[ $1 ==  "--" ]]; then
		dirs -v
		return 0
	fi

	the_new_dir=$1
	[[ -z $1 ]] && the_new_dir=$HOME

	if [[ ${the_new_dir:0:1} == '-' ]]; then
		#
		# Extract dir N from dirs
		index=${the_new_dir:1}
		[[ -z $index ]] && index=1
		adir=$(dirs +$index)
		[[ -z $adir ]] && return 1
		the_new_dir=$adir
	fi

	#
	# '~' has to be substituted by ${HOME}
	[[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

	#
	# Now change to the new dir and add to the top of the stack
	pushd "${the_new_dir}" > /dev/null
	[[ $? -ne 0 ]] && return 1
	the_new_dir=$(pwd)

	#
	# Trim down everything beyond 11th entry
	popd -n +11 2>/dev/null 1>/dev/null

	#
	# Remove any other occurence of this dir, skipping the top of the stack
	for ((cnt=1; cnt <= 10; cnt++)); do
		x2=$(dirs +${cnt} 2>/dev/null)
		[[ $? -ne 0 ]] && return 0
		[[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
		if [[ "${x2}" == "${the_new_dir}" ]]; then
			popd -n +$cnt 2>/dev/null 1>/dev/null
			cnt=cnt-1
		fi
	done

	return 0
}

alias cd=cd_func

-() {
        cd -1
}
--() {
        cd -2
}
---() {
        cd -3
}

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
	eval `$SSHAGENT $SSHAGENTARGS` >/dev/null
	trap "kill $SSH_AGENT_PID" 0
fi

### Display ###

# prompt
[[ $UID != 0 ]] && USER_COLOR='32' || USER_COLOR='1;31'
export PS1='┌─ $(es=$?; if [ $es -ne 0 ]; then echo -e "\\033[1;31m\\033[1;7m$es\\033[1;0m "; fi)\[\033[$(echo $USER_COLOR)m\]\u\[\033[0;33m\]@\h:\[\033[36m\]\w\[\033[34m\]$(get_git_branch)\[\033[35m\] \[\033[31m\]\$\[\033[0m\]
└╼ '

# color
if [ ! -z $COLORTERM ]
then
	# 256 colors in terminal
	TERM=xterm-256color
fi
export CLICOLOR=true
# GNU ls colors (assume dircolors means GNU ls)
if which dircolors &>/dev/null; then
	eval $(dircolors ~/.dircolors)
	alias ls="ls --color=auto --group-directories-first"
fi
if which colordiff &>/dev/null; then
	alias diff=colordiff
fi
if [ -f "/usr/lib/libstderred.so" ]; then
	export LD_PRELOAD="/usr/lib/libstderred.so"
fi
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias tree="tree -C"
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;33m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[01;31;5;31m'  # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[38;5;31m'     # begin underline

trap 'set +o functrace; set_title $BASH_COMMAND' DEBUG
PROMPT_COMMAND="history -a; set_title $SHELL"

### Source host specific definitions ###
if [ -f ~/.bashrc_local ]; then
	source ~/.bashrc_local
fi
