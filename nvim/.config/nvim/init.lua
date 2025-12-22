-- General options
vim.opt.autochdir = true                                 -- Use current working directory of a file as base path
vim.opt.backspace = { "indent", "eol", "start" }         -- More powerful backspacing
vim.opt.backup = true                                    -- Enable backup
vim.opt.clipboard = "unnamedplus"                        -- Sync clipboard and Vim
vim.opt.encoding = "utf-8"                               -- Set encoding to UTF-8
vim.opt.foldlevel = 99                                   -- Set fold level to max
vim.opt.foldmethod = "indent"                            -- Auto-fold based on indentation (py-friendly)
vim.opt.hidden = true                                    -- Hide unsaved buffers when opening a new one
vim.opt.history = 100                                    -- Keep 100 lines of command line history
vim.opt.hlsearch = true                                  -- Highlight search results
vim.opt.incsearch = true                                 -- Type-ahead-find
vim.opt.mouse = ""                                       -- Disable mouse support
vim.opt.ruler = true                                     -- Show the cursor position all the time
vim.opt.showcmd = true                                   -- Show command in the status line while typing
vim.opt.smartcase = true                                 -- Smart case search
vim.opt.undofile = true                                  -- Enable persistent undo
vim.opt.wildmenu = true                                  -- Command-line completion shows a list of matches
vim.opt.wildmode = { "longest", "list:longest", "full" } -- Bash-like completion behavior
vim.opt.writebackup = true                               -- Enable writebackup

-- Set backup directory
local backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.backupdir = backupdir
vim.fn.mkdir(backupdir, "p")

-- Set leader key to space
vim.g.mapleader = " "

-- Invisible characters display
vim.opt.listchars = {
  tab = "↹·",
  extends = "⇉",
  precedes = "⇇",
  trail = "␣",
  nbsp = "␣"
}

-- Toggle invisible characters display with <leader>l
vim.keymap.set("n", "<leader>l", ":set list!<CR>", { silent = true })

-- Restore last cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Quick file switching
vim.keymap.set("n", "<Tab>", ":e#<CR>", { silent = true })

-- Save with sudo shortcut
vim.api.nvim_create_user_command("W", "w !sudo tee % > /dev/null", {})

-- Enable syntax highlighting
vim.cmd("syntax on")
vim.opt.termguicolors = true
vim.cmd("filetype plugin on")

-- Plugin management with vim-plug
vim.cmd([[
call plug#begin(stdpath('data') . '/plugged')
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/syntastic'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
Plug 'zenbones-theme/zenbones.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'm00qek/baleia.nvim', { 'tag': 'v1.3.0' }
call plug#end()
]])
-- vim.cmd("colorscheme base16-atelier-forest-light")
vim.cmd("colorscheme rosebones")

-- Airline configuration
vim.opt.laststatus = 2
vim.g.airline_powerline_fonts = 1
vim.g.airline_extensions_tabline_enabled = 1

-- PagerMode function
vim.api.nvim_create_user_command("PagerMode", function()
  vim.opt.modifiable = true
  vim.opt.confirm = false
  vim.opt.number = false
  vim.opt.filetype = "man"
  vim.opt.list = false
  vim.opt.showtabline = 0
  vim.opt.foldcolumn = "0"

  -- Colorize buffer using ANSI characters
  local baleia = require("baleia").setup({})
  baleia.once(vim.api.nvim_get_current_buf())
  baleia.automatically(vim.api.nvim_get_current_buf())

  -- Remove trailing spaces
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setreg("/", "")

  -- Enable relative line numbers
  vim.opt.relativenumber = true

  -- Map 'q' to force quit
  vim.keymap.set("n", "q", ":q!<CR>", { buffer = true, silent = true })
end, {})

