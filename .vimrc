filetype plugin indent on
packadd! dracula

if &g:compatible
  set nocompatible
endif

syntax enable
let g:dracula_italic=0
colorscheme dracula

set termguicolors
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>

set backspace=indent,eol,start
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" set laststatus=2
" set showtabline=2

" Learn Vimscript the Hard Way {{{
" echo ">^.^<"

set number
set relativenumber
set numberwidth=1
nnoremap _ ddkP
nnoremap - ddp

inoremap <c-u> <esc>viwUea
" nnoremap <c-u> viwU

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

iabbrev @@ 28900401+cdltlehf@users.noreply.github.com

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
vnoremap <leader>" <esc>`<i"<esc>`>la"<esc>
vnoremap <leader>' <esc>`<i'<esc>`>la'<esc>
nnoremap H ^
nnoremap L $

inoremap jj <esc>
" inoremap <esc> <nop>

augroup commentmap
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <localleader>c I// <esc>
    autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>
    autocmd FileType vim nnoremap <buffer> <localleader>c I" <esc>
augroup END

onoremap p i(
onoremap b /return<cr>
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>
onoremap al( :<c-u>normal! F)va(<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F{vi{<cr>
onoremap an{ :<c-u>normal! f{va{<cr>
onoremap al{ :<c-u>normal! F{va{<cr>

onoremap ih :<c-u>execute "normal! ?^\\(=\\{2,}\\\|-\\{2,}\\)$\r:nohlsearch\rkvg_"<cr>
onoremap ah :<c-u>execute "normal! ?^\\(=\\{2,}\\\|-\\{2,}\\)$\r:nohlsearch\rg_vk0"<cr>

set statusline=%f
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L

augroup filetype=vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

set foldlevelstart=0
nnoremap <leader>g :silent execute "grep -R" . shellescape(expand("<cWORD>")) . " ."<cr>:copen 5<cr>


