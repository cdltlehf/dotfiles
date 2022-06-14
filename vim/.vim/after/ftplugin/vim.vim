" ~/.vim/after/ftplugin/vim.vim

setlocal foldmethod=marker
setlocal foldlevel=99

autocmd FileType vim
      \ nnoremap <silent> <buffer> 
      \ <Leader>c<Space>
      \ :if match(getline('.'), '^\s*" \?') ==# -1 <CR>:s/^\s*/\0" /<CR> 
      \ :else<CR>:s/^\(\s*\)" \?/\1/<CR> 
      \ :end<CR>

autocmd FileType vim
      \ vnoremap <silent> <buffer>
      \ <Leader>c<Space>
      \ :s/^\s*/\0" /<CR>

autocmd FileType vim nnoremap <buffer> <Leader>r<Space>
      \ :source %<CR>:echo "sourcing done"<CR>
