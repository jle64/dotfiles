# path
if ! echo $PATH | grep -q $HOME/.local/bin; then
	export PATH=$HOME/.local/bin:$PATH
fi

# apps
export EDITOR=vim
export PAGER=less
export SYSTEMD_PAGER=cat
export BROWSER=firefox

if [ -n "$KATE_PID" ]
then
	export GIT_EDITOR="kate -b"
elif [ -n "$VSCODE_PID" ]
then
	export GIT_EDITOR="code --wait"
fi

# don't read mail
unset MAILCHECK

# colors
export CLICOLOR=true
if which dircolors >/dev/null 2>&1; then
	eval "$(dircolors ~/.dircolors)"
fi
