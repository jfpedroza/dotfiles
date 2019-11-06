" Specify a directory for plugins
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-obsession'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'skywind3000/asyncrun.vim'
Plug 'vimwiki/vimwiki', {'branch': 'dev'}
Plug 'tbabej/taskwiki'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-system-copy'
Plug 'Raimondi/delimitMate'
Plug 'lag13/ReplaceWithRegister'
Plug 'michaeljsmith/vim-indent-object'
Plug 'rhysd/git-messenger.vim', { 'on': ['GitMessenger', '<Plug>(git-messenger)']}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'kshenoy/vim-signature'
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'honza/vim-snippets'

if has('nvim')
    Plug 'voldikss/vim-floaterm'
else
    Plug 'rhysd/vim-healthcheck'
endif

" Languages
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'alx741/vim-hindent'
Plug 'parsonsmatt/intero-neovim'
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'vhdirk/vim-cmake'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" Initialize plugin system
call plug#end()

syntax on
filetype plugin indent on

" set clipboard=unnamedplus
colorscheme darkblue

" Enable hidden buffers
set hidden

set exrc
set number
set mouse=a
set background=dark
set termguicolors
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
set completeopt=menu,preview,noinsert " Do not insert first suggestion
set timeoutlen=350
set ttimeoutlen=50
set relativenumber " Show relative number lines
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Enable persistent undo so that undo history persists across vim sessions
if has('nvim')
    set undodir=~/.local/share/nvim/undo
else
    set undodir=~/.vim/undo

    " Create directory if it doesn't exist (NeoVim creates it automatically)
    if !isdirectory(&undodir)
        call mkdir(&undodir)
    end
endif

set undofile

" ------------------------ Settings for NeoVim only  -----------------"

if has('nvim')
    set inccommand=split
endif

" -------------------- End of settings for NeoVim only  --------------"

" ------------------------ Settings intended for Vim only (not NeoVim) -----------------"
" These are here because they are defaults in NeoVim or just don't exist at
" all

" Neovim's default history is already 10000 but Vim's is 50
set history=10000

" Always show the statusline
set laststatus=2

" Set to auto read when a file is changed from the outside
set autoread

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set showcmd             " show the partially entered command

set backspace=2 " Allow all backspacing options
set ruler
set smarttab
set autoindent " Inherit indentation when inserting a new line

" Zsh like <Tab> completion in command mode
set wildmenu

" Settings that don't exist in NeoVim
if !has('nvim')
    set t_Co=256
    let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
endif

if has('gui_running')
    " Mouse
    set mousehide
    set mousemodel=popup
endif

" -------------------- End of settings intended for Vim only (not NeoVim) --------------"

let mapleader = ","
let maplocalleader = "ñ"

" Open Vim RC and load automatically
autocmd BufWritePost vimrc,init.vim,.vimrc source $MYVIMRC
nmap <leader>ñ :tabedit $MYVIMRC<CR>

" Window navigation mappings
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Tab navigation
nnoremap <silent> <leader>1 :tabnext 1<CR>
nnoremap <silent> <leader>2 :tabnext 2<CR>
nnoremap <silent> <leader>3 :tabnext 3<CR>
nnoremap <silent> <leader>4 :tabnext 4<CR>
nnoremap <silent> <leader>5 :tabnext 5<CR>
nnoremap <silent> <leader>9 :tablast<CR>

" Use 'H' and 'L' keys to move to start/end of the line
noremap H g^
noremap L g$

" Use the arrow keys for window resizing
nnoremap <Up> <C-W>-
nnoremap <Down> <C-W>+
nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>

vnoremap <Up> <C-W>-
vnoremap <Down> <C-W>+
vnoremap <Left> <C-W>>
vnoremap <Right> <C-W><

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?
nnoremap <leader><space> :nohlsearch<CR>

" Map Ctrl+C to copy to clipboard in Visual mode
" Added back to be used in minimal.vim
vmap <C-C> "+y

" Map Ctrl+V to paste (selection) in Insert mode
imap <C-V> <C-R>*

" Map Ctrl-V Ctrl-V to the default behavior of Ctrl-V
inoremap <C-V><C-V> <C-V>

" Paste from clipboard in normal mode in addition to system-copy mappings
nmap <leader>p "+p
nmap <leader>P "+P

" Replace selected text and keep the registry contents
" it's a capital 'p' on the end
xmap r "_dP

