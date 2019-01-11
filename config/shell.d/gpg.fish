set -x GPG_TTY (tty)
if test -n (whereis gpgconf)
    set -x GPG_AGENT_INFO (gpgconf --list-dirs agent-socket)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
