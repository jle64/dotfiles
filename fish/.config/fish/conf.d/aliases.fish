alias dmesg='dmesg -T'
alias diff='diff --color'
alias e='emacs -nw'
if [ "(uname)" = "Linux" ];
	alias egrep='egrep --color'
	alias fgrep='fgrep --color'
	alias grep='grep --color'
end
alias g='grep -Ei'
alias ip='ip -c'
if which eza >/dev/null;
    alias ls='eza --group-directories-first --hyperlink --group --git --time-style long-iso'
    alias tree='ls --tree -A'
else if [ "(uname)" = "Linux" ];
    alias ls='ls --color=auto --group-directories-first --hyperlink=auto'
end
alias l='ls'
alias l.='ls -ld .*'
alias lc='ls -1'
alias la='ls -lha'
alias ll='ls -lh'
alias lsd='ls -ail'
alias sudo='sudo '
alias vi='nvim'

alias kcat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"
alias kssh="kitty +kitten ssh"
alias rg="kitty +kitten hyperlinked_grep"

alias md2pres="pandoc --to revealjs  --slide-level=2 --standalone --embed-resources --variable theme=moon"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
