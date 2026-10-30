" Reference: https://protesilaos.com/emacs/modus-themes

set background=dark
set notermguicolors

highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = 'modus16'

let &t_Co=16

highlight Comment ctermfg=8 ctermbg=none cterm=none

highlight Constant ctermfg=darkcyan ctermbg=none cterm=none
highlight String ctermfg=darkgreen ctermbg=none cterm=none
highlight Character ctermfg=darkgreen ctermbg=none cterm=none
highlight Number ctermfg=darkcyan ctermbg=none cterm=none
highlight Boolean ctermfg=darkcyan ctermbg=none cterm=none
highlight Float ctermfg=darkcyan ctermbg=none cterm=none

highlight Identifier ctermfg=none ctermbg=none cterm=none
highlight Function ctermfg=darkblue ctermbg=none cterm=none

highlight Statement ctermfg=darkmagenta ctermbg=none cterm=none
highlight Conditional ctermfg=darkmagenta ctermbg=none cterm=none
highlight Repeat ctermfg=darkmagenta ctermbg=none cterm=none
highlight Label ctermfg=darkmagenta ctermbg=none cterm=none
highlight Operator ctermfg=none ctermbg=none cterm=none
highlight Keyword ctermfg=darkmagenta ctermbg=none cterm=none
highlight Exception ctermfg=darkmagenta ctermbg=none cterm=none

highlight PreProc ctermfg=darkmagenta ctermbg=none cterm=none
highlight Include ctermfg=darkmagenta ctermbg=none cterm=none
highlight Define ctermfg=darkmagenta ctermbg=none cterm=none
highlight Macro ctermfg=darkmagenta ctermbg=none cterm=none
highlight PreCondit ctermfg=darkmagenta ctermbg=none cterm=none

highlight Type ctermfg=darkcyan ctermbg=none cterm=none
highlight StorageClass ctermfg=darkmagenta ctermbg=none cterm=none
highlight Structure ctermfg=darkmagenta ctermbg=none cterm=none
highlight Typedef ctermfg=darkmagenta ctermbg=none cterm=none

highlight Special ctermfg=darkcyan ctermbg=none cterm=none
highlight SpecialChar ctermfg=darkcyan ctermbg=none cterm=none
highlight Tag ctermfg=darkblue ctermbg=none cterm=none
highlight Delimiter ctermfg=darkgrey ctermbg=none cterm=none
highlight SpecialComment ctermfg=darkgrey ctermbg=none cterm=none
highlight Debug ctermfg=darkmagenta ctermbg=none cterm=none

highlight Underlined ctermfg=none ctermbg=none cterm=underline
highlight Ignore cterm=none ctermbg=none cterm=none

highlight Error ctermfg=darkred ctermbg=none cterm=none
highlight Todo ctermfg=darkyellow ctermbg=none cterm=bold

highlight ColorColumn ctermfg=none ctermbg=darkgrey cterm=none
highlight Conceal ctermfg=darkcyan ctermbg=none cterm=none

highlight Cursor ctermfg=none ctermbg=none cterm=none
highlight! link lCursor Cursor
highlight! link CursorIM Cursor
highlight! link CursorColumn ColorColumn
highlight! link CursorLine CursorColumn

highlight Directory ctermfg=darkblue ctermbg=none cterm=bold

highlight DiffAdd ctermfg=0 ctermbg=10 cterm=none
highlight DiffChange ctermfg=none ctermbg=darkgrey cterm=none
highlight DiffDelete ctermfg=0 ctermbg=9 cterm=none
highlight DiffText ctermfg=0 ctermbg=14 cterm=none

highlight! link ErrorMsg Error

highlight VertSplit ctermfg=darkgrey ctermbg=none cterm=none
highlight! link WinSeparator VertSplit
highlight! link WinBar StatusLine
highlight! link WinBarNC StatusLineNC
highlight! link NormalNC Normal

highlight Folded ctermfg=darkgrey ctermbg=black cterm=none
highlight FoldColumn ctermfg=darkgrey ctermbg=none cterm=none

