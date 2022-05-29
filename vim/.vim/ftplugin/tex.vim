" TODO: Set snippet from file
" TODO: Add some input mode maps

" snippets {{{1
" https://github.com/honza/vim-snippets/blob/master/snippets/tex.snippets

" PREAMBLE
iabbrev <buffer> _nc \newcommand{<C-o>m1}[<C-o>m2]]{<C-o>m3} \<ESC>`1a

" DOCUMENT
" autocmd FileType tex iabbrev <buffer> _begin
" \ \begin{<CR><C-o>m1}{c}<CR><C-o>m0<CR>\end{tabular}<ESC>
" \<ESC>`1a

iabbrev <buffer> _mkt \maketitle

iabbrev <buffer> _tab
      \ \begin{tabular}{c}<CR><C-o>m1<CR>\end{tabular}<ESC>
      \<ESC>`1a

iabbrev <buffer> _center
      \ \begin{center}{c}<CR><C-o>m1\end{center}<ESC>
      \<ESC>`1a

iabbrev <buffer> _item
      \ \begin{itemize}<CR>\item<C-o>m1<CR>\end{itemize}<ESC>
      \<ESC>`1a

iabbrev <buffer> _enum
      \ \begin{enumerate}<CR>\item<C-o>m1<CR>\end{enumerate}<ESC>
      \<ESC>`1a

" comment
autocmd FileType tex nnoremap <silent> <buffer> <Leader>c<Space>
      \ :if match(getline('.'), '^\s*% \?') ==# -1 <CR>:s/^\s*/\0% /<CR>
      \ :else<CR>:s/^\(\s*\)% \?/\1/<CR>
      \ :end<CR>

autocmd FileType tex vnoremap <silent> <buffer> <Leader>c<Space>
      \ :s/^\s*/\0% /<CR>

autocmd FileType tex nnoremap <buffer> <Leader>r<Space>
      \ :!pdflatex -interaction=nonstopmode %<CR>
