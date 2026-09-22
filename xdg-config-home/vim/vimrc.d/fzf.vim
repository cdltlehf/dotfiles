" Reference: https://github.com/junegunn/fzf.vim
" :help fzf.txt

let g:fzf_layout = { 'down': '8' }
autocmd! FileType fzf
autocmd FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <leader><tab> <plug>(fzf-maps-n)
xnoremap <leader><tab> <plug>(fzf-maps-x)
onoremap <leader><tab> <plug>(fzf-maps-o)

inoremap <c-f> <plug>(fzf-complete-path)

nnoremap <c-p> :Files<cr>
nnoremap <leader>b :Buffers<cr>
