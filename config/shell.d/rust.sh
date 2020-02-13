# path
if ! echo $PATH | grep -q $HOME/.cargo/bin && test -d $HOME/.cargo/bin; then
	export PATH=$PATH:$HOME/.cargo/bin
fi
