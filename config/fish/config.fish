set fish_greeting ''

set -gx PATH $PATH ~/.local/bin/

set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"

for file in $XDG_CONFIG_HOME/shell.d/*.fish
    source $file
end
