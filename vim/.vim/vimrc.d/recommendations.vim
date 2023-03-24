"" https://www.vi-improved.org/recommendations/

function! s:StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command StripTrailingWhitespace call s:StripTrailingWhitespace()

nnoremap <leader>a
      \ :<c-u>argadd <c-r>=filenameescape(expand('%:p:h'))<cr>/*<c-d>
nnoremap <leader>b :<c-u>ls<cr>:b <c-d>
nnoremap <leader>e :<c-u>e **/
nnoremap <leader>g :<c-u>grep<space>
" nnoremap <leader>i :Ilist<space>
nnoremap <leader>j :<c-u>tjump /
nnoremap <leader>m :<c-u>make<cr>
nnoremap <leader>s :<c-u>StripTrailingWhitespace<cr>
nnoremap <leader>q :b#<cr>
