" ~/.vim/after/ftplugin/text.vim
" TODO: Set snippet from file
" TODO: Add some input mode maps

let b:tex_flavor = 'pdflatex'
compiler tex

" snippets {{{1
setlocal iskeyword+=;
" https://github.com/honza/vim-snippets/blob/master/snippets/tex.snippets

" PREAMBLE
iabbrev <buffer> ;nc \newcommand{<C-o>m1}[<C-o>m2]]{<C-o>m3} \<ESC>`1a

" DOCUMENT
" autocmd FileType tex iabbrev <buffer> _begin
" \ \begin{<CR><C-o>m1}{c}<CR><C-o>m0<CR>\end{tabular}<ESC>
" \<ESC>`1a

iabbrev <buffer> ;mkt \maketitle

iabbrev <buffer> ;tab
      \ \begin{tabular}{c}<CR><C-o>m1<CR>\end{tabular}<ESC>
      \<ESC>`1a

iabbrev <buffer> ;center
      \ \begin{center}{c}<CR><C-o>m1\end{center}<ESC>
      \<ESC>`1a

iabbrev <buffer> ;item
      \ \begin{itemize}<CR>\item<C-o>m1<CR>\end{itemize}<ESC>
      \<ESC>`1a

iabbrev <buffer> ;enum
      \ \begin{enumerate}<CR>\item<C-o>m1<CR>\end{enumerate}<ESC>
      \<ESC>`1a

" comment {{{1
autocmd FileType tex nnoremap <silent> <buffer> <Leader>c<Space>
      \ :if match(getline('.'), '^\s*% \?') ==# -1 <CR>:s/^\s*/\0% /<CR>
      \ :else<CR>:s/^\(\s*\)% \?/\1/<CR>
      \ :end<CR>

autocmd FileType tex vnoremap <silent> <buffer> <Leader>c<Space>
      \ :s/^\s*/\0% /<CR>

"}}}
