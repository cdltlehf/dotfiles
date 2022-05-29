" ~/.vim/ftplugin/sh.vim

set makeprg=shellcheck\ --format=gcc\ --external-sources\ %
" augroup shellLinting
" autocmd BufWritePost <buffer>
      " \ silent execute "!shellcheck" | execute ':redraw!'
" augroup END
