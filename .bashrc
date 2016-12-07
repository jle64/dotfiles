# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc

# Source auto-completion
for DIR in /etc /usr/share/bash-completion /usr/local/share/bash-completion; do
	[ -f ${DIR}/bash_completion ] && source ${DIR}/bash_completion
done

# Source bash specific scripts
for config in "${HOME}"/.config/shell.d/*.bash ; do
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
