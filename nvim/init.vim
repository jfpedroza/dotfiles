lua require('jp.plugins')

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
set timeoutlen=350
set ttimeoutlen=50
set relativenumber " Show relative number lines
set cmdheight=2
set scrolloff=10 " Minimal number of screen lines to keep above and below the cursor.
set wildmode=longest:full,full " Fill only the longest common string

" Enable persistent undo so that undo history persists across vim sessions
set undodir=~/.local/share/nvim/undo
set undofile

set inccommand=split

let mapleader = ","
let maplocalleader = "\\"

let g:vimsyn_embed = 'l'

" Open Vim RC and load automatically
nmap <leader>ñ :tabedit $MYVIMRC<CR>
nmap <expr> <localleader>ñ &filetype == 'vim' ? ':source %<CR>' : ':source $MYVIMRC<CR>'

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
" Use Ctrl+N to search the previous search term
nmap <silent> <C-N> /<Up><Up><CR>
nnoremap <leader>w [I:ijump <C-R><C-W><S-Left><Left><Space>

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

" Map Ctrl-K Ctrl-K to the default behavior of Ctrl-K
inoremap <C-K><C-K> <C-K>

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
" Move to the alternative buffer
nmap <leader>ba :b#<CR>

" Map Ctrl+p to Ctrl+i because Tab, which is Ctrl+i, is mapped to next buffer
nnoremap <C-p> <C-i>
map! <C-F> <Esc>gUiw`]a

" Edit files in the current file's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
cnoremap %$ <C-R>=fnameescape(expand('%'))<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Do not open Vim's help with F1
map <F1> <Nop>
imap <F1> <Nop>

" Map <F1> to exit terminal-mode
tnoremap <F1> <C-\><C-n>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

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
cnoreabbrev X x

" Use XX to exit Vim in normal mode
nmap <silent> XX :quitall<CR>

" Use AltGr+. to execute last Ex command
nnoremap · @:

autocmd Filetype make setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype html,javascript,scss,ruby,elixir setlocal ts=2 sts=2 sw=2
autocmd FileType haskell setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab

set wildignore=Ui_*,*.git,*.pyc
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/public/forum/**
set wildignore+=*/deps/**
set wildignore+=*/_build/**

" CoC

"" Extensions
let g:coc_global_extensions = [
            \ 'coc-marketplace',
            \ 'coc-diagnostic',
            \ 'coc-git',
            \ 'coc-highlight',
            \ 'coc-yank',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-tsserver',
            \ 'coc-tslint-plugin',
            \ 'coc-eslint',
            \ 'coc-tslint-plugin',
            \ 'coc-prettier',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-rls',
            \ 'coc-python',
            \ 'coc-solargraph',
            \ 'coc-java'
            \ ]

let g:airline#extensions#coc#enabled = 1

"" Mappings
""" Gotos
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>dt <Plug>(coc-type-definition)
nmap <silent> <leader>di <Plug>(coc-implementation)
nmap <silent> <leader>dr <Plug>(coc-references)

""" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
nmap <silent> ]c <Plug>(coc-git-nextchunk)
nmap <silent> [c <Plug>(coc-git-prevchunk)
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
    elseif &filetype == "lua"
      let line = getline(".")
      if line =~ 'vim\.\([bwg]\?o\|opt\|api\)\.'
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    else
        call CocAction('doHover')
    endif
endfunction

" Telescope
lua require("jp.telescope")

" Builtin LSP
lua require("jp.lsp")

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
nmap <leader>gd :Gvdiff<cr>
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
let g:EasyMotion_keys = 'asdfghjklqwertyuiopzxcvbnm;'
let g:EasyMotion_startofline = 0
map ĵ <Plug>(easymotion-j)
map Ĵ <Plug>(easymotion-sol-j)
map ķ <Plug>(easymotion-k)
map Ķ <Plug>(easymotion-sol-k)
map ẁ <Plug>(easymotion-w)
map Ẁ <Plug>(easymotion-W)
map ė <Plug>(easymotion-e)
map Ė <Plug>(easymotion-E)
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

" Ack - Rg
let g:ackprg = 'rg --vimgrep'

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

" EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Markdown Preview
let g:mkdp_browser = 'qutebrowser'
let g:mkdp_auto_close = 0

" vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>

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

" ----------------------- Custom commands ------------------------- "
" Copy file basename only, file path, dirname
command! -nargs=0 CopyFileName let @+ = expand("%:t") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFilePath let @+ = expand("%:p:~") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFileDir let @+ = expand("%:p:~:h") | echo 'Copied to clipboard: ' . @+

" Format JSON using Python's json.tool
command! -nargs=0 FormatJson %!python -m json.tool

command! Scratch lua require'jp.tools'.makeScratch()

" Checkout branch/tag using FZF
" Ported from https://github.com/atweiden/fzf-extras/blob/zsh/fzf-extras.zsh
command! -nargs=? -bang Checkout call fzf#run(fzf#wrap('Checkout', {
            \ 'source': "<bang>" == "!" ? s:CheckoutLongList() : s:CheckoutShortList(),
            \ 'sink': "<bang>" == "!" ? function('s:CheckoutLongAction', []) : function('s:CheckoutShortAction', []),
            \ 'options': "<bang>" == "!" ? s:CheckoutLongCommandOptions("<args>") : s:CheckoutShortCommandOptions("<args>")
            \ }))

" List of recent branches for the Checkout command
function s:CheckoutShortList() abort
    let branches_command = 'git for-each-ref '
                \ . '--count=30 '
                \ . '--sort=-committerdate '
                \ . 'refs/heads/ '
                \ . '--format="%(refname:short)"'
    let branches = split(system(branches_command), '\n')
    return branches
endfunction

" Checkout branch when the user selects one
function s:CheckoutShortAction(selection) abort
    let name = substitute(a:selection, ".* ", "", "")
    let name = substitute(name, "remotes/[^/]*/", "", "")
    execute '!git checkout ' . name
endfunction

" Options for FZF
function! s:CheckoutShortCommandOptions(query) abort
    return [
            \ '--prompt=Checkout> ',
            \ '--no-hscroll',
            \ '+m',
            \ '--query=' . a:query
            \ ]
endfunction

" List of branches and tags for the Checkout! command
function s:CheckoutLongList() abort
    " Get git tags
    let tags = split(system('git tag'), '\n')
    " Mark each line as a tag with a color
    call map(tags, '"\x1b[31;1mtag\x1b[m\t" . v:val')

    " Get git branches
    let branches_command = 'git branch --all '
                \ . '| grep -v HEAD '
                \ . '| sed ''s/.* //'' '
                \ . '| sed ''s#remotes/[^/]*/##'' '
                \ . '| sort -u '
    let branches = split(system(branches_command), '\n')
    " Mark each line as a branch with a color
    call map(branches, '"\x1b[34;1mbranch\x1b[m\t" . v:val')

    return tags + branches
endfunction

" Checkout branch/tag when the user selects one
function s:CheckoutLongAction(selection) abort
    let name = split(a:selection, '\t')[1]
    execute '!git checkout ' . name
endfunction

" Options for FZF
function! s:CheckoutLongCommandOptions(query) abort
    return [
            \ '--ansi',
            \ '--prompt=Checkout> ',
            \ '--no-hscroll',
            \ '+m',
            \ '-d\t',
            \ '-n2',
            \ '-1',
            \ '--query=' . a:query
            \ ]
endfunction

" ------------------------ Utility functions ---------------------- "

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