" Do the same but pasting from the clipboard
xmap <leader>r "_d"+P

" Replace line without overriding the register
" Commented out because ReplaceWithRegister already provides this functionality
" Will be added back in minimal.vim
" nnoremap grr "_ddP

" Normalize Y behavior to yank till the end of line
nnoremap Y y$

" Toggle relative numbers
nnoremap <silent> <leader>rn :set relativenumber!<CR>

" Buffer shortcuts
nmap <leader>n :enew<CR>
" Move to the next buffer
nmap <leader>l :bnext<CR>
nnoremap <Tab> :bn<CR>
" " Move to the previous buffer
nmap <leader>h :bprevious<CR>
nnoremap <S-Tab> :bp<CR>
" " Close the current buffer and move to the previous one
" " This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>
" " Show all open buffers with FZF
nmap <leader>bb :Buffers<CR>
" Move to the alternative buffer
nmap <leader>ba :b#<CR>

" Edit files in the current file's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Open FZF file finder
map <leader>f :Files<CR>

" Do not open Vim's help with F1
map <F1> <Nop>
imap <F1> <Nop>

if has('nvim')
    " Map <F1> to exit terminal-mode
    tnoremap <F1> <C-\><C-n>
endif

" Copy file basename only, file path, dirname
command! -nargs=0 CopyFileName let @+ = expand("%:t") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFilePath let @+ = expand("%:p:~") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFileDir let @+ = expand("%:p:~:h") | echo 'Copied to clipboard: ' . @+

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Remap [] to {} for latam keyboards
nmap { [
nmap } ]
omap { [
omap } ]
xmap { [
xmap } ]

" Map <localleader> { and } to the default behavior of { and }
nnoremap <localleader>{ {
nnoremap <localleader>} }
vnoremap <localleader>{ {
vnoremap <localleader>} }

" Command abbreviations
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Qall qall

" Use XX to exit Vim in normal mode
nmap <silent> XX :quitall<CR>

" Format JSON using Python's json.tool
command! -nargs=0 FormatJson %!python -m json.tool

autocmd Filetype make setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype html,javascript,scss,ruby,elixir setlocal ts=2 sts=2 sw=2
autocmd FileType haskell setlocal ts=4 sts=4 sw=4 expandtab

