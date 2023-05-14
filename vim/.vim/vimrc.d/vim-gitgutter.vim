" https://github.com/airblade/vim-gitgutter

augroup gitgutter_listener
  autocmd!
  autocmd User GitGutter let &l:statusline=&l:statusline
augroup END
