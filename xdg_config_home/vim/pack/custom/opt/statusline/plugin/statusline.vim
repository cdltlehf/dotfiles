" status line

function! StatusLineMode() abort
  let l:mode = mode(1)

  " Normal mode
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
    return 'INSERT NORMAL'
  elseif l:mode ==# 'niR'
    "Normal in Replace-mode
  elseif l:mode ==# 'niV'
    "Normal in Virtual-Replace-mode
  elseif l:mode ==# 'nt'
    "Terminal-Normal
    highlight link StatusLineMode StatusLineNormal
    return 'TERMINAL NORMAL'

  " Visual mode
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

  " Select mode
  elseif l:mode ==# 's'
    " Select by character
    highlight link StatusLineMode StatusLineSelect
    return 'SELECT'
  elseif l:mode ==# 'S'
    " Select by line
    highlight link StatusLineMode StatusLineSelect
    return 'SELECT LINE'
  " elseif l:mode ==# 'CTRL-S'
    " Select blockwise
  elseif l:mode ==# '\<C-S>'
    " Select blockwise
    highlight link StatusLineMode StatusLineSelect
    return 'SELECT BLOCK'

  " Insert mode
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

  " Cmdline mode
  elseif l:mode ==# 'c'
    " Command-line editing
    highlight link StatusLineMode StatusLineCommand
    return 'COMMAND'

  " Ex mode
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

  " Terminal-Job mode
  elseif l:mode ==# 't'
    " Terminal-Job mode: keys go to the job
    highlight link StatusLineMode StatusLineCommand
    return 'TERMINAL'
  endif

  highlight link StatusLineMode StatusLineUnknown
  return 'UNKNOWN(' . l:mode . ')'
endfunction

augroup statusline_highlight
  autocmd!
  autocmd ColorScheme,VimEnter *
        \ highlight StatusLineNormal
        \   ctermfg=black ctermbg=darkgreen cterm=none
        \|highlight StatusLineInsert
        \   ctermfg=black ctermbg=darkyellow cterm=none
        \|highlight StatusLineVisual
        \   ctermfg=black ctermbg=darkblue cterm=none
        \|highlight StatusLineSelect
        \   ctermfg=black ctermbg=darkmagenta cterm=none
        \|highlight StatusLineCommand
        \   ctermfg=black ctermbg=darkcyan cterm=none
        \|highlight StatusLineUnknown
        \   ctermfg=black ctermbg=darkred cterm=none
        \|highlight StatusLineInactive
        \   ctermfg=black ctermbg=darkgrey cterm=none
        \|highlight StatusLineRight1
        \   ctermfg=black ctermbg=darkcyan cterm=none
        \|highlight StatusLineRight2
        \   ctermfg=black ctermbg=darkyellow cterm=none
augroup end

let g:statusline_active = '%#StatusLineMode# %{StatusLineMode()} '
if exists('g:loaded_fugitive')
  highlight FugitiveStatusline ctermfg=white ctermbg=black cterm=none
  if $NERD_FONT == 1
    let g:statusline_active .= '%#FugitiveStatusline#'
        \.'%{substitute('
        \.  'FugitiveStatusline(),'
        \.  '"\\[Git(\\(.\\+\\))\\]",'
        \.  '"  \\1 ▏",'
        \.  '""'
        \.')}'
  else
    let g:statusline_active .= '%#FugitiveStatusline#'
        \.'%{substitute('
        \.  'FugitiveStatusline(),'
        \.  '"\\[Git(\\(.\\+\\))\\]",'
        \.  '" \\1 ▏",'
        \.  '""'
        \.')}'
  endif
endif

let g:statusline_active .= '%* %<%f %m%r%h%w '
let g:statusline_active .= '%= %y '
let g:statusline_active .=
      \ '%#StatusLineRight1# %{&fileencoding}[%{&fileformat}] '

if $NERD_FONT == 1
  let g:statusline_active .= '%#StatusLineRight2# %3.p%% ▏ %2.l/%L:%3.c '
else
  let g:statusline_active .= '%#StatusLineRight2# %3.p%% ▏%3.l/%L:%3.c '
endif

let g:statusline_inactive = '%#StatusLineInactive# INACTIVE '
      \.'%* %<%f %m%r%h%w '
      \. '%='
      \.' %y '
      \.'%{&fileencoding}[%{&fileformat}] '

function s:activate_statusline() abort
  let &l:statusline = g:statusline_active
endfunction

function s:deactivate_statusline() abort
  let &l:statusline = g:statusline_inactive
endfunction

augroup statusline_string
  autocmd!
  autocmd WinEnter,BufEnter * call s:activate_statusline()
  autocmd WinLeave,BufLeave * call s:deactivate_statusline()
augroup end

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
