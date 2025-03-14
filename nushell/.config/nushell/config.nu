# Nushell Config File
#
# version = "0.88.0"

# External completer example
let carapace_completer = {|spans|
    carapace $spans.0 nushell $spans | from json
}
let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}
let multiple_completers = {|spans|
    match $spans.0 {
        z => $zoxide_completer
        zi => $zoxide_completer
        _ => $fish_completer
    } | do $in $spans
}


$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: false
    }

    table: {
        mode: rounded
        index_mode: auto
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: true
    }

    completions: {
        case_sensitive: false
        quick: true   
        partial: true   
        algorithm: "prefix"   
        external: {
            enable: true
            max_results: 100
            completer: $multiple_completers
        }
    }

    filesize: {
        metric: true
        format: "auto"
    }

    float_precision: 2
    buffer_editor: ""
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: emacs
    render_right_prompt_on_last_line: false
    use_kitty_protocol: true
    highlight_resolved_externals: true

    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
        env_change: {
            PWD: [{|before, after| null }]
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }"
        command_not_found: { null }
    }

}

source ~/.cache/starship/init.nu

alias ll = ls -l
alias z = zoxide
