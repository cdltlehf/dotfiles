" https://github.com/airblade/vim-gitgutter

augroup gitgutter_listener
  autocmd!
  autocmd User GitGutter let &l:statusline=&l:statusline
augroup END

set updatetime=100
if has('popupwin')
  let g:gitgutter_preview_win_floating=1
endif

nmap ghp <Plug>(GitGutterPreviewHunk)
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
