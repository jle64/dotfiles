#
# Executes commands at the start of an interactive session.
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

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

# Other options
setopt autocd
setopt extendedglob
setopt nomatch
setopt completealiases
setopt autonamedirs
setopt listtypes
setopt nobeep
setopt nolistbeep
setopt nonotify
setopt nocorrect
setopt promptsubst

bindkey -e

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

zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' format '%d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
zstyle ':compinstall filename' '~/.zshrc'

zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

zstyle ':vcs_info:hg*' formats "(%s)[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' formats "[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' actionformats "${red}%a ${yellow}[%i%u ${blue}%b${white}%m]"

zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq true

zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"

zstyle ':vcs_info:hg*:*' unstagedstr "${green}+${white}"
zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch

zstyle ':vcs_info:git*' formats "%c%u %b%m" # hash changes branch misc
zstyle ':vcs_info:git*' actionformats "(%s|${white}%a) %12.12i %c%u %b%m"

zstyle ':vcs_info:git*:*' stagedstr "${green}S${white}"
zstyle ':vcs_info:git*:*' unstagedstr "${red}U${white}"

zstyle ':vcs_info:hg*+set-hgrev-format:*' hooks hg-hashfallback
zstyle ':vcs_info:hg*+set-message:*' hooks mq-vcs
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st

function precmd {
    vcs_info
}

# Prompt
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
RPS1='${editor_info[overwrite]}%(?:: %F{red}⏎%f)${VIM:+" %B%F{green}V%f%b"}${INSIDE_EMACS:+" %B%F{green}E%f%b"}${git_info[rprompt]}'

source ~/.sh_common
