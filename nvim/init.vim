let autoload_location = stdpath('data') .. '/site/autoload/plug.vim'
let vim_plug_command = '!curl -fLo ' .. autoload_location .. 
			\' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(autoload_location))
  silent exec vim_plug_command
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

" Provides commenting support.
Plug 'tpope/vim-commentary'

" Buffer tab support.
Plug 'vim-airline/vim-airline'

" Sidebar for files in current director.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/diagnostic-nvim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/deoplete-lsp'

call plug#end()

set shell=/bin/bash

" Show sign column to prevent disruptive movement from lsp.
set signcolumn=yes

" Tabs to 4. 8 is too much.
set tabstop=4
set shiftwidth=4

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
  ensure_installed = {"c", "cpp", "rust", "python", "bash", "javascript", "json", "html"},
    highlight = {
        enable = true
	}
}

EOF

" lua <<EOF
" require'nvim_lsp'.clangd.setup{on_attach=require'diagnostic'.on_attach}
" EOF

" let leader = " "

" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> gn    <cmd>NextDiagnosticCycle<CR>
" nnoremap <silent> gN    <cmd>PrevDiagnosticCycleCR>

" " Do not show popup diagnostics in insert mode https://github.com/nvim-lua/diagnostic-nvim
" " Doesn't work?
" " let g:diagnostic_insert_delay = 1

" " autocmd Filetype cpp setl omnifunc=v:lua.vim.lsp.omnifunc
" " autocmd Filetype c setl omnifunc=v:lua.vim.lsp.omnifunc

" " Use deoplete.
" let g:deoplete#enable_at_startup = 1

" " <TAB>: completion. https://github.com/Shougo/deoplete.nvim/issues/302#issuecomment-231567927
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
