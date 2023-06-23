" ~/.vim/ftplugin/tmux.vim

if exists('*GetShIndent')
  setlocal indentexpr=GetShIndent()
endif

let &l:comments=":#"
let &l:commentstring="# %s"
