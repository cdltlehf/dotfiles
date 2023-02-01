"" See christoomey/vim-tmux-navigator

if exists('g:loaded_tmux_navigator') || &compatible
  finish
endif
let g:loaded_tmux_navigator = 1

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')

function! s:TmuxAwareNavigate(direction)
  echon ''
  let nr = winnr()
  execute 'wincmd ' . a:direction
  if nr ==# winnr()
    let l:tmux_socket = split($TMUX, ',')[0]
    let l:cmd = 'tmux -S ' . l:tmux_socket . ' '
    let l:cmd .= 'select-pane -' . tr(a:direction, 'hjkl', 'LDUR')
    return system(l:cmd)
  endif
endfunction

function! s:TmuxSocket()
  return split($TMUX, ',')[0]
endfunction
