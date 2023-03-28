"" https://neovim.io/doc/user/vim_diff.html
filetype plugin indent on

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
" $XDG_STATE_HOME/vim/backup
set backupdir=~/.local/state/vim/backup
set belloff=all
set nocompatible
set complete-=i
" $XDG_STATE_HOME/vim/swap
set directory=~/.local/state/vim/swap
set display=lastline
set encoding=utf-8
scriptencoding utf-8
if has('nvim')
  set fillchars=vert:│,fold:·,sep:│
elseif v:version >= 900
  set fillchars=vert:│,foldopen:-,foldclose:+
else
  set fillchars=vert:│,fold:·
endif
set formatoptions=tcqj
set nofsync
set hidden
set history=10000
set hlsearch
set incsearch
set nojoinspaces
set langnoremap
set nolangremap
set laststatus=2
if has('nvim')
  set listchars=tab:>\ \ ,trail:-,nbsp:+
else
  set listchars=tab:>\ ,trail:-,nbsp:+
endif
set mouse=nvi
set mousemodel=popup_setpos
set nrformats=bin,hex
set ruler
set sessionoptions+=unix,slash sessionoptions-=options
set shortmess+=F shortmess-=S
set showcmd
set sidescroll=1
set smarttab
set nostartofline
if has('nvim') | set switchbuf=uselast | endif
set tabpagemax=50
set tags=./tags;,tags " :help file-searching
set ttimeoutlen=50
if has('persistent_undo') | set undodir=~/.local/state/nvim/undo | endif
if has('mksession') | set viewoptions+=unix,slash viewoptions-=options | endif
if has('wildmenu') | set wildmenu | endif
set viminfo+=!
if has('nvim') | set wildoptions=pum,tagfile | endif

packadd! matchit
let g:vimsyn_embed='l'

if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif
if !isdirectory(&undodir) | call mkdir(&undodir, 'p') | endif

nnoremap Y y$
" :help <cmd>
nnoremap <c-l> <cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" :help /\V
xnoremap * y/\V<c-r>"<cr>
xnoremap # y?\V<c-r>"<cr>
nnoremap & :&&<cr>

" NOTE: In nvim, `Q` replays the last recorded macro.
nnoremap Q @@
nnoremap gQ Q
