" Copy file basename only, relative file path, absolute file path, dirname
command! -nargs=0 CopyFileName let @+ = expand("%:t") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFilePath let @+ = fnamemodify(expand("%"), ":.") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFileAbsolutePath let @+ = expand("%:p:~") | echo 'Copied to clipboard: ' . @+
command! -nargs=0 CopyFileDir let @+ = expand("%:p:~:h") | echo 'Copied to clipboard: ' . @+

" Format JSON using Python's json.tool
command! -nargs=0 FormatJson %!python -m json.tool

" TODO: Make it receive an optional filetype arg
command! Scratch lua require'jp.tools'.make_scratch()

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
    let name = substitute(a:selection, '.* ', '', '')
    let name = substitute(name, 'remotes/[^/]*/', '', '')
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
