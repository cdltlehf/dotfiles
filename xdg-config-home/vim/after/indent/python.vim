" Reference: https://github.com/google/styleguide/blob/gh-pages/google_python_style.vim
runtime google_python_style.vim

" Hang by 4 and close at the opening line, as pyguide 3.4 and ruff format do.
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_nested_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth()'
let g:python_indent = extend(get(g:, 'python_indent', {}),
      \ #{closed_paren_align_last_line: v:false})
