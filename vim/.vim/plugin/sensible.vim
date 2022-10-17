"" See tpope/vim-sensible

if exists('g:loaded_sensible') || &compatible
  finish
endif
let g:loaded_sensible = 1

" 1. Filetype detection
" 2. Using filetype plugin files
" 3. Using indent files
if has('autocmd')
  filetype plugin indent on
endif

" source $VIMRUNTIME/syntax/syntax.vim
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set autoindent
set backspace=indent,eol,start
" i: scan current and included files
set complete-=i
set smarttab

" octal: If included, numbers starting with a zero
" will be considered to be octal
set nrformats-=octal

set incsearch
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

set laststatus=2
set ruler
set wildmenu

if !&scrolloff
  set scrolloff=1
endif

if !&sidescrolloff
  set sidescrolloff=5
endif

" lastline: When included as much as possible of the last line
" in a window will be displayed
set display+=lastline

if &encoding==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version ==# 703 && has("patch541")
  " Delete comment character when joining commented lines
  set formatoptions+=j
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$'
      \&& (v:version < 704 || v:version ==# 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif

set autoread

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
