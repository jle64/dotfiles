# make less more friendly for non-text input files, see lesspipe(1)
which lesspipe >/dev/null 2>&1 && eval "$(SHELL=/bin/sh lesspipe)"
which lesspipe.sh >/dev/null 2>&1 && eval "$(SHELL=/bin/sh lesspipe.sh)"