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

set history=50    " keep 50 lines of command line history
set ruler    " show the cursor position all the time
set showcmd    " display incomplete commands
set incsearch    " do incremental searching
set nowrap    " don't wrap long lines
set encoding=utf-8  " set the encoding
set nobackup    " don't create backups
set title    " set the terminal title
set lazyredraw    " don't redraw while replaying macros
set hidden    " hide buffer on change (allows undo)
set cf      " enable error files and error jumping
set tags=./tags;$HOME  " search for tag files up to $HOME
set exrc    " enable per-directory .vimrc files
set secure    " disable unsafe commands in local .vimrc files
set noshowmode          " disable mode messages in status line

augroup vimrc
  au BufReadPre * setlocal foldmethod=syntax
  au BufWinEnter * if &fdm == 'syntax' | setlocal foldmethod=manual | endif
  au BufWinEnter * normal zR
augroup END

" add backspace and cursor keys to wrap
set whichwrap+=<,>,h,l

" set up leader
let mapleader = ","
let g:mapleader = ","

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent
  " indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Wrap lines in the QuickFix window
  autocmd FileType qf setlocal wrap linebreak

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event
  " handler (happens when dropping a file on gvim). Also don't do it
  " when the mark is in the first line, that is the default position
  " when opening a file.
  autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

  " Don't add extra indent after switch
  setlocal cinoptions=:0

  augroup END
else
  " always set autoindenting on
  set autoindent
endif " has("autocmd")

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  let g:load_doxygen_syntax=1
  let g:js_indent_log=0
  " Solarized color scheme settings
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
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>
if bufwinnr(1)
  map <S-Up> :resize +1<CR>
  map <S-Down> :resize -1<CR>
endif

" NERD Tree
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\.o$', '\.lo$', '\.la$', '\~$', '\.cache$']

" JSHint
map <leader>js :JSHint<CR>
map <leader>cs :CoffeeLint<CR>

" Errormarker
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

" Lusty Juggler
let g:LustyJugglerSuppressRubyWarning = 1

" vim-go
augroup filetype_go
  au!
  au FileType go nmap <Leader>s <Plug>(go-implements)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  au FileType go nmap <leader>r <Plug>(go-run)
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <leader>t <Plug>(go-test)
  au FileType go nmap <leader>c <Plug>(go-coverage)
  au FileType go nmap gd <Plug>(go-def)
augroup END

" Lightline
set laststatus=2
let g:lightline = {
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
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? '' :
    \ ('' != LightReadonly() ? LightReadonly() . ' ' : '') .
    \ ('' != fname ? fname : '[No Name]') .
    \ ('' != LightModified() ? ' ' . LightModified() : '')
endfunction

function! LightFugitive()
  try
    if expand('%:t') !~? 'NERD' && exists('*fugitive#head')
      let mark = '⭠ '
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightMode()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERDTree' :
    \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Kill trailing whitespace
map <leader>kw :%s/\s\+$//<CR>

" Gvim settings
if has("gui_running")
  set guifont=Mensch\ for\ Powerline\ 12
  set guicursor=a:blinkon0
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
endif
