" General setup
set nocompatible
set backspace=indent,eol,start
set nowrap
set cindent
set tabstop=8
set wildignore=*.o,*.lo
set showmode
set smartcase
set encoding=utf-8
set nobackup
set hlsearch
set history=50
set title
set ruler

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
let g:load_doxygen_syntax=1
let g:js_indent_log=0

" Buffer navigation
map <F5> :bprevious!<CR>
map <F6> :bnext!<CR>
map <F7> :bdelete!<CR>
map <F9> :make<CR>

" Errormarker
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Ctags
set tags=/home/steimic1/Documents/tags/include.tags
set tags+=/home/steimic1/Documents/tags/local.include.tags

" Gvim
set guifont=Consolas\ 14
set guicursor=a:blinkon0
