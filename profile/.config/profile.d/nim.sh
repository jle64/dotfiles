# path
if ! echo $PATH | grep -q $HOME/.nimble/bin && test -d $HOME/.nimble/bin; then
	export PATH=$PATH:$HOME/.nimble/bin
fi
