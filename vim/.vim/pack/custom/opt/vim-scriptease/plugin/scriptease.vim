" https://github.com/tpope/vim-scriptease

function! s:EchoSynNames()
  let [l:line, l:col] = [line('.'), col('.')]
  echo reverse(map(synstack(line, col), 'synIDattr(v:val,"name")'))
endfunction
command! EchoSynNames call s:EchoSynNames()

nnoremap zS :EchoSynNames<cr>
