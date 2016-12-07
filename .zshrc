bindkey -e

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U zargs
autoload -Uz vcs_info

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source zsh specific scripts
for config in "${HOME}"/.config/shell.d/*.zsh ; do
	source "${config}"
done

# Load any supplementary scripts
for config in "${HOME}"/.config/shell.d/*.sh ; do
	source "${config}"
done

# Load local stuff
if [ -f "${HOME}/.sh_local" ]; then
	source "${HOME}/.sh_local"
fi

