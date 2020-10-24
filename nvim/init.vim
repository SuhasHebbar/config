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

" Extensions to built-in LSP, for example, providing type inlay hints
" Plug 'tjdevries/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'

" match/pair paranthesis.
Plug 'Raimondi/delimitMate'
" Alternative option
" Plug 'jiangmiao/auto-pairs'

call plug#end()

set shell=/bin/bash

" Ctrl+S to save
nnoremap <C-s> :w<cr>

" Show sign column to prevent disruptive movement from lsp.
set signcolumn=yes

" Tabs to 4. 8 is too much.
set tabstop=4
set shiftwidth=4

" Ignore case in search
set ignorecase


" Show line number at line start.
set number


" Set mouse support
set mouse=a

" Allow backspacing over the RHS.
set backspace=indent,eol,start

" In some vim installations syntax highlighting may not be enabled.
syntax enable

" Enable filetype plugin and indent file.
filetype plugin indent on


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

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c


lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'nvim_lsp'

-- function to attach completion and diagnostics
-- when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
	require'diagnostic'.on_attach(client)
end

nvim_lsp.clangd.setup({on_attach=on_attach})
nvim_lsp.rust_analyzer.setup({on_attach=on_attach})

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
" Source: https://github.com/nvim-lua/completion-nvim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Code nav setup from :h lsp
" With minor changes
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>


" Move to next/prev diagnostic
nnoremap <silent> gn    <cmd>NextDiagnosticCycle<CR>
nnoremap <silent> gN    <cmd>PrevDiagnosticCycleCR>

" Should show prompt for code action in echo message area.
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Enable type inlay hints
" Disabling since they don't seem to always be accurate and are too
" distracting. They don't appear right next to the variable they are
" hinting at but instead appear at end of line.
" autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
" \ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }

" Visualize diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
" set updatetime=300
" Show diagnostic popup on cursor hold
" Too distracting
" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()


" See https://github.com/nvim-lua/diagnostic-nvim/blob/f6e1c74d3f486fced13dd9c22972416cc08b9721/plugin/diagnostic.vim
" for default options if configuration not set by user
" Undocumented feature as per https://github.com/nvim-lua/diagnostic-nvim/issues/13#issuecomment-621255399
let g:diagnostic_level = 'Error'

" DelimitMate <cr> expansion
let delimitMate_expand_cr = 1

let completion_confirm_key = "\<Plug>delimitMateCR"
		

" References
" https://sharksforarms.dev/posts/neovim-rust/
