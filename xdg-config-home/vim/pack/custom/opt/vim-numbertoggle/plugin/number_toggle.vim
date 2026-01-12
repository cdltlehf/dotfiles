augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
        \ if &nu && mode() != "i" | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave *
        \ if &nu | set norelativenumber | endif
augroup END
