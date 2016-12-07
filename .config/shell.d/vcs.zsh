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
