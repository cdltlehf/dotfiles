" ~/.vim/after/syntax/markdown.vim

hi! link markdownCodeBlock         DraculaGreen

" Overwrite a Tim Pope's markdownCodeBlock syntax
syntax clear markdownCodeBlock
syntax region markdownCodeBlock
      \ start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{8,}\|\t\+\)\).*\n/
      \ end=/.\(\n^\s*\n\)\@=/
      \ contained

syn match markdownListMarkerWithoutContents
      \ "\%(\t\| \{0,4\}\)*[-*+]\%(\s\+$\)\@=" contained
syn match markdownOrderedListMarkerWithoutContents
      \ "\%(\t\| \{0,4}\)*\<\d\+\.\%(\s\+$\)\@=" contained
hi def link markdownListMarkerWithoutContents Comment
hi def link markdownOrderedListMarkerWithoutContents Comment

" Overwrite a Tim Pope's markdown(Ordered)ListMarker syntax
if hlexists("markdownListMarker")
  syntax clear markdownListMarker
endif
if hlexists("markdownOrderedListMarker")
  syntax clear markdownOrderedListMarker
endif
syn match markdownListMarker
      \ "\%(\t\| \{0,4\}\)*[-*+]\%(\s\+\S\)\@=" contained
syn match markdownOrderedListMarker
      \ "\%(\t\| \{0,4}\)*\<\d\+\.\%(\s\+\S\)\@=" contained

syn cluster markdownBlock add=markdownListMarkerWithoutContents
syn cluster markdownBlock add=markdownOrderedListMarkerWithoutContents
