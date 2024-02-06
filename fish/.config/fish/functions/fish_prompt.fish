function fish_prompt
    set saved_status $status
    set prev_status $status
    tty|grep -q tty; and set tty tty; or set tty pts

    echo -n '┌─ '
    if not test $prev_status = 0
        set_color --bold white
        set_color --background red
        echo -n $prev_status
        set_color --background normal
        echo -n " "
    end
    if [ $USER = root ]
        set_color red
    else
        set_color green
    end
    echo -n $USER
    if [ -z "$SSH_CLIENT" ]
        set_color brown
    else
        set_color magenta
    end
    echo -n @
    echo -n (hostname):
    set_color cyan
    echo -n (pwd|sed "s=$HOME=~=")
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_hide_untrackedfiles 1
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_upstream_ahead "↑"
    set -g __fish_git_prompt_char_upstream_behind "↓"
    set -g __fish_git_prompt_char_upstream_prefix ""
    set -g __fish_git_prompt_char_stagedstate "●"
    set -g __fish_git_prompt_char_dirtystate "✚"
    set -g __fish_git_prompt_char_untrackedfiles "…"
    set -g __fish_git_prompt_char_conflictedstate "✖"
    set -g __fish_git_prompt_char_cleanstate "✔"
    set_color magenta
    printf '%s ' (__fish_vcs_prompt)
    echo
    set_color normal
    for job in (jobs)
        set_color $retc
        if [ $tty = tty ]
            echo -n '; '
        else
            echo -n '│ '
        end
        set_color brown
        echo $job
    end
    set_color normal
    echo -n '└╼ '
    set_color normal
end
