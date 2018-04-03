_theme() {
        local cur=${COMP_WORDS[COMP_CWORD]}
	local config="${XDG_CONFIG_HOME:-$HOME/.config}"
        COMPREPLY=( $( compgen -W "$( ls -1 $config/base16-shell/scripts/base16*.sh | sed 's/.*base16-\(.*\)\.sh$/\1/' )" -- $cur ) )
        return 0
}
complete -F _theme theme

if uname -v | grep -q FreeBSD; then
	_service () {
		local cur
		cur=${COMP_WORDS[COMP_CWORD]}
		COMPREPLY=( $( compgen -W '$( service -l )' -- $cur ) )
		return 0
	}
	complete -F _service service
fi
