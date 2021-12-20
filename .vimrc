" Dracula Color Palette {{{
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
" }}}

" tpope/vim-sensible {{{
if has('autocmd')
    filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

set autoindent
set backspace=indent,eol,start
set smarttab
set incsearch
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

if &encoding==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif
" }}}

" tpope/vim-unimpaired {{{
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
" add newline
nnoremap [<Space> O<ESC>j<C-E>
nnoremap ]<Space> o<ESC>k
" move line
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
nnoremap [os :setlocal<Space>spell<CR>
nnoremap ]os :setlocal<Space>nospell<CR>
nnoremap [ow :setlocal<Space>wrap<CR>
nnoremap ]ow :setlocal<Space>nowrap<CR>
nnoremap [ob :set<Space>background=dark<CR>
nnoremap ]ob :set<Space>background=light<CR>
" }}}

" Dracula {{{
packadd! dracula
let g:dracula_italic=0
colorscheme dracula
" }}}

" compatible, termguicolors, etc... {{{
if &g:compatible
    set nocompatible
endif
set termguicolors
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" }}}

" tab (buffer) line {{{
" tab line highlight {{{
augroup tabline_highlight
    autocmd!
    autocmd ColorScheme * execute 'highlight TabLineSelNR guibg=' . background . ' guifg=' . green
    autocmd ColorScheme * execute 'highlight TabLineSel guibg=' . background . ' guifg=' . foreground
    autocmd ColorScheme * execute 'highlight TabLine gui=NONE cterm=NONE guibg=' . selection . ' guifg=' . foreground
    autocmd ColorScheme * execute 'highlight TabLineFill guibg=' . selection . ' guifg=' . selection
augroup END
" }}}

" tab line, buffer line {{{
function! TabLine()
    if tabpagenr('$') == 1
        return BufferLine()
    else
        return ''
    endif
endfunction

function! BufferLine()
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
        let filename = '%{'
        if i != bufnr('%')
            let filename .= 'substitute('
        endif
        let filename .= 'fnamemodify(bufname(' . i . '), ":~:.")'
        if i != bufnr('%')
            let filename .= ', "\\([^/]\\)[^/]*/", "\\1/", "g")'
        endif
        let filename .= '}'
        let s .= filename
        let s .= '%{!getbufvar(' . i . ', "&modifiable") ?'
        let s .= ' "[-]" :' 
        let s .= ' (getbufinfo(' . i . ')[0].changed ? "[+]" : "")}'
        let s .= ' '
    endfor
    let s .= '%#TabLineFill#'
    return s
endfunction
" }}}

set showtabline=2
set tabline=%!TabLine()
" }}}

" status line {{{
" status line mode {{{
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
" }}}

" status line highlight {{{
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
" }}}

set laststatus=2
set statusline=%#StatusLineMode#\ %{StatusLineMode()}\ %#StatusLine#\ 
set statusline+=%<%f\ %h%m%r

set statusline+=%=

set statusline+=%Y\ 
set statusline+=%#StatusLineRight1#\ %{&fileencoding}[%{&fileformat}]\ 
set statusline+=%#StatusLineRight2#\ %3.p%%\ :\%5.l/%L:%2.c\ 
" }}}

" comment map {{{
" TODO: unify these
function! SetPythonCommentMap()
    nnoremap <Leader>c<Space> mcI# <ESC>`c
    vnoremap <Leader>c<Space> :s\/^\/#\ 
endfunction

function! SetVimCommentMap()
    nnoremap <Leader>c<Space> mcI" <ESC>`c
    vnoremap <Leader>c<Space> :s/^/"\ <CR>
endfunction

augroup commentmap
    autocmd!
    autocmd FileType javascript 
          \ nnoremap <Leader>c<Space> mcI// <ESC>`c
    autocmd FileType c 
          \ nnoremap <Leader>c<Space> mcI// <ESC>`c
    autocmd FileType cpp 
          \ nnoremap <Leader>c<Space> mcI// <ESC>`c
    autocmd FileType python call SetPythonCommentMap()
    autocmd FileType vim call SetVimCommentMap()
augroup END
" }}}

" miscellaneous settings {{{
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

vnoremap < <gv
vnoremap > >gv
vnoremap * y/<C-R>"<CR>

nnoremap Q @@
nnoremap Y y$

nnoremap n nzz
nnoremap N Nzz

nnoremap <Leader>b<Space> :ls <CR>:b<Space>
" }}}

" set text width 79 {{{
set colorcolumn=80
" set textwidth=79
" }}}

" pop up menu {{{
set completeopt=noinsert,preview,menuone
set pumheight=5

"TODO
augroup completion
    autocmd!
    "autocmd CursorMovedI * execute('if pumvisible() normal! a')
    "
augroup END

augroup popupmenu
    autocmd!
    autocmd ColorScheme,VimEnter * execute 'highlight PmenuSel guibg='. purple .' guifg=#21222c'
augroup END
" }}}

augroup runcmd
    autocmd!
    autocmd FileType vim nnoremap <buffer> <Leader>r<Space> :source $HOME/.vimrc<CR>:echo "source $HOME/.vimrc done"<CR>
    autocmd FileType python nnoremap <buffer> <Leader>r<Space> :!python %<CR>
    autocmd FileType tex nnoremap <buffer> <Leader>r<Space> :!pdflatex %<CR>
augroup END

augroup tex
    autocmd!
    autocmd FileType tex inoremap <buffer> <Leader>tbf<Space> \textbf{}<ESC>i
augroup END

" make .vim folder (0700) {{{
if empty(glob($HOME . "/.vim"))
    call mkdir($HOME . "/.vim", 0700)
endif
" }}}

" set spellcheck {{{
if empty(glob($HOME . "/.vim/spell"))
    call mkdir($HOME . "/.vim/spell", 0700)
endif
set spell
set spellfile=$HOME/.vim/spell/spell.utf-8.add
" }}}

" set swap {{{
if empty(glob($HOME . "/.vim/swap"))
    call mkdir($HOME . "/.vim/swap", 0700)
endif
set directory=$HOME/.vim/swap
" }}}

" set undo {{{
if empty(glob($HOME . "/.vim/undodir"))
    call mkdir($HOME . "/.vim/undodir", 0700)
endif
set undodir=$HOME/.vim/undodir
set undofile
" }}}

" set fold (zR to open all folds) {{{
set foldcolumn=2
execute 'highlight FoldColumn guibg=' . background . ' guifg=' . comment
augroup fold
    autocmd!
    autocmd BufRead * normal zR
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python setlocal foldmethod=indent
augroup END
" }}} (zM to close all folds)

