" https://github.com/k-takata/minpac

let s:data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(s:data_dir . '/pack/minpac/opt/minpac'))
  function! s:InstallMinpack() abort
    call system('git clone https://github.com/k-takata/minpac.git '
          \ . s:data_dir . '/pack/minpac/opt/minpac')
    if v:shell_error == 0
      source $MYVIMRC
      echo "Minpack is installed."
            \ . "Run `:PackUpdate` to install and update packs"
    else
      echo "Failed to install minpac. Check your git settings."
    endif
  endfunction

  command! InstallMinpack call s:InstallMinpack()
  augroup install_minpack
    autocmd!
    autocmd VimEnter *
          \ if input('Install minpac [y/N]? ') =~? '^y'
            \|echo ""
            \|call s:InstallMinpack()
            \|if v:shell_error == 0
              \|source $MYVIMRC
            \|else
              \|echo "Failed to install minpac. Check your git settings."
            \|endif
          \|else
            \|echo ""
          \|endif
  augroup END
endif
