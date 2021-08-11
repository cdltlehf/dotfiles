" Dracula Color Pallette
" https://spec.draculatheme.com/
let background='#282a36'
let foreground='#f8f8f2'
let selection='#44475a'
let comment='#6272a4'

let red='#ff5555'
let orange='#ffb86c'
let yellow='#f1fa8c'
let green='#50fa7b'
let purple='#bd93f9'
let cyan='#8be9fd'
let pink='#ff79c6'

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

" if !has('nvim') && &ttimeoutlen == -1
    " set ttimeout
    " set ttimeoutlen=100
" endif

set incsearch

" :nohlsearch<C-L>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <silent> <C-L> :nohlsearch<CR>

" if !&scrolloff
    " set scrolloff=1
" endif
" if !&sidescrolloff
    " set sidescrolloff=5
" endif
" set display+=lastline

if &encoding==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif

" settings from tpopte/vim-unimpaired
" argument
nnoremap [a :prev<CR>
nnoremap ]a :next<CR>
" buffer
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
" location list
" nnoremap [l :lprev<CR>
" nnoremap ]l :lnext<CR>
" quickfix
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
" tab page
nnoremap [t :tprev<CR>
nnoremap ]t :tnext<CR>


nnoremap [<Space> O<ESC>j<C-E>
nnoremap ]<Space> o<ESC>k
nnoremap [e ddkP
nnoremap ]e ddp

nnoremap [oh :set<Space>hlsearch<CR>
nnoremap ]oh :set<Space>nohlsearch<CR>
nnoremap [oi :set<Space>ignorecase<CR>
nnoremap ]oi :set<Space>noignorecase<CR>

" nnoremap [ol :setlocal<Space>list<CR>
" nnoremap ]ol :setlocal<Space>nolist<CR>
nnoremap [on :setlocal<Space>number<CR>
nnoremap ]on :setlocal<Space>nonumber<CR>
nnoremap [or :setlocal<Space>relativenumber<CR>
nnoremap ]or :setlocal<Space>norelativenumber<CR>
" nnoremap [os :setlocal<Space>spell<CR>
" nnoremap ]os :setlocal<Space>nospell<CR>
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

" tab (buffer) line
augroup tabline_highlight
    autocmd!
    autocmd ColorScheme * execute 'highlight TabLineSelNR guibg=' . background . ' guifg=' . green
    autocmd ColorScheme * execute 'highlight TabLineSel guibg=' . background . ' guifg=' . foreground
    autocmd ColorScheme * execute 'highlight TabLine gui=NONE cterm=NONE guibg=' . selection . ' guifg=' . foreground
    autocmd ColorScheme * execute 'highlight TabLineFill guibg=' . selection . ' guifg=' . selection
augroup END

function! TabLine()
    if tabpagenr('$') == 1 
        return BufLine()
    else 
        return ''
    endif
endfunction

function! BufLine()
    let s = ''
    for i in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        if i == bufnr('%')
            let s .= '%#TabLineSelNR# '
            let s .= i
            let s .= ' %#TabLineSel#'
        else
            let s .= '%#TabLine# '
            let s .= i
            let s .= ' '
        endif
        let s .= '%{fnamemodify(bufname(' . i . '), ":~:.")}'
        let s .= '%{getbufvar(' . i . ', "&nomodifiable") ? "[-]" : (getbufinfo(' . i . ')[0].changed ? "[+]" : "")}'
        let s .= ' '
    endfor
    let s .= '%#TabLineFill#'
    return s
endfunction

set showtabline=2
set tabline=%!TabLine()

