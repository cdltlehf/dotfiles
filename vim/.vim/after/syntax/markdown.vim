" ~/.vim/after/syntax/markdown.vim

hi! link markdownCodeBlock         DraculaGreen

" TODO: Overwrite a Tim Pope's markdownCodeBlock syntax
syntax clear markdownCodeBlock
syntax region markdownCodeBlock
      \ start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{8,}\|\t\+\)\).*\n/
      \ end=/.\(\n^\s*\n\)\@=/
      \ contained