set wildignore=Ui_*,*.git,*.pyc
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/public/forum/**
set wildignore+=*/deps/**
set wildignore+=*/_build/**

" CoC

"" Extensions
let g:coc_global_extensions = [
            \ 'coc-explorer',
            \ 'coc-marketplace',
            \ 'coc-diagnostic',
            \ 'coc-git',
            \ 'coc-highlight',
            \ 'coc-yank',
            \ 'coc-snippets',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-tsserver',
            \ 'coc-tslint-plugin',
            \ 'coc-eslint',
            \ 'coc-tslint-plugin',
            \ 'coc-prettier',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-vimlsp',
            \ 'coc-rls',
            \ 'coc-python',
            \ 'coc-elixir'
            \ ]

let g:airline#extensions#coc#enabled = 1

"" Mappings
""" Gotos
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>dt <Plug>(coc-type-definition)
nmap <silent> <leader>di <Plug>(coc-implementation)
nmap <silent> <leader>dr <Plug>(coc-references)

""" Use `{g` and `}g` to navigate diagnostics
nmap <silent> {g <Plug>(coc-diagnostic-prev)
nmap <silent> }g <Plug>(coc-diagnostic-next)

""" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

""" Rename current word
nmap <leader>re <Plug>(coc-rename)

""" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

""" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
""" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

""" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

""" Git
nmap <silent> }c <Plug>(coc-git-nextchunk)
nmap <silent> {c <Plug>(coc-git-prevchunk)
nmap <silent> <Leader>cs :CocCommand git.chunkStage<CR>
nmap <silent> <Leader>cu :CocCommand git.chunkUndo<CR>
nmap <silent> <Leader>cp <Plug>(coc-git-chunkinfo)

""" Using CocList
"""" Show all diagnostics
nnoremap <silent> ¿d  :<C-u>CocList diagnostics<cr>
"""" Manage extensions
nnoremap <silent> ¿e  :<C-u>CocList extensions<cr>
"""" Show commands
nnoremap <silent> ¿c  :<C-u>CocList commands<cr>
"""" Find symbol of current document
nnoremap <silent> ¿o  :<C-u>CocList outline<cr>
"""" Search workspace symbols
nnoremap <silent> ¿s  :<C-u>CocList -I symbols<cr>
"""" Yanked text list
nnoremap <silent> <leader>y :<C-U>CocList -A --normal yank<CR>

map <F5> :CocCommand explorer<CR>

"" Auto commands
""" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

highlight GitGutterAdd    guifg=#ffffff guibg=#009900 ctermfg=80
highlight GitGutterChange guifg=#000000 guibg=#bbbb00 ctermfg=116
highlight GitGutterDelete guifg=#000000 guibg=#ff2222 ctermfg=200
highlight GitGutterChangeDelete guifg=#000000 guibg=#ff9122 ctermfg=200

augroup CocGroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_skip_empty_sections = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1

" Fugitive mapping
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gL :Glog<cr>
nmap <leader>gl :Git pull<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>

" Git Messenger
nmap <Leader>gm <Plug>(git-messenger)

" Normal color in popup window with custom colors
highlight gitmessengerPopupNormal term=None guifg=#eeeeee guibg=#333333 ctermfg=255 ctermbg=234

" Header such as 'Commit:', 'Author:' with 'Statement' highlight group
highlight link gitmessengerHeader Statement

" Commit hash at 'Commit:' header with 'Special' highlight group
highlight link gitmessengerHash Special

" History number at 'History:' header with 'Title' highlight group
highlight link gitmessengerHistory Title

" EasyMotion
let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnmñ'
let g:EasyMotion_startofline = 0
map ĵ <Plug>(easymotion-j)
map Ĵ <Plug>(easymotion-sol-j)
map ķ <Plug>(easymotion-k)
map Ķ <Plug>(easymotion-sol-k)
map ẁ <Plug>(easymotion-w)
map Ẁ <Plug>(easymotion-W)
map ḃ <Plug>(easymotion-b)
map Ḃ <Plug>(easymotion-B)
map ş <Plug>(easymotion-s)
map ť <Plug>(easymotion-t)
map Ť <Plug>(easymotion-T)
map ḟ <Plug>(easymotion-f)
map Ḟ <Plug>(easymotion-F)

" Mundo
nnoremap <silent> <F6> :MundoToggle<CR>

" System copy
let g:system_copy#copy_command='xclip -sel clipboard'
let g:system_copy#paste_command='xclip -sel clipboard -o'

" Ack - Ag
let g:ackprg = 'ag --vimgrep'

" AsyncRun
let g:asyncrun_open = 8

let g:SignatureMarkTextHLDynamic = 1

" Autoformat
noremap <F3> :Autoformat<CR>
autocmd BufWrite * :Autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0

" Floaterm
let g:floaterm_background = '#303030'
noremap  <silent> <F10> :FloatermToggle<CR>
noremap! <silent> <F10> <Esc>:FloatermToggle<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermToggle<CR>

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" TaskWiki
let g:taskwiki_markup_syntax = 'markdown'

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Wrap word in {:ok, word} tuple
autocmd FileType elixir nmap <silent> <localleader>o :call <SID>NormalWrap("{:ok, ", "}")<CR>
autocmd FileType elixir xmap <silent> <localleader>o :call <SID>VisualWrap("{:ok, ", "}")<CR>

" Wrap word in {:error, word} tuple
autocmd FileType elixir nmap <silent> <localleader>e :call <SID>NormalWrap("{:error, ", "}")<CR>
autocmd FileType elixir xmap <silent> <localleader>e :call <SID>VisualWrap("{:error, ", "}")<CR>

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

au BufNewFile,BufRead Dockerfile* setlocal ft=dockerfile
au BufNewFile,BufRead Jenkinsfile* setlocal ft=groovy

set secure

" ------------------------ Utility functions ----------------------"

" Wrap the current word in some text
function! s:NormalWrap(before, after)
    silent DelimitMateOff
    execute "normal bi" . a:before . "ea" . a:after . ""
    silent DelimitMateOn
endfunction

" Wrap the selected text in some text
function! s:VisualWrap(before, after) range
    let start = getpos("'<")
    let end = getpos("'>")

    silent DelimitMateOff
    call setpos('.', end)
    execute "normal a" . a:after . ""
    call setpos('.', start)
    execute "normal i" . a:before . ""
    silent DelimitMateOn
endfunction

