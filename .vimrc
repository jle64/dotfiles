set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set history=100                 " keep 100 lines of command line history
set ruler                       " show the cursor position all the time
set nobackup
set nowritebackup
set smartcase
set hlsearch
syntax on			" colors !
set t_Co=256			" Moar colors !
filetype plugin on
" remember last position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
set hidden
map <TAB> :e#<CR>
cnoremap sudow w !sudo tee % >/dev/null
if has('gui_running')
	set number
	" Make shift-insert work like in Xterm
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
endif
