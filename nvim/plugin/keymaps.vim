scriptencoding utf-8

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

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Use Ctrl+N to search the previous search term
nmap <silent> <C-N> /<Up><Up><CR>

" Show occurrences of the current word and prompt for a jump
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

" Black hole delete
map <space>d "_d
map <space>D "_D

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

" Map Ctrl+p to Ctrl+i because Tab, which is Ctrl+i, is mapped to next buffer
nnoremap <C-p> <C-i>

" Make current word uppercase in insert mode
map! <C-F> <Esc>gUiw`]a

" Edit files in the current file's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
cnoremap %$ <C-R>=fnameescape(expand('%'))<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Save and execute vimscript or lua file
map <leader><leader>x :lua require("jp.tools").save_and_exec()<CR>

" Do not open Vim's help with F1
map <F1> <Nop>
imap <F1> <Nop>

" Map <F1> to exit terminal-mode
tnoremap <F1> <C-\><C-n>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Use XX to exit Vim in normal mode
nmap <silent> XX :quitall<CR>

" Use AltGr+. to execute last Ex command
nnoremap · @:

" Disable default mapping that conflicts with ReplaceWithRegister
nunmap gri
