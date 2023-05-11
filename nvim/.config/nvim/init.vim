set backspace=indent,eol,start  " more powerful backspacing
set history=100                 " keep 100 lines of command line history
set ruler                       " show the cursor position all the time
set smartcase
set hlsearch
set incsearch                   " type-ahead-find
set wildmenu                    " command-line completion shows a list of matches
set wildmode=longest,list:longest,full " Bash-vim completion behavior
set autochdir                   " use current working directory of a file as base path
set encoding=utf-8              " what else ?
set showcmd                     " show informations about selection while in visual mode
set guioptions-=T               " remove toolbar
set foldmethod=indent           " auto-fold based on indentation.  (py-friendly)
set foldlevel=99
set clipboard=unnamed           " keep clipboard and vim in sync
set hidden                      " opening a new file hides rather than closes current file
                                " if it has unsaved changes
set backup
set writebackup
set undofile                    " persistent undo on
set mouse=                      " ignore mouse

" don't let backup files polute current working dir
let &backupdir=stdpath('data').'/backup'
exec mkdir(stdpath('data').'/backup', 'p')

" set <leader> key to space
:let mapleader=" "

" define how invisible characters are shown
set listchars=tab:↹·,extends:⇉,precedes:⇇,trail:␣,nbsp:␣
" press <leader>+l to enable showing invisible characters
nmap <leader>l :set list!<CR>

" remember last position
autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
map <TAB> :e#<CR>
cmap w!! w !sudo tee % > /dev/null

" plug (install with PlugInstall)
call plug#begin(stdpath('data').'/plugged')
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jmcantrell/vim-virtualenv'
Plug 'scrooloose/syntastic'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
Plug 'rodjek/vim-puppet'
Plug 'm00qek/baleia.nvim', { 'tag': 'v1.3.0' }
"Plug 'davidhalter/jedi-vim'
call plug#end()

" colors
syntax on
set termguicolors
set t_Co=256
filetype plugin on
colorscheme base16-default-dark

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" from https://old.reddit.com/r/neovim/comments/qqf4nn/psa_you_can_use_neovim_as_the_kitty_terminal/hk1nwnk/
function! PagerMode()
  set modifiable
  set noconfirm
  set nonumber
  set ft=man
  set nolist
  set showtabline=0
  set foldcolumn=0
  " colorize buffer using ansi chars
  let s:baleia = luaeval("require('baleia').setup { }")
  call s:baleia.once(bufnr('%'))
  call s:baleia.automatically(bufnr('%'))

  " remove empty spaces from end
  silent! %s/\s*$//
  let @/ = ""
  set rnu
  " map q to force quit
  cnoremap q q!
endfunction
command! PagerMode call PagerMode()
