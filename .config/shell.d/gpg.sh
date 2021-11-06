export GPG_TTY=$(tty)
if whereis gpgconf >/dev/null 2>&1; then
    export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
