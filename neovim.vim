set clipboard=unnamedplus
colorscheme elflord 

" Enable hidden buffers
set hidden

set number
set mouse=a
set background=dark
set cursorline
set lazyredraw
set showmatch
set listchars=tab:▸\ ,eol:¬,trail:-,nbsp:+
set updatetime=500
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set expandtab
set ignorecase
set splitbelow " Open new split panes to right and bottom, which feels more natural
set splitright

let mapleader = ","

" Open Vim RC and load automatically
autocmd BufWritePost init.vim source $MYVIMRC
autocmd BufWritePost nvim.vim source $MYVIMRC
nmap <leader>ñ :tabedit $MYVIMRC<CR>

" Window navigation mappings
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?
nnoremap <leader><space> :nohlsearch<CR>

" Buffer shortcuts
nmap <leader>n :enew<CR>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" " Move to the previous buffer
nmap <leader>h :bprevious<CR>
" " Close the current buffer and move to the previous one
" " This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" " Show all open buffers and their status
nmap <leader>bl :ls<CR>

" Edit files in the current file's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Replace selected text and keep clipboard
" it's a capital 'p' on the end
vmap r "_dP

" Must check what this is
nnoremap p p=`]

" Visually select the text that was last edited/pasted
nmap gV `[v`]

autocmd Filetype make setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype scss setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype elixir setlocal ts=2 sts=2 sw=2

set wildignore=Ui_*,*.git,*.pyc
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/public/forum/**
set wildignore+=*/deps/**

" All NERDTree
map <C-b> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Gitgutter
nmap }c <Plug>GitGutterNextHunk
nmap {c <Plug>GitGutterPrevHunk
nmap <Leader>cs <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterUndoHunk
nmap <Leader>cp <Plug>GitGutterPreviewHunk
highlight GitGutterAdd    guifg=#009900 ctermfg=80
highlight GitGutterChange guifg=#bbbb00 ctermfg=116
highlight GitGutterDelete guifg=#ff2222 ctermfg=200

" Elixir
let g:mix_format_on_save = 1
let g:ale_elixir_elixir_ls_release = '/home/jhon/Programming/Elixir/elixir-ls/rel'

" MatchTagAlways
nnoremap <leader>% :MtaJumpToOtherTag<CR>

" JavaScript
let g:jsx_ext_required=0                     " jsx highlighting in .js files

" Haskell

" ----- neovimhaskell/haskell-vim -----

" Align 'then' two spaces after 'if'
let g:haskell_indent_if = 2
" Indent 'where' block two spaces under previous body
let g:haskell_indent_before_where = 2
" Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_case_alternative = 1
" Only next under 'let' if there's an equals sign
let g:haskell_indent_let_no_in = 0

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" let g:ale_linters.haskell = ['hie', 'hlint']

au BufNewFile,BufRead Dockerfile* setlocal ft=dockerfile
