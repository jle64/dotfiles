# path
export PATH=~/.local/bin:$PATH

# apps
export EDITOR=vim
export PAGER=less
export SYSTEMD_PAGER=cat
export BROWSER=firefox

if [ -n "$KATE_PID" ]
then
	export GIT_EDITOR="kate -b"
fi

# don't read mail
unset MAILCHECK

# less options
export LESS=-wRim

# colors
if [ -n "$COLORTERM" ]
then
	# 256 colors in terminal
	TERM=xterm-256color
fi
export CLICOLOR=true
if which dircolors >/dev/null 2>&1; then
	eval "$(dircolors ~/.dircolors)"
fi
