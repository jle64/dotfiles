# a colorful prompt that works on {a,da,ba,mk,pdk,z}sh
# and probably other Bourne/POSIX variants

# use control chars directly because tput lacks terminfo capabilities on FreeBSD
RED="[31m"
BG_RED="[41m"
GREEN="[32m"
YELLOW="[33m"
BLUE="[34m"
MAGENTA="[35m"
CYAN="[36m"
WHITE="[37m"
BOLD="[01m"
RESET="[00m"

get_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d;s/* \(.*\)/(\1)/'
}

get_exit_status() {
	EXIT_STATUS="$?"
	if [ ${EXIT_STATUS} -ne 0 ]; then
		echo "${EXIT_STATUS}${RESET} "
	fi
}

if [ `id -u` = 0 ]; then
	USER_COLOR="${RED}${BOLD}"
else
	USER_COLOR="${GREEN}"
fi

if [ -z $HOST ]; then
	HOST=`hostname`
fi
HOST_PART=@$HOST

# make up a different color for each hostname
# inspired by https://github.com/ramnes/context-color
HOST_COLOR=$(expr 1 + $(hostname | cksum | cut -d' ' -f1) % $(expr $(tput colors) - 1))
HOST_COLOR=$(tput setaf $HOST_COLOR $HOST_COLOR $HOST_COLOR)

if [ ! -z $ZSH_VERSION ]; then
	WORK_DIR='%~'
elif [ ! -z $OLDPWD ] || [ ! -z "$KSH_VERSION" ] ; then
	WORK_DIR=\${PWD}
else
	WORK_DIR='\w'
fi

if [ ! -z "$BASH" ]; then
	PROMPT_DIRTRIM=6
fi
if [ ! -z "$BASH" -o ! -z "$ZSH_VERSION" ]; then
	EXIT_STATUS="\`get_exit_status\`"
	GIT_BRANCH="\`get_git_branch\`"
	# source git prompt stuff
	if [ -f /usr/share/git/git-prompt.sh ]; then
		source /usr/share/git/git-prompt.sh
		export GIT_PS1_SHOWDIRTYSTATE=true
		export GIT_PS1_SHOWUNTRACKEDFILES=true
		export GIT_PS1_SHOWSTASHSTATE=true
		GIT_BRANCH="\`__git_ps1\`"
	fi
fi
if [ -n "$GUIX_ENVIRONMENT" ]; then
	GUIX_ENV=" (guix)"
fi

if [ -f /run/reboot-required ]; then
	REBOOT=' ${RED}[!]'
fi

PS1="┌─ ${BG_RED}${BOLD}${WHITE}${EXIT_STATUS}${RESET}${USER_COLOR}${USER}${RESET}${HOST_COLOR}${HOST_PART}:${CYAN}${WORK_DIR}${MAGENTA}${GUIX_ENV}${GIT_BRANCH}${REBOOT}${RESET}
└╼ "

[ $TERM = "dumb" ] && PS1='$ '
