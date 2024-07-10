if which gpgconf &>/dev/null
    set -x GPG_TTY (tty)
    set -x GPG_AGENT_INFO (gpgconf --list-dirs agent-socket)
    #set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    #set -e SSH_AUTH_SOCK
end