highlight LineNr ctermfg=darkgrey ctermbg=none cterm=none

highlight CursorLineNr ctermfg=darkyellow ctermbg=black cterm=none

highlight MatchParen ctermfg=darkcyan ctermbg=none cterm=underline

highlight! link MessageWindow WarningMsg
highlight! link ModeMsg Normal
highlight MoreMsg ctermfg=none ctermbg=none cterm=bold
highlight NonText ctermfg=darkgrey ctermbg=none cterm=none

highlight Normal ctermfg=none ctermbg=none cterm=none
highlight! link NormalFloat Pmenu
highlight! link FloatBorder VertSplit
highlight! link FloatShadow Pmenu
highlight! link FloatShadowThrough Pmenu

highlight Pmenu ctermfg=none ctermbg=black cterm=none
highlight PmenuSel ctermfg=darkblue ctermbg=none cterm=bold,inverse
highlight! link PmenuKind Pmenu
highlight! link PmenuKindSel PmenuSel
highlight! link PmenuExtra Pmenu
highlight! link PmenuExtraSel PmenuSel
highlight! link PmenuBorder VertSplit
highlight! link PmenuMatch CurSearch
highlight! link PmenuMatchSel Search
highlight! link PmenuShadow Pmenu
highlight! link PmenuShadowThrough Pmenu
highlight! link PmenuSbar Pmenu
highlight PmenuThumb ctermfg=none ctermbg=white cterm=none

highlight! link PopupNotification WarningMsg

highlight Question ctermfg=none ctermbg=none cterm=bold
highlight! link QuickFixLine PmenuSel

highlight Search ctermfg=darkgreen ctermbg=none cterm=inverse
highlight CurSearch ctermfg=darkyellow ctermbg=none cterm=inverse
highlight! link Substitute CurSearch

highlight SpecialKey ctermfg=darkmagenta ctermbg=none cterm=none
highlight SpellBad ctermfg=none ctermbg=none cterm=undercurl guisp=#ff5f59
highlight SpellCap ctermfg=none ctermbg=none cterm=undercurl guisp=#d0bc00
if !has('nvim')
  highlight SpellBad ctermul=darkred
  highlight SpellCap ctermul=darkyellow
endif
highlight! link SpellLocal SpellCap
highlight! link SpellRare SpellCap

highlight StatusLine ctermfg=none ctermbg=black cterm=none
highlight StatusLineNC ctermfg=darkgrey ctermbg=black cterm=none
highlight! link StatusLineTerm StatusLine
highlight! link StatusLineTermNC StatusLineNC

highlight TabLine ctermfg=none ctermbg=black cterm=none
highlight! link TabLineFill TabLine
highlight TabLineSel ctermfg=darkblue ctermbg=black cterm=inverse

highlight Title ctermfg=darkblue ctermbg=none cterm=bold
highlight Visual ctermfg=white ctermbg=darkgrey cterm=none
highlight! link SnippetTabstop Visual
highlight! link SnippetTabstopActive CurSearch

highlight WarningMsg ctermfg=darkyellow ctermbg=none cterm=inverse
highlight! link StderrMsg ErrorMsg
highlight! link StdoutMsg Normal
highlight! link MsgArea Normal
highlight! link MsgSeparator VertSplit
highlight WildMenu ctermfg=darkblue ctermbg=none cterm=bold,inverse
highlight! link TermCursor Cursor

if has('nvim')
  highlight! link @variable.builtin Statement
  highlight! link @constant.builtin Statement
  highlight! link @constant.macro PreProc

  highlight! link @string.regex Special

  highlight! link @function.builtin Function
  highlight! link @function.macro Macro

  highlight! link @constructor Type
  highlight! link @keyword.import Include

  highlight! link @type.builtin Type
  highlight! link @type.qualifier StorageClass
  highlight! link @type.definition Typedef

  highlight! link @tag.attribute Identifier
  highlight! link @tag.delimiter Delimiter

  highlight! link @comment.documentation SpecialComment

  highlight! link @markup.raw String
  highlight! link @markup.list Special
endif
