zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' format '%d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U zargs
autoload -Uz vcs_info

# See http://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html
# And http://blog.rolinh.ch/linux/zsh-afficher-les-infos-des-vcs-git-mercurial-svn-etc-dans-son-prompt/
reset="%{${reset_color}%}"
white="%{$fg[white]%}"
green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
blue="%{$fg[blue]%}"
yellow="%{$fg[yellow]%}"

zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

zstyle ':vcs_info:hg*' formats "(%s)[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' formats "[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' actionformats "${red}%a ${yellow}[%i%u ${blue}%b${yellow}%m]"

zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq true

zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"

zstyle ':vcs_info:hg*:*' unstagedstr "${green}+${yellow}"
zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch

zstyle ':vcs_info:git*' formats "%c%u %b%m" # hash changes branch misc
zstyle ':vcs_info:git*' actionformats "(%s|${yellow}%a) %12.12i %c%u %b%m"

zstyle ':vcs_info:git*:*' stagedstr "${green}S${yellow}"
zstyle ':vcs_info:git*:*' unstagedstr "${red}U${yellow}"

zstyle ':vcs_info:hg*+set-hgrev-format:*' hooks hg-hashfallback
zstyle ':vcs_info:hg*+set-message:*' hooks mq-vcs
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st

function precmd {
    vcs_info
}

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt autocd
setopt extendedglob
setopt nomatch
unsetopt beep
unsetopt notify
setopt completealiases
bindkey -e

# oh-my-zsh
ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git zsh-syntax-highlighting)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source $ZSH/oh-my-zsh.sh

if [[ $UID -eq 0 ]]; then
  user_color="${fg_bold[red]}"
else
  user_color="${fg_no_bold[green]}"
fi
return_code="%(?..%{${bg_bold[red]}${fg_bold[white]}%}%?%{${reset_color}%} )"
user_at_host="%{${user_color}%}%n${deco}%{${fg_no_bold[yellow]}%}@%m"
cwd="%{${fg_no_bold[cyan]}%}%32<...<%~"
sign="%{${fg_no_bold[red]}%}%#"

PS1="┌─ ${return_code}${user_at_host}:${cwd} ${sign}%{${reset_color}%}
└╼ "
RPS1='${vcs_info_msg_0_}'

