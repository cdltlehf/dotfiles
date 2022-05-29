" status line
" Dracula Color Palette {{{1
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
function! StatusLineMode() abort "{{{1
  let l:mode = mode(1)

  " Normal mode {{{2
  if l:mode ==# 'n' "Normal, Terminal-Normal
    highlight link StatusLineMode StatusLineNormal
    return 'NORMAL'
  elseif l:mode ==# 'no' "Operator-pending

  " Visual mode {{{2
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

  " Select mode {{{2
  elseif l:mode ==# 's' "Select by character
  elseif l:mode ==# 'S' "Select by line
  " elseif l:mode ==# 'CTRL-S' "Select blockwise
  elseif l:mode ==# '\<C-S>' "Select blockwise

  " Insert mode {{{2
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

  " Cmdline mode {{{2
  elseif l:mode ==# 'c' "Command-line editing
    highlight link StatusLineMode StatusLineCommand
    return 'SEARCH'

  " Ex mode {{{2
  elseif l:mode ==# 'cv' "Vim Ex mode |gQ|
  elseif l:mode ==# 'ce' "Normal Ex mode |Q|
  elseif l:mode ==# 'r' "Hit-enter prompt
  elseif l:mode ==# 'rm' "The -- more -- prompt
  elseif l:mode ==# 'r?' "A |:confirm| query of some sort
  elseif l:mode ==# '!' "Shell or external command is executing

  " Terminal-Job mode {{{3
  elseif l:mode ==# 't' "Terminal-Job mode: keys go to the job
  endif
  " }}}

  highlight link StatusLineMode StatusLineUnknown
  return 'UNKNOWN(' . l:mode . ')'
endfunction

highlight clear StatusLineNormal
highlight clear StatusLineInsert
highlight clear StatusLineVisual
highlight clear StatusLineCommand
highlight clear StatusLineUnknown
highlight clear StatusLineRight1
highlight clear StatusLineRight2
highlight clear StatusLine
augroup statusline "{{{1
  autocmd!
  autocmd ColorScheme,VimEnter *
        \ execute 'highlight StatusLineNormal '
        \ . 'guibg=' . green . ' guifg=' . background |
        \ execute 'highlight StatusLineInsert '
        \ . 'guibg=' . yellow . ' guifg=' . background |
        \ execute 'highlight StatusLineVisual '
        \ . 'guibg=' . purple . ' guifg=' . background |
        \ execute 'highlight StatusLineCommand '
        \ . 'guibg=' . cyan . ' guifg=' . background |
        \ execute 'highlight StatusLineUnknown '
        \ . 'guibg=' . red . ' guifg=' . background |
        \ execute 'highlight StatusLineRight1 '
        \ . 'guibg=' . cyan . ' guifg=' . background |
        \ execute 'highlight StatusLineRight2 '
        \ . 'guibg=' . orange . ' guifg=' . background |
        \ execute 'highlight StatusLine '
        \ . 'guibg=' . selection . ' guifg=' . foreground
augroup END
" }}}

" set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set statusline=%#StatusLineMode#\ %{StatusLineMode()}\ %#StatusLine#\ 
set statusline+=%<%f\ %m%r%h%w

set statusline+=%=

set statusline+=%y\ 
set statusline+=%#StatusLineRight1#\ %{&fileencoding}[%{&fileformat}]\ 
set statusline+=%#StatusLineRight2#\ %3.p%%\ :\%5.l/%L:%2.c\ 

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
