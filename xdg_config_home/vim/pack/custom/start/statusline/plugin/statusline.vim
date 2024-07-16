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
    return 'NORMAL(I)'
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
  elseif l:mode ==# 'S'
    " Select by line
  " elseif l:mode ==# 'CTRL-S'
    " Select blockwise
  elseif l:mode ==# '\<C-S>'
    " Select blockwise

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

function! s:activate_statusline() abort
  let &l:statusline = '%#StatusLineMode# %{StatusLineMode()} '
  if exists('g:loaded_fugitive')
    let &l:statusline .= ''
          \.'%#FugitiveStatusline#'
          \.'%{substitute('
          \.  'substitute(FugitiveStatusline(),"\\[Git(",'
          \.    '" \uea68 ", ""),'
          \.  '")]",'
          \.  '" \u2502", ""'
          \.')}'
  endif
  let &l:statusline .= '%* %<%f %m%r%h%w '
  let &l:statusline .= '%='
  let &l:statusline .= ''
        \.' %y '
        \.'%#StatusLineRight1# %{&fileencoding}[%{&fileformat}] '
        \.'%#StatusLineRight2# %3.p%% :%5.l/%L:%2.c '
endfunction

function! s:deactivate_statusline() abort
  let &l:statusline = ''
        \.'%#StatusLineInactive# INACTIVE '
        \.'%* %<%f %m%r%h%w '
  let &l:statusline .= '%='
  let &l:statusline .= ''
        \.' %y '
        \.'%* %{&fileencoding}[%{&fileformat}] '
endfunction

augroup statusline_string
  autocmd!
  autocmd WinEnter,BufEnter * call s:activate_statusline()
  autocmd WinLeave,BufLeave * call s:deactivate_statusline()
augroup end

if exists('g:loaded_fugitive')
  augroup fugitive_statusline_highlight
    autocmd!
    autocmd ColorScheme,VimEnter *
          \ highlight FugitiveStatusline
          \   ctermfg=white ctermbg=black cterm=none
  augroup end
endif

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
