# Set ENV to a file invoked each time sh is started for interactive use
ENV=$HOME/.shrc; export ENV

# Set XDG_ vars to their default values if they're empty
# so we can rely on them being there elsewhere
if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -n "$BASH_VERSION" ] && [ -z "$BASHRC" ] ; then
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi
