" https://github.com/tpope/vim-obsession
" :help obsession.txt

let g:session_dir = expand('$XDG_STATE_HOME/vim/session')
call mkdir(g:session_dir, 'p')
exec 'nnoremap <leader>ss :Obsession ' . g:session_dir . '/'
exec 'nnoremap <leader>sl :source ' . g:session_dir . '/'
nnoremap <leader>sD :Obsession!<cr>
