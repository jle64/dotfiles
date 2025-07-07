# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc

# Make sure that environment is loaded
BASHRC=1
source ~/.profile

# Source auto-completion
for DIR in /etc /usr/share/bash-completion /usr/local/share/bash-completion; do
	[ -f ${DIR}/bash_completion ] && source ${DIR}/bash_completion
done
unset -v DIR

# Source bash specific and supplementary scripts
for config in "${XDG_CONFIG_HOME}"/profile.d/*.{ba,}sh; do
	source "${config}"
done
unset -v config

# Load local stuff
[ -f "${HOME}/.bashrc.local" ] && source "${HOME}/.bashrc.local" || true
[ -f "${HOME}/.shrc.local" ] && source "${HOME}/.shrc.local" || true
. "$HOME/.cargo/env"
