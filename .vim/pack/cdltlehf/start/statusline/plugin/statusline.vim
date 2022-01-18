" status line
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

augroup statusline "{{{1
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

" set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set statusline=%#StatusLineMode#\ %{StatusLineMode()}\ %#StatusLine#\ 
set statusline+=%<%f\ %m%r%h%w

set statusline+=%=

set statusline+=%y\ 
set statusline+=%#StatusLineRight1#\ %{&fileencoding}[%{&fileformat}]\ 
set statusline+=%#StatusLineRight2#\ %3.p%%\ :\%5.l/%L:%2.c\ 

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
