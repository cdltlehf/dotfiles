" status line
" Dracula Color Palette {{{1
" https://spec.draculatheme.com/
let s:background='#282a36'
let s:foreground='#f8f8f2'
let s:selection='#44475a'
let s:comment='#6272a4'

let s:red='#ff5555'
let s:orange='#ffb86c'
let s:yellow='#f1fa8c'
let s:green='#50fa7b'
let s:purple='#bd93f9'
let s:cyan='#8be9fd'
let s:pink='#ff79c6'

"}}}

function! StatusLineMode() abort "{{{1
  let l:mode = mode(1)

  " Normal mode {{{2
  if l:mode ==# 'n'
    " Normal, Terminal-Normal
    highlight link StatusLineMode StatusLineNormal
    return 'NORMAL'
  elseif l:mode ==# 'no'
  elseif l:mode ==# 'nov'
  elseif l:mode ==# 'noV'
    " Operator-pending
  elseif l:mode ==# 'niI'
    "Normal in Insert-mode
    highlight link StatusLineMode StatusLineNormal
    return 'NORMAL(I)'
  elseif l:mode ==# 'niR'
    "Normal in Replace-mode
  elseif l:mode ==# 'niV'
    "Normal in Virtual-Replace-mode
  elseif l:mode ==# 'nt'
    "Terminal-Normal

  " Visual mode {{{2
  elseif l:mode ==# 'v'
    " Visual by character
    highlight link StatusLineMode StatusLineVisual
    return 'VISUAL'
  elseif l:mode ==# 'V'
    " Visual by line
    highlight link StatusLineMode StatusLineVisual
    return 'VISUAL LINE'
  elseif l:mode ==# "\<C-V>"
    " Visual blockwise
    highlight link StatusLineMode StatusLineVisual
    return 'VISUAL BLOCK'

  " Select mode {{{2
  elseif l:mode ==# 's'
    " Select by character
  elseif l:mode ==# 'S'
    " Select by line
  " elseif l:mode ==# 'CTRL-S'
    " Select blockwise
  elseif l:mode ==# '\<C-S>'
    " Select blockwise

  " Insert mode {{{2
  elseif l:mode ==# 'i'
    " Insert
    highlight link StatusLineMode StatusLineInsert
    return 'INSERT'
  elseif l:mode ==# 'ic'
    " Insert mode completion |compl-generic|
    highlight link StatusLineMode StatusLineInsert
    return 'INSERT'
  elseif l:mode ==# 'ix'
    " Insert mode |i_CTRL-X| completion
    highlight link StatusLineMode StatusLineInsert
    return 'INSERT'
  elseif l:mode ==# 'R'
    " Replace |R|
    highlight link StatusLineMode StatusLineInsert
    return 'REPLACE'
  elseif l:mode ==# 'Rc'
    " Replace mode completion |compl-generic|
    highlight link StatusLineMode StatusLineInsert
    return 'REPLACE'
  elseif l:mode ==# 'Rv'
    " Virtual Replace |gR|
    highlight link StatusLineMode StatusLineInsert
    return 'VREPLACE'
  elseif l:mode ==# 'Rx'
    " Replace mode |i_CTRL-X| completion
    highlight link StatusLineMode StatusLineInsert
    return 'REPLACE'

  " Cmdline mode {{{2
  elseif l:mode ==# 'c'
    " Command-line editing
    highlight link StatusLineMode StatusLineCommand
    return 'SEARCH'

  " Ex mode {{{2
  elseif l:mode ==# 'cv'
    " Vim Ex mode |gQ|
  elseif l:mode ==# 'ce'
    " Normal Ex mode |Q|
  elseif l:mode ==# 'r'
    " Hit-enter prompt
  elseif l:mode ==# 'rm'
    " The -- more -- prompt
  elseif l:mode ==# 'r?'
    " A |:confirm| query of some sort
  elseif l:mode ==# '!'
    " Shell or external command is executing

  " Terminal-Job mode {{{2
  elseif l:mode ==# 't'
    " Terminal-Job mode: keys go to the job
    highlight link StatusLineMode StatusLineCommand
    return 'TERMINAL'
  endif

  " }}}

  highlight link StatusLineMode StatusLineUnknown
  return 'UNKNOWN(' . l:mode . ')'
endfunction "}}}

augroup statusline_highlight "{{{
  autocmd!
  " TODO: Set cterm color too...
  " Left statusline {{{
  autocmd ColorScheme,VimEnter *
        \ highlight clear StatusLineNormal
        \|highlight clear StatusLineInsert
        \|highlight clear StatusLineVisual
        \|highlight clear StatusLineCommand
        \|highlight clear StatusLineUnknown
        \|highlight clear StatusLineInactive
        \|execute 'highlight StatusLineNormal'
        \ . ' guibg=' . s:green . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight StatusLineInsert'
        \ . ' guibg=' . s:yellow . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight StatusLineVisual'
        \ . ' guibg=' . s:purple . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight StatusLineCommand'
        \ . ' guibg=' . s:cyan . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight StatusLineUnknown'
        \ . ' guibg=' . s:red . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight StatusLineInactive'
        \ . ' guibg=' . s:comment . ' guifg=' . s:background
        \ . ' cterm=bold gui=bold'

  "}}}

  " Fugitive statusline {{{
  if exists('g:loaded_fugitive')
    autocmd ColorScheme,VimEnter *
          \ highlight clear FugitiveStatusline
          \|execute 'highlight FugitiveStatusline'
          \ . ' guibg=' . s:comment . ' guifg=' . s:background
          \ . ' cterm=None gui=None'
  endif

  " }}}
  " Right statusline {{{
  autocmd ColorScheme,VimEnter *
        \ highlight clear StatusLineRight1
        \|highlight clear StatusLineRight2
        \|highlight clear StatusLine
        \|execute 'highlight StatusLineRight1'
        \ . ' guibg=' . s:cyan . ' guifg=' . s:background
        \ . ' cterm=None gui=None'
        \|execute 'highlight StatusLineRight2'
        \ . ' guibg=' . s:orange . ' guifg=' . s:background
        \ . ' cterm=None gui=None'
        \|execute 'highlight StatusLine'
        \ . ' guibg=' . s:selection . ' guifg=' . s:foreground
        \ . ' cterm=None gui=None'

  "}}}
augroup end " }}}

function! s:activate_statusline() abort
  let &l:statusline = '%#StatusLineMode# %{StatusLineMode()} '
  if exists('g:loaded_fugitive')
    let &l:statusline .= ''
          \.'%#FugitiveStatusline#'
          \.'%{substitute(FugitiveStatusline(), "^\\[\\|\\]$", " ", "g")}'
  endif
  let &l:statusline .= '%#StatusLine# %<%f %m%r%h%w '
  let &l:statusline .= '%='
  let &l:statusline .= ''
        \.' %y '
        \.'%#StatusLineRight1# %{&fileencoding}[%{&fileformat}] '
        \.'%#StatusLineRight2# %3.p%% :%5.l/%L:%2.c '
endfunction

function! s:deactivate_statusline() abort
  let &l:statusline = ''
        \.'%#StatusLineInactive# INACTIVE '
        \.'%#StatusLine# %<%f %m%r%h%w '
  let &l:statusline .= '%='
  let &l:statusline .= ''
        \.' %y '
        \.'%#StatusLineInactive# %{&fileencoding}[%{&fileformat}] '
endfunction

augroup statusline_string
  autocmd!
  autocmd WinEnter,BufEnter * call s:activate_statusline()
  autocmd WinLeave,BufLeave * call s:deactivate_statusline()
augroup end

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
