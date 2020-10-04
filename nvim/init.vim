call plug#begin(stdpath('data') . '/plugged')

" Provides commenting support.
Plug 'tpope/vim-commentary'

" Buffer tab support.
Plug 'vim-airline/vim-airline'

" Sidebar for files in current director.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

set shell=/bin/bash

" Show line number at line start.
set number


" Set mouse support
set mouse=a

" Allow backspacing over the RHS.
set backspace=indent,eol,start

" In some vim installations syntax highlighting may not be enabled.
syntax on

" https://github.com/microsoft/WSL/issues/4440 WSL2 clipboard not shared
" between Linux and Windows
" WSL yank support
let s:win_clip = '/mnt/c/Windows/System32/clip.exe'  " change this path
" according to your mount point
if executable(s:win_clip)
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:win_clip, @0) | endif
	augroup END
endif

"" vim-airline config source: https://web.archive.org/web/20200905075813/https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'


let mapleader = " "

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <C-t> :enew<cr>
"
" Move to the next buffer
nmap <M-2> :bnext!<CR>

" Move to the previous buffer
nmap <M-1> :bprevious!<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <C-w> :bp <BAR> bd #<CR>

"" Nerdtree
map <C-b> :NERDTreeToggle<CR>

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "c",     -- one of "all", "language", or a list of languages
    highlight = {
        enable = true              -- false will disable the whole extension
	}
}

EOF
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   ensure_installed = {"c", "cpp", "rust", "python", "bash", "javascript", "json", "html"},     -- one of "all", "language", or a list of languages
"     highlight = {
"         enable = true              -- false will disable the whole extension
" 	}
" }

" EOF
