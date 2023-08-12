set background=dark

hi clear
let g:colors_name = 'dracula16'

let &t_Co=16

" :help group-name
hi! Comment ctermfg=darkgrey ctermbg=none cterm=none

hi! Constant ctermfg=darkblue ctermbg=none cterm=none
hi! String ctermfg=darkyellow ctermbg=none cterm=none
hi! Character ctermfg=darkmagenta ctermbg=none cterm=none
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! Identifier ctermfg=none ctermbg=none cterm=none
hi! Function ctermfg=darkgreen ctermbg=none cterm=none

hi! Statement ctermfg=darkmagenta ctermbg=none cterm=none
hi! link Conditional Statement
hi! link Repeat Statement
hi! link Label Statement
hi! link Operator Statement
hi! link Keyword Statement
hi! link Exception Statement

hi! PreProc ctermfg=darkmagenta ctermbg=none cterm=none
hi! link Include PreProc
hi! link Define PreProc
hi! link Macro PreProc
hi! link PreCondit PreProc

hi! Type ctermfg=darkcyan ctermbg=none cterm=italic
hi! StorageClass ctermfg=darkmagenta ctermbg=none cterm=none
hi! link Structure StroageClass
hi! link Typedef StorageClass

hi! Special ctermfg=darkmagenta ctermbg=none cterm=none
hi! link SpecialChar Special
hi! Tag ctermfg=darkcyan ctermbg=none cterm=none
hi! Delimiter ctermfg=none ctermbg=none cterm=none
hi! SpecialComment ctermfg=darkcyan ctermbg=none cterm=italic
hi! link Debug Special

hi! Underlined ctermfg=none ctermbg=none cterm=underline

hi! Ignore cterm=none ctermbg=none cterm=none

hi! Error ctermfg=darkred ctermbg=none cterm=none

hi! Todo ctermfg=darkyellow ctermbg=none cterm=bold


" :help highlight-groups
hi! ColorColumn ctermfg=none ctermbg=black cterm=none

hi! Conceal ctermfg=darkcyan ctermbg=none cterm=none

hi! Cursor ctermfg=none ctermbg=none cterm=none
hi! link lCursor Cursor
hi! link CursorIM Cursor
hi! link CursorColumn ColorColumn
hi! link CursorLine CursorColumn

hi! Directory ctermfg=darkblue ctermbg=none cterm=bold

hi! DiffAdd ctermfg=darkgreen ctermbg=none cterm=none
hi! DiffChange ctermfg=darkyellow ctermbg=black cterm=none
hi! DiffDelete ctermfg=darkred ctermbg=darkmagenta cterm=none
hi! DiffText ctermfg=black ctermbg=darkyellow cterm=none

hi! link EndOfBuffer NonText

hi! link ErrorMsg Error

hi! VertSplit ctermfg=darkgrey ctermbg=none cterm=none
hi! Folded ctermfg=darkgrey ctermbg=black cterm=none
hi! FoldColumn ctermfg=darkgrey ctermbg=none cterm=none
hi! IncSearch ctermfg=black ctermbg=darkyellow cterm=none

hi! link SignColumn Comment

hi! LineNr ctermfg=darkgrey ctermbg=none cterm=none
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr

hi! CursorLineNr ctermfg=darkyellow ctermbg=black cterm=none
hi! link CursorLineFold CursorLine
hi! link CursorLineSign CursorLine

hi! MatchParen ctermfg=darkgreen ctermbg=none cterm=underline

hi! link MessageWindow WarningMsg
hi! link ModeMsg Normal
hi! MoreMsg ctermfg=none ctermbg=none cterm=bold
hi! NonText ctermfg=darkgrey ctermbg=none cterm=none

hi! Normal ctermfg=none ctermbg=none cterm=none

hi! Pmenu ctermfg=none ctermbg=darkgrey cterm=none
hi! PmenuSel ctermfg=none ctermbg=black cterm=none
" hi! PmenuKind
" hi! PmenuKindSel
" hi! PmenuExtra
" hi! PmenuExtraSel
hi! link PmenuSbar Pmenu
" hi! PmenuThumb

hi! link PopupNotification WarningMsg

hi! Question ctermfg=none ctermbg=none cterm=bold
" hi! QuickFixLine

hi! Search ctermfg=green ctermbg=none cterm=inverse
" hi! CurSearch

hi! SpecialKey ctermfg=darkmagenta ctermbg=none cterm=none
hi! SpellBad ctermfg=darkred ctermbg=none cterm=undercurl
hi! SpellCap ctermfg=darkcyan ctermbg=none cterm=undercurl
hi! SpellLocal ctermfg=darkyellow ctermbg=none cterm=undercurl
hi! SpellRare ctermfg=darkcyan ctermbg=none cterm=undercurl

hi! StatusLine ctermfg=none ctermbg=lightgrey cterm=bold
hi! StatusLineNC ctermfg=none ctermbg=darkgrey cterm=none
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

hi! TabLine ctermfg=none ctermbg=none cterm=none
hi! TabLineFill ctermfg=black ctermbg=none cterm=none
hi! link TabLineSel Normal

" hi! Terminal

hi! Title ctermfg=darkgreen ctermbg=none cterm=bold
hi! Visual ctermfg=none ctermbg=darkgrey cterm=none
hi! link VisualNOS Visual

hi! WarningMsg ctermfg=darkyellow ctermbg=none cterm=inverse
hi! WildMenu ctermfg=black ctermbg=darkblue cterm=none

" hi! Menu
" hi! Scrollbar
" hi! Tooltip
