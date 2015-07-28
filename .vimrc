set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set history=100                 " keep 100 lines of command line history
set ruler                       " show the cursor position all the time
set nobackup
set nowritebackup
set smartcase
set hlsearch
set incsearch                   " type-ahead-find
set wildmenu                    " command-line completion shows a list of matches
set wildmode=longest,list:longest,full " Bash-vim completion behavior
set autochdir                   " use current working directory of a file as base path
set encoding=utf-8              " what else ?
set showcmd                     " show informations about selection while in visual mode
set guioptions-=T               " remove toolbar
" set colorcolumn=80              " highligth the 80th column

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

" keep clipboard and vim in sync
" needs vim to be built with adequate options
set clipboard=unnamed

" plug
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'jmcantrell/vim-virtualenv'
Plug 'scrooloose/syntastic'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
call plug#end()

set background=dark
colorscheme molokai
":highlight Normal ctermbg=NONE

" airline
set laststatus=2
let g:airline_theme='tomorrow'
"let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1

" keep clipboard and vim in sync
" needs vim to be built with adequate options
set clipboard=unnamed

" plug
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'jmcantrell/vim-virtualenv'
Plug 'scrooloose/syntastic'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
call plug#end()

set background=dark
colorscheme molokai
":highlight Normal ctermbg=NONE

" airline
set laststatus=2
let g:airline_theme='tomorrow'
"let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1
