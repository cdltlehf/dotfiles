set background=dark

highlight clear
let g:colors_name = 'dracula16'

let &t_Co=16

" :help group-name
highlight Comment ctermfg=darkgrey ctermbg=none cterm=none

highlight Constant ctermfg=darkblue ctermbg=none cterm=none
highlight String ctermfg=darkyellow ctermbg=none cterm=none
highlight Character ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Number Constant
highlight! link Boolean Constant
highlight! link Float Constant

highlight Identifier ctermfg=none ctermbg=none cterm=none
highlight Function ctermfg=darkgreen ctermbg=none cterm=none

highlight Statement ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Conditional Statement
highlight! link Repeat Statement
highlight! link Label Statement
highlight! link Operator Statement
highlight! link Keyword Statement
highlight! link Exception Statement

highlight PreProc ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Include PreProc
highlight! link Define PreProc
highlight! link Macro PreProc
highlight! link PreCondit PreProc

highlight Type ctermfg=darkcyan ctermbg=none cterm=italic
highlight StorageClass ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Structure StroageClass
highlight! link Typedef StorageClass

highlight Special ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link SpecialChar Special
highlight Tag ctermfg=darkcyan ctermbg=none cterm=none
highlight Delimiter ctermfg=darkyellow ctermbg=none cterm=none
highlight SpecialComment ctermfg=darkcyan ctermbg=none cterm=italic
highlight! link Debug Special

highlight Underlined ctermfg=none ctermbg=none cterm=underline
highlight Ignore cterm=none ctermbg=none cterm=none

highlight Error ctermfg=darkred ctermbg=none cterm=none
highlight Todo ctermfg=darkyellow ctermbg=none cterm=none

" :help highlight-groups
highlight ColorColumn ctermfg=white ctermbg=darkgrey cterm=none

highlight Conceal ctermfg=darkcyan ctermbg=none cterm=none

highlight Cursor ctermfg=none ctermbg=none cterm=none
highlight! link lCursor Cursor
highlight! link CursorIM Cursor
highlight! link CursorColumn ColorColumn
highlight! link CursorLine CursorColumn

highlight Directory ctermfg=darkblue ctermbg=none cterm=none

highlight DiffAdd ctermfg=darkgreen ctermbg=none cterm=none
highlight DiffChange ctermfg=darkyellow ctermbg=none cterm=none
highlight DiffDelete ctermfg=darkmagenta ctermbg=none cterm=underline
highlight DiffText ctermfg=darkyellow ctermbg=none cterm=underline

highlight! link EndOfBuffer NonText

highlight! link ErrorMsg Error

highlight VertSplit ctermfg=darkgrey ctermbg=none cterm=none
highlight Folded ctermfg=darkgrey ctermbg=black cterm=none
highlight FoldColumn ctermfg=darkgrey ctermbg=none cterm=none
highlight! link IncSearch CurSearch

highlight! link SignColumn Comment

highlight LineNr ctermfg=darkgrey ctermbg=none cterm=none
highlight! link LineNrAbove LineNr
highlight! link LineNrBelow LineNr

highlight CursorLineNr ctermfg=darkyellow ctermbg=black cterm=none
highlight! link CursorLineFold CursorLine
highlight! link CursorLineSign CursorLine

highlight MatchParen ctermfg=darkgreen ctermbg=none cterm=underline

highlight! link MessageWindow WarningMsg
highlight! link ModeMsg Normal
highlight MoreMsg ctermfg=none ctermbg=none cterm=bold
highlight NonText ctermfg=darkgrey ctermbg=none cterm=none

highlight Normal ctermfg=none ctermbg=none cterm=none

highlight Pmenu ctermfg=none ctermbg=black cterm=none
highlight PmenuSel ctermfg=darkblue ctermbg=none cterm=bold,inverse
highlight! link PmenuKind Pmenu
highlight! link PmenuKindSel PmenuSel
highlight! link PmenuExtra Pmenu
highlight! link PmenuExtraSel Pmenusel
highlight! link PmenuSbar Pmenu
highlight PmenuThumb ctermfg=none ctermbg=white cterm=none

highlight! link PopupNotification WarningMsg

highlight Question ctermfg=none ctermbg=none cterm=bold
highlight! link QuickFixLine PmenuSel

highlight Search ctermfg=darkgreen ctermbg=none cterm=inverse
highlight CurSearch ctermfg=darkyellow ctermbg=none cterm=inverse

highlight SpecialKey ctermfg=darkmagenta ctermbg=none cterm=none
highlight SpellBad ctermfg=darkred ctermbg=none cterm=underline
highlight SpellCap ctermfg=darkyellow ctermbg=none cterm=underline
highlight! link SpellLocal SpellCap
highlight! link SpellRare SpellCap

highlight StatusLine ctermfg=none ctermbg=black cterm=none
highlight StatusLineNC ctermfg=darkgrey ctermbg=black cterm=none
highlight! link StatusLineTerm StatusLine
highlight! link StatusLineTermNC StatusLineNC

highlight TabLine ctermfg=none ctermbg=black cterm=none
highlight! link TabLineFill TabLine
highlight TabLineSel ctermfg=darkblue ctermbg=black cterm=inverse
" highlight Terminal

highlight Title ctermfg=darkgreen ctermbg=none cterm=bold
highlight Visual ctermfg=white ctermbg=none cterm=inverse
highlight! link VisualNOS Visual

highlight WarningMsg ctermfg=darkyellow ctermbg=none cterm=inverse
highlight WildMenu ctermfg=darkblue ctermbg=none cterm=bold,inverse

" highlight Menu
" highlight Scrollbar
" highlight Tooltip

" vim-gitgutter
highlight GitGuttterAdd ctermfg=darkgreen ctermbg=none cterm=none
highlight GitGuttterChange ctermfg=darkyellow ctermbg=none cterm=none
highlight GitGuttterDelete ctermfg=darkred ctermbg=none cterm=none

" vim-polyglot
highlight helpHyperTextJump ctermfg=darkcyan ctermbg=none cterm=none
highlight! link helpExample String
highlight! link helpVim Error
highlight! link helpCommand Error
