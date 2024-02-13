" https://github.com/junegunn/fzf.vim

nnoremap <c-p> :Files<cr>
nnoremap <leader>b :Buffers<cr>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-n)
omap <leader><tab> <plug>(fzf-maps-n)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
