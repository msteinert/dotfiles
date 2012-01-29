" Vim syntax file
" Language: C re2c extension
" Maintainer: Mike Steinert <mike.steinert@gmail.com>
" Last Change: 2010-04-14

" Clear previous syntax settings
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Pull in the C syntax
if version < 600
    so <sfile>:p:h/c.vim
else
    runtime! syntax/c.vim
    unlet b:current_syntax
endif

syn region re2cCode matchgroup=PreProc start="\/\*!re2c" end="\*\/" contains=cComment,cCommentL
syn cluster re2cTop contains=re2cCode

let b:current_syntax = "re2c"
