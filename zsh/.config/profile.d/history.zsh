# History
HISTDIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "${HISTDIR}"
HISTFILE="${HISTDIR}/history"
HISTSIZE=100000
SAVEHIST=100000

alias history='fc -il 1'

# History options
setopt appendhistory
setopt histignorealldups
setopt histexpiredupsfirst
setopt histsavenodups
setopt histverify
setopt incappendhistory
setopt extendedhistory
