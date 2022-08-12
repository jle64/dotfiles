# zsh doesn't read .profile by default
if [ -f ~/.profile ]; then
	. ~/.profile
fi
