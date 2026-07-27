"
" Javascript filetype plugin for running eslint
" Language:     Javascript (ft=javascript)
" Maintainer:   Mike Steinert <mike.steinert@gmail.com>
" Version:      Vim 7
" URL:          http://github.com/nvie/vim-eslint

let s:save_cpo = &cpo
set cpo&vim

function! eslint#ESLint()
    call s:ESLint()
endfunction

function! s:ESLint()
    if !executable("eslint")
        echoerr "File eslint not found. Please install it first."
        return
    endif

    " store old grep settings (to restore later)
    let l:old_gp=&grepprg
    let l:old_shellpipe=&shellpipe

    " write any changes before continuing
    if &readonly == 0
        update
    endif

    set lazyredraw   " delay redrawing
    cclose           " close any existing cwindows

    " set shellpipe to > instead of tee (suppressing output)
    set shellpipe=>

    " perform the grep itself
    let &grepprg="eslint -f unix"
    silent! grep! "%"

    " restore grep settings
    let &grepprg=l:old_gp
    let &shellpipe=l:old_shellpipe

    " process results
    let l:results=getqflist()
    let l:has_results=results != []
    if l:has_results
        " quickfix
        copen 5
        setlocal wrap
        nnoremap <buffer> <silent> c :cclose<CR>
        nnoremap <buffer> <silent> q :cclose<CR>
    endif

    set nolazyredraw
    redraw!

    " Show status
    if l:has_results == 0
        echon "ESLint check OK"
    else
        echon "ESLint found issues"
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
