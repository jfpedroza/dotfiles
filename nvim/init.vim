scriptencoding utf-8
lua require('jp.globals')
lua require('jp.plugins')

" colorscheme darkblue

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
set timeoutlen=350
set ttimeoutlen=50
set relativenumber " Show relative number lines
set cmdheight=2
set scrolloff=10 " Minimal number of screen lines to keep above and below the cursor.
set wildmode=longest:full,full " Fill only the longest common string

" Enable persistent undo so that undo history persists across vim sessions
set undodir=~/.local/state/nvim/undo
set undofile

set inccommand=split

let mapleader = ','
let maplocalleader = "\\"

let g:vimsyn_embed = 'l'

augroup FileTypeSpacing
  autocmd Filetype make setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype html,javascript,scss,ruby,elixir setlocal ts=2 sts=2 sw=2
  autocmd FileType haskell setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab
augroup end

set wildignore=Ui_*,*.git,*.pyc
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/public/forum/**
set wildignore+=*/deps/**
set wildignore+=*/_build/**

" Telescope
lua require("jp.telescope")

" Builtin LSP
lua require("jp.lsp")

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

" FixCursorHold
let g:cursorhold_updatetime = 100

" Mundo
nnoremap <silent> <F6> :MundoToggle<CR>

" System copy
let g:system_copy#copy_command='xclip -sel clipboard'
let g:system_copy#paste_command='xclip -sel clipboard -o'

" Ack - Rg
let g:ackprg = 'rg --vimgrep'

let g:SignatureMarkTextHLDynamic = 1

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Markdown Preview
let g:mkdp_browser = 'qutebrowser'
let g:mkdp_auto_close = 0

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

set secure
