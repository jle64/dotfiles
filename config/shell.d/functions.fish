function cl
    cd $argv ; and ls
end

function md
    mkdir -p $argv ; and cd $argv
end

function h
    history -t search $argv
end
