" Load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Don't autocomplete these file extensions.
set wildignore=*.o,*.lo

" Don't use Ex mode, use Q for formatting
map Q gq

set history=50         " keep 50 lines of command line history
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set incsearch          " do incremental searching
set nowrap             " don't wrap long lines
set encoding=utf-8     " set the encoding
set nobackup           " don't create backups
set title              " set the terminal title
set lazyredraw         " don't redraw while replaying macros
set hidden             " hide buffer on change (allows undo)
set cf                 " enable error files and error jumping
set tags=./tags;$HOME  " search for tag files up to $HOME
set exrc               " enable per-directory .vimrc files
set secure             " disable unsafe commands in local .vimrc files
set noshowmode         " disable mode messages in status line
set cinoptions=:0      " don't indent after a switch

augroup vimrc
  au!
  au BufReadPre * setlocal foldmethod=syntax
  au BufWinEnter *
  \ if &fdm == 'syntax' |
  \   setlocal foldmethod=manual |
  \ endif
  au BufWinEnter * normal zR
augroup END

" Add backspace and cursor keys to wrap
set whichwrap+=<,>,h,l

" Set up leader
let mapleader=","
let g:mapleader=","

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Load indent files
  filetype plugin indent on
  augroup vimrcEx
    au!
    au FileType text setlocal textwidth=78
    au FileType qf setlocal wrap linebreak
    " Jump to the last known cursor position
    au BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  " Always set autoindenting on
  set autoindent
endif " has("autocmd")

" Switch syntax highlighting on, when the terminal has colors.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  let g:load_doxygen_syntax=1
  let g:js_indent_log=0
  colorscheme solarized
  set background=dark
endif

" Paste annoyance
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Buffer navigation
map <F5> :bprevious!<CR>
map <F6> :bnext!<CR>
map <F7> :bdelete!<CR>

" Window navigation
nmap <silent> <S-h> :wincmd h<CR>
nmap <silent> <S-j> :wincmd j<CR>
nmap <silent> <S-k> :wincmd k<CR>
nmap <silent> <S-l> :wincmd l<CR>
if bufwinnr(1)
  map <S-Up> :resize +1<CR>
  map <S-Down> :resize -1<CR>
  map <S-Right> :vertical resize +1<CR>
  map <S-Left> :vertical resize -1<CR>
endif

" NERD Tree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$', '\.lo$', '\.la$', '\~$', '\.cache$']
augroup nerd_tree
  au!
  au BufEnter *
  \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") |
  \   q |
  \ endif
augroup END

" Errormarker
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

" Lusty Juggler
let g:LustyJugglerSuppressRubyWarning=1

" Python
let g:no_flake8_maps=1
augroup filetype_python
  au!
  au FileType python setlocal formatprg=autopep8\ -
  au FileType python map <buffer> <F8> :call Flake8()<CR>
augroup END

" Go
let g:go_fmt_command = "goimports"
augroup filetype_go
  au!
  au FileType go nmap <Leader>s <Plug>(go-implements)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>r <Plug>(go-run)
  au FileType go nmap <Leader>b <Plug>(go-build)
  au FileType go nmap <Leader>t <Plug>(go-test)
  au FileType go nmap <Leader>c <Plug>(go-coverage)
  au FileType go nmap <Leader>v <Plug>(go-vet)
  au FileType go nmap <Leader>l :GoLint<CR>
  au FileType go nmap gd <Plug>(go-def)
augroup END

" Javascript
let g:jshintprg="jsxhint"
augroup filetype_javascript
  au!
  au FileType javascript nmap <Leader>l :JSHint<CR>
augroup END

" Coffeescript
augroup filetype_coffee
  au!
  au FileType coffee nmap <Leader>l :CoffeeLint! \| cwindow<CR>
augroup END

" Rust
augroup filetype_rust
  au!
  au FileType rust compiler cargo
  au FileType rust nmap <Leader>r :make run<CR>
  au FileType rust nmap <Leader>b :make build<CR>
  au FileType rust nmap <Leader>t :make test<CR>
  au FileType rust nmap <Leader>tb :make bench<CR>
augroup END

" Lightline
set laststatus=2
let g:lightline={
  \ 'colorscheme': 'solarized',
  \ 'mode_map': {
  \   'n': 'N',
  \   'c': 'N',
  \   'i': 'I',
  \ },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
  \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype' ] ],
  \ },
  \ 'component_function': {
  \   'filename': 'LightFilename',
  \   'fugitive': 'LightFugitive',
  \   'mode': 'LightMode',
  \   'readonly': 'LightReadonly',
  \ },
  \ 'separator': { 'left': '⮀', 'right': '⮂' },
  \ 'subseparator': { 'left': '⮁', 'right': '⮃' },
\ }

function! LightModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightReadonly()
  return &ft !~? 'help' && &readonly ? '⭤' : ''
endfunction

function! LightFilename()
  let fname=expand('%:t')
  return fname =~ 'NERD_tree' ? '' :
  \ ('' != LightReadonly() ? LightReadonly() . ' ' : '') .
  \ ('' != fname ? fname : '[No Name]') .
  \ ('' != LightModified() ? ' ' . LightModified() : '')
endfunction

function! LightFugitive()
  try
    if expand('%:t') !~? 'NERD' && exists('*fugitive#head')
      let mark='⭠ '
      let _=fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightMode()
  let fname=expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERDTree' :
  \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup extra_whitespace
  au!
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

" Kill trailing whitespace
map <Leader>kw :%s/\s\+$//<CR>

" Gvim settings
if has("gui_running")
  set guifont=Mensch\ for\ Powerline\ 14
  set guicursor=a:blinkon0
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
endif