" status line
function! StatusLineMode()
    let l:mode = mode(1)

    " Normal mode
    if l:mode ==# 'n' "Normal, Terminal-Normal
        highlight link StatusLineMode StatusLineNormal
        return 'NORMAL'
    elseif l:mode ==# 'no' "Operator-pending

    " Visual mode
    elseif l:mode ==# 'v' "Visual by character
        highlight link StatusLineMode StatusLineVisual
        return 'VISUAL'
    elseif l:mode ==# 'V' "Visual by line
        highlight link StatusLineMode StatusLineVisual
        return 'VISUAL LINE'
    " elseif l:mode ==# 'CTRL-V' "Visual blockwise
    elseif l:mode ==# "\<C-V>" "Visual blockwise
        highlight link StatusLineMode StatusLineVisual
        return 'VISUAL BLOCK'

    " Select mode
    elseif l:mode ==# 's' "Select by character
    elseif l:mode ==# 'S' "Select by line
    " elseif l:mode ==# 'CTRL-S' "Select blockwise
    elseif l:mode ==# '\<C-S>' "Select blockwise

    " Insert mode
    elseif l:mode ==# 'i' "Insert
        highlight link StatusLineMode StatusLineInsert
        return 'INSERT'
    elseif l:mode ==# 'ic' "Insert mode completion |compl-generic|
        highlight link StatusLineMode StatusLineInsert
        return 'INSERT'
    elseif l:mode ==# 'ix' "Insert mode |i_CTRL-X| completion
        highlight link StatusLineMode StatusLineInsert
        return 'INSERT'
    elseif l:mode ==# 'R' "Replace |R|
        highlight link StatusLineMode StatusLineInsert
        return 'REPLACE'
    elseif l:mode ==# 'Rc' "Replace mode completion |compl-generic|
        highlight link StatusLineMode StatusLineInsert
        return 'REPLACE'
    elseif l:mode ==# 'Rv' "Virtual Replace |gR|
        highlight link StatusLineMode StatusLineInsert
        return 'VREPLACE'
    elseif l:mode ==# 'Rx' "Replace mode |i_CTRL-X| completion
        highlight link StatusLineMode StatusLineInsert
        return 'REPLACE'

    " Cmdline mode
    elseif l:mode ==# 'c' "Command-line editing
        highlight link StatusLineMode StatusLineCommand
        return 'SEARCH'

    " Ex mode
    elseif l:mode ==# 'cv' "Vim Ex mode |gQ|
    elseif l:mode ==# 'ce' "Normal Ex mode |Q|
    elseif l:mode ==# 'r' "Hit-enter prompt
    elseif l:mode ==# 'rm' "The -- more -- prompt
    elseif l:mode ==# 'r?' "A |:confirm| query of some sort
    elseif l:mode ==# '!' "Shell or external command is executing

    " Terminal-Job mode
    elseif l:mode ==# 't' "Terminal-Job mode: keys go to the job
    endif

    highlight link StatusLineMode StatusLineUnknown
    return 'UNKNOWN(' . l:mode . ')'
endfunction

augroup statusline
    autocmd!
    autocmd ColorScheme * execute 'highlight StatusLineNormal guibg=' . green . ' guifg=' . background
    autocmd ColorScheme * execute 'highlight StatusLineInsert guibg=' . yellow . ' guifg=' . background
    autocmd ColorScheme * execute 'highlight StatusLineVisual guibg=' . purple . ' guifg=' . background
    autocmd ColorScheme * execute 'highlight StatusLineCommand guibg=' . cyan . ' guifg=' . background
    autocmd ColorScheme * execute 'highlight StatusLineUnknown guibg=' . red . ' guifg=' . background

    autocmd ColorScheme * execute 'highlight StatusLineRight1 guibg=' . cyan . ' guifg=' . background
    autocmd ColorScheme * execute 'highlight StatusLineRight2 guibg=' . orange . ' guifg=' . background

    autocmd ColorScheme * execute 'highlight StatusLine guibg=' . selection . ' guifg=' . foreground
augroup END

set laststatus=2
set statusline=%#StatusLineMode#\ %{StatusLineMode()}\ %#StatusLine#\ 
set statusline+=%<%f\ %h%m%r
set statusline+=%=
" set statusline+=%#StatusLineRight1#\ %3.P\ 
set statusline+=%#StatusLineRight2#\ %3.p%%\ \|\ %4.l/%L\ :\ %2.c\ 
" set statusline+=%#StatusLineRight2#%-14.(%l,%c%V%)\ %P

" miscellaneous settings
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
set ignorecase
set smartcase
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
set showbreak=>\ 
set list listchars=tab:\|\ ,trail:·,nbsp:~,extends:>,precedes:<
set wildmenu
set belloff=all

" nnoremap <silent> i i<C-N><C-P>
" nnoremap <silent> a a<C-N><C-P>
" nnoremap <silent> R R<C-N><C-P>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-Y>" : "\<C-G>u\<TAB>"
inoremap <expr> <ESC> pumvisible() ? "\<C-E>\<ESC>" : "\<ESC>"
inoremap <expr> <C-N> pumvisible() ? "\<DOWN>" : "\<C-N>\<C-P>\<LT>DOWN>"
inoremap <expr> <C-P> pumvisible() ? "\<UP>" : "\<C-N>\<C-P>\<LT>DOWN>"
set completeopt=menuone
set pumheight=15

augroup popupmenu
    autocmd!
    autocmd ColorScheme,VimEnter * execute 'highlight PmenuSel guibg='. purple .' guifg=#21222c'
augroup END

" echo functions
function! EchoWarning(msg)
    echohl ErrorMsg
    echo a:msg
    echohl None
endfunction

inoremap jj <ESC>
" inoremap <ESC> <ESC>:call EchoWarning("Train yourself to use CTRL-[ (or jj)")<CR>
nnoremap <Leader>r<Space> :source ~/.vimrc<CR>:echo "source ~/.vimrc done"<CR>
nnoremap <Leader>b<Space> :ls <CR>:b<Space>


