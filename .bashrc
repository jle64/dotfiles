# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc

# Source auto-completion
for DIR in /etc /usr/share/bash-completion /usr/local/share/bash-completion; do
	[ -f ${DIR}/bash_completion ] && source ${DIR}/bash_completion
done
unset -v DIR

# Source bash specific and supplementary scripts
for config in "${XDG_CONFIG_HOME}"/shell.d/*.{ba,}sh ; do
	source "${config}"
done
unset -v config

# Load local stuff
if [ -f "${HOME}/.sh_local" ]; then
	source "${HOME}/.sh_local"
fi
