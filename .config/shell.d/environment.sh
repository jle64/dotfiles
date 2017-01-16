# path
export PATH=~/.local/bin:$PATH

# apps
export EDITOR=vim
export PAGER=less
export SYSTEMD_PAGER=cat
export GIT_PAGER=cat
export BROWSER=firefox

# don't read mail
unset MAILCHECK

# less options
export LESS=-wRim

# colors
if [ ! -z "$COLORTERM" ]
then
	# 256 colors in terminal
	TERM=xterm-256color
fi
export CLICOLOR=true
if which dircolors >/dev/null 2>&1; then
	eval "$(dircolors ~/.dircolors)"
fi
if [ -f "/usr/lib/libstderred.so" ]; then
	export LD_PRELOAD="/usr/lib/libstderred.so"
fi
