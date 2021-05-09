let autoload_location = stdpath('data') .. '/site/autoload/plug.vim'

if has('win32')
  let curl_executable = 'curl.exe'
else
  let curl_executable = 'curl'
  set shell=/bin/bash
endif

let vim_plug_command = '!' .. curl_executable .. ' -fLo ' .. autoload_location .. 
			\' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(autoload_location))
  silent exec vim_plug_command
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

" Provides commenting support.
Plug 'tpope/vim-commentary'

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Buffer tab support.
Plug 'vim-airline/vim-airline'

" Sidebar for files in current director.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" match/pair paranthesis.
Plug 'Raimondi/delimitMate'
" Alternative option
" Plug 'jiangmiao/auto-pairs'
" neoclide/coc-pairs claims to give the same behaviour as vscode.

" Auto set file indent with :DetectIndent
Plug 'ciaranm/detectindent'

" Add semantic highlighting capability support for cxx.
" Will be used by coc-clangd
Plug 'jackguo380/vim-lsp-cxx-highlight'
call plug#end()


" Show relative line numbers, but show absolute line number on current line.
set number relativenumber

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
set clipboard=unnamedplus

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
nmap <C-w> :bp <BAR> bd! #<CR>

"" Nerdtree
map <C-b> :NERDTreeToggle<CR>


" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c


" DelimitMate <cr> expansion
let delimitMate_expand_cr = 1

" Find out why you added this...
" let completion_confirm_key = "\<Plug>delimitMateCR"


" " detectindent
" " https://www.vim.org/scripts/script.php?script_id=1171
autocmd BufReadPost * :DetectIndent

" " Set comment type to // for c, c++ and java
" " https://github.com/tpope/tpope/blob/c0af0f5ecb6f26d98e668bf1a81617e918952274/.vimrc#L482
" " https://github.com/tpope/vim-commentary/issues/15
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
		
" References
" https://sharksforarms.dev/posts/neovim-rust/

let mapleader = "\<space>"


" Based on coc.nvim settings reference src:https://github.com/neoclide/coc.nvim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gn <Plug>(coc-diagnostic-prev)
nmap <silent> gN <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap ga  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Disabling for now as it conflicts with NERDTreeToggle
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
" The next line has been disabled as it may conflict with a previous setting.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:coc_global_extensions = ['coc-json', 'coc-clangd', 'coc-pyright', 'coc-rust-analyzer', 'coc-tsserver']

highlight Pmenu ctermbg=DarkGrey ctermfg=white
highlight CocFloating ctermbg=DarkGrey

" Set .json filetype to jsonc
" https://github.com/neoclide/coc-json/issues/27#issuecomment-702873855
augroup JsonToJsonc
    autocmd! FileType json set filetype=jsonc
augroup END

" Set Ctrl-S to save file
" Source: https://stackoverflow.com/questions/3446320/in-vim-how-to-map-save-to-ctrl-s
" Source: https://vim.fandom.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
nnoremap <c-s> :update<cr>
inoremap <c-s> <c-o>:update<cr>
vnoremap <c-s> <c-c>:update<cr>

" Disable quote autoclosing for ' in rust since unclosed ' is also used for
" lifetimes.
autocmd FileType rust let b:delimitMate_quotes = "\""

