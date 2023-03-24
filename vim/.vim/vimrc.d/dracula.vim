augroup dracula_customization
  autocmd!
  autocmd ColorScheme dracula
        \ highlight Normal guibg=NONE ctermbg=NONE
        \|highlight DraculaComment cterm=italic
        \|highlight link VertSplit DraculaCommentBold
        \|highlight VertSplit guibg=NONE ctermbg=NONE gui=None cterm=None
        \|highlight link FoldColumn DraculaCommentBold
        \|highlight link PmenuSel WildMenu
augroup END
colorscheme dracula
