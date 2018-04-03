bindkey -e

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U zargs
autoload -Uz vcs_info

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source zsh specific and supplementary scripts
for config in "${XDG_CONFIG_HOME}"/shell.d/*.{z,}sh ; do
	source "${config}"
done
unset -v config

# Load local stuff
if [ -f "${HOME}/.sh_local" ]; then
	source "${HOME}/.sh_local"
fi

