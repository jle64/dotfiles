green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
RPS1='${editor_info[overwrite]}%(?:: %F{red}⏎%f)${VIM:+" %B%F{green}V%f%b"}${INSIDE_EMACS:+" %B%F{green}E%f%b"}${git_info[rprompt]}'
