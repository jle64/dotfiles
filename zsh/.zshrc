bindkey -e

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U zargs
autoload -Uz vcs_info

# Make sure that environment is loaded
source ~/.zprofile

# Source Prezto
if [[ -s "${XDG_CONFIG_HOME}/zprezto/init.zsh" ]]; then
	source "${XDG_CONFIG_HOME}/zprezto/init.zsh"
fi

# Source zsh specific and supplementary scripts
for config in "${XDG_CONFIG_HOME}"/profile.d/*.{z,}sh; do
	source "${config}"
done
unset -v config

# Load local stuff
[ -f "${HOME}/.zshrc.local" ] && source "${HOME}/.zshrc.local" || true
[ -f "${HOME}/.shrc.local" ] && source "${HOME}/.shrc.local" || true
