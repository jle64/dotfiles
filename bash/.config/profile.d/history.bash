# history
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTDIR="${XDG_CACHE_HOME}/bash"
mkdir -p "${HISTDIR}"
HISTFILE="${HISTDIR}/history"
HISTFILESIZE=$HISTSIZE
CYAN=$(echo -e '\e[0;36m')
NORMAL=$(echo -e '\e[0m')
HISTTIMEFORMAT="${CYAN}[ %d/%m/%Y %H:%M:%S ]${NORMAL}  "
