set nocompatible 
" Config for vim-plug
call plug#begin()

Plug 'Valloric/YouCompleteMe'

" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Both options are optional. You don't have to install fzf in ~/.fzf
" and you don't have to run the install script if you use fzf only in Vim.

Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'

call plug#end()

" In some vim installations syntax highlighting may not be enabled.
syntax enable

" Set shell used by vim to be bash due to vim having issues with non POSIX
" shells like fish
set shell=/bin/bash

" To Prevent column shift while using YouCompleteMe due to adding and removing
" of debug markers
set signcolumn=yes

" Show line numbers
set number

" Function not clearly known
set autoindent
set showmatch
let python_highlight_all = 1
set exrc
set secure
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
highlight ColorColumn ctermbg=darkgray
set colorcolumn=80

" Enable Backspace indentation and newline
set backspace=indent,eol,start

" YouCompleteMe
" Change python interpreter used by vim
let g:ycm_python_binary_path='~/.vim/venv/bin/python'
" Close autocomplete window after autocomplete suggestion is inserted
let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_filetype_specific_completion_to_disable = {
"       \ 'python': 1
"       \}

" Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_python_checkers = ["pyflakes"]
" let g:syntastic_python_pyflakes_exec = "$HOME/.vim/venv/vim_venv_wrapper/pyflakes"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" Vim style navigation
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabedit<CR>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
 
" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

" Fix delay in effect of 'O' in command mode
set ttimeoutlen=100


" Remove underlining of errors by ALE
" highlight ALEError ctermbg=none cterm=underline
" highlight ALEWarning ctermbg=none cterm=underline

" ale
" Set this in your vimrc file to disabling highlighting
let g:ale_set_highlights = 0

" change default pyls executable
let g:ale_python_pyls_executable = $HOME . '/.vim/bin/ale_pyls'


