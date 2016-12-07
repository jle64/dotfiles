# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias history='fc -il 1'

# History options
setopt appendhistory
setopt histignorealldups
setopt histexpiredupsfirst
setopt histsavenodups
setopt histverify
setopt incappendhistory
setopt extendedhistory
