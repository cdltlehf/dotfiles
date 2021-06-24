" settings from tpope/vim-sensible
if has('autocmd')
    filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

set autoindent
set backspace=indent,eol,start
" set complete-=i
set smarttab

" set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
    set ttimeout
    set ttimeoutlen=100
endif

set incsearch

" :nohlsearch<C-L>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <silent> <C-L> :nohlsearch<CR>

if !&scrolloff
    set scrolloff=1
endif
if !&sidescrolloff
    set sidescrolloff=5
endif
set display+=lastline

if &encoding==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif

" settings from tpopte/vim-unimpaired
nnoremap [a :prev<CR>
nnoremap ]a :next<CR>
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [t :tprev<CR>
nnoremap ]t :tnext<CR>

nnoremap [<Space> O<ESC>j<C-e>
nnoremap ]<Space> o<ESC>k
nnoremap [e ddkP
nnoremap ]e ddp

nnoremap [oh :set<Space>hlsearch<CR>
nnoremap ]oh :set<Space>nohlsearch<CR>
nnoremap [oi :set<Space>ignorecase<CR>
nnoremap ]oi :set<Space>noignorecase<CR>

nnoremap [ol :setlocal<Space>list<CR>
nnoremap ]ol :setlocal<Space>nolist<CR>
nnoremap [on :setlocal<Space>number<CR>
nnoremap ]on :setlocal<Space>nonumber<CR>
nnoremap [or :setlocal<Space>relativenumber<CR>
nnoremap ]or :setlocal<Space>norelativenumber<CR>
nnoremap [os :setlocal<Space>spell<CR>
nnoremap ]os :setlocal<Space>nospell<CR>
nnoremap [ow :setlocal<Space>wrap<CR>
nnoremap ]ow :setlocal<Space>nowrap<CR>

nnoremap [ob :set<Space>background=dark<CR>
nnoremap ]ob :set<Space>background=light<CR>

" Dracula
packadd! dracula
let g:dracula_italic=0
colorscheme dracula

if &g:compatible
    set nocompatible
endif
set termguicolors
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" personal setting
augroup commentmap
    autocmd!
    autocmd FileType javascript nnoremap <Leader>c<Space> I// <ESC>$
    autocmd FileType c nnoremap <Leader>c<Space> I// <ESC>$
    autocmd FileType cpp nnoremap <Leader>c<Space> I// <ESC>$
    autocmd FileType python nnoremap <Leader>c<Space> I# <ESC>$
    autocmd FileType vim nnoremap <Leader>c<Space> I" <ESC>$
augroup END

set number
set relativenumber
set background=dark
set nowrap
set hidden
set smartcase
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
set showbreak=>\ 
set list listchars=tab:\|\ ,trail:·,nbsp:~,extends:>,precedes:<

inoremap jj <ESC>
