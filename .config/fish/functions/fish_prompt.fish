function fish_prompt
	and set retc green; or set retc red
    tty|grep -q tty; and set tty tty; or set tty pts

    set_color normal
    echo -n '┌─ '
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
    echo -n (hostname)
    set_color cyan
    echo -n :(pwd|sed "s=$HOME=~=")
    
    # Check if acpi exists
    if not set -q __fish_nim_prompt_has_acpi
    	if type acpi > /dev/null
    		set -g __fish_nim_prompt_has_acpi ''
    	else
    		set -g __fish_nim_prompt_has_acpi '' # empty string
    	end
    end
    	
    if test "$__fish_nim_prompt_has_acpi"
		if [ (acpi -a 2> /dev/null | grep off) ]
			set_color red
			echo -n (acpi -b|cut -d' ' -f 4-)
			set_color black
		end
	end
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
    set_color red
    echo -n '$ '
    set_color normal
end
