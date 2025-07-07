# make sure bashrc is read even if started as login shell
# as a ~/.bash_profile can inhibit this
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
. "$HOME/.cargo/env"
