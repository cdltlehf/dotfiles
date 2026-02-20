" https://github.com/airblade/vim-gitgutter
" :help gitgutter.txt

augroup gitgutter_listener
  autocmd!
  autocmd User GitGutter let &l:statusline=&l:statusline
augroup END

set updatetime=100
if has('popupwin')
  let g:gitgutter_preview_win_floating=1
endif

nnoremap ghp <Plug>(GitGutterPreviewHunk)
nnoremap ghs <Plug>(GitGutterStageHunk)
nnoremap ghu <Plug>(GitGutterUndoHunk)
