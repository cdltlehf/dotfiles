" Modus Themes (modus-vivendi16 / modus16) ANSI 16 cterm colorscheme
" Compliant with GNU Emacs Modus Themes (Protesilaos Stavrou) semantics

set background=dark
set notermguicolors

highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = 'modus16'

let &t_Co=16

" Standard Syntax Groups (:help group-name) {{{
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
highlight SpecialComment ctermfg=darkgrey ctermbg=none cterm=italic
highlight Debug ctermfg=darkmagenta ctermbg=none cterm=none

highlight Underlined ctermfg=none ctermbg=none cterm=underline
highlight Ignore cterm=none ctermbg=none cterm=none

highlight Error ctermfg=darkred ctermbg=none cterm=none
highlight Todo ctermfg=darkyellow ctermbg=none cterm=bold
" }}}

" UI Highlight Groups (:help highlight-groups) {{{
highlight ColorColumn ctermfg=white ctermbg=darkgrey cterm=none
highlight Conceal ctermfg=darkcyan ctermbg=none cterm=none

highlight Cursor ctermfg=none ctermbg=none cterm=none
highlight! link lCursor Cursor
highlight! link CursorIM Cursor
highlight! link CursorColumn ColorColumn
highlight! link CursorLine CursorColumn

highlight Directory ctermfg=darkblue ctermbg=none cterm=bold

highlight DiffAdd ctermfg=0 ctermbg=10 cterm=none
highlight DiffChange ctermfg=none ctermbg=darkgrey cterm=none
highlight DiffDelete ctermfg=9 ctermbg=none cterm=bold
highlight DiffText ctermfg=0 ctermbg=14 cterm=none
highlight! link DiffTextAdd DiffText
highlight! link Added DiffAdd
highlight! link Changed DiffChange
highlight! link Removed DiffDelete

highlight! link EndOfBuffer NonText
highlight! link ErrorMsg Error

highlight VertSplit ctermfg=darkgrey ctermbg=none cterm=none
highlight! link WinSeparator VertSplit
highlight! link WinBar StatusLine
highlight! link WinBarNC StatusLineNC
highlight! link NormalNC Normal

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

highlight MatchParen ctermfg=darkcyan ctermbg=none cterm=underline

highlight! link MessageWindow WarningMsg
highlight! link ModeMsg Normal
highlight MoreMsg ctermfg=none ctermbg=none cterm=bold
highlight NonText ctermfg=darkgrey ctermbg=none cterm=none

highlight Normal ctermfg=none ctermbg=none cterm=none
highlight! link NormalFloat Pmenu
highlight! link FloatBorder VertSplit
highlight! link FloatTitle Title
highlight! link FloatFooter Title
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
highlight! link ComplHint Comment
highlight! link ComplHintMore Comment
highlight! link ComplMatchIns PmenuMatch
highlight! link PreInsert Comment

highlight! link PopupNotification WarningMsg

highlight Question ctermfg=none ctermbg=none cterm=bold
highlight! link QuickFixLine PmenuSel

highlight Search ctermfg=darkgreen ctermbg=none cterm=inverse
highlight CurSearch ctermfg=darkyellow ctermbg=none cterm=inverse
highlight! link Substitute CurSearch

highlight SpecialKey ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Whitespace NonText
highlight SpellBad ctermfg=none ctermbg=none cterm=underline
highlight SpellCap ctermfg=none ctermbg=none cterm=underline
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
highlight Visual ctermfg=white ctermbg=none cterm=inverse
highlight! link VisualNOS Visual
highlight! link SnippetTabstop Visual
highlight! link SnippetTabstopActive CurSearch

highlight WarningMsg ctermfg=darkyellow ctermbg=none cterm=inverse
highlight! link OkMsg Function
highlight! link StderrMsg ErrorMsg
highlight! link StdoutMsg Normal
highlight! link MsgArea Normal
highlight! link MsgSeparator VertSplit
highlight WildMenu ctermfg=darkblue ctermbg=none cterm=bold,inverse
highlight! link TermCursor Cursor
" }}}

" Neovim Diagnostics & LSP {{{
highlight DiagnosticError ctermfg=9 ctermbg=none cterm=none
highlight DiagnosticWarn ctermfg=11 ctermbg=none cterm=none
highlight DiagnosticInfo ctermfg=12 ctermbg=none cterm=none
highlight DiagnosticHint ctermfg=14 ctermbg=none cterm=none
highlight DiagnosticOk ctermfg=10 ctermbg=none cterm=none

highlight DiagnosticUnderlineError ctermfg=9 ctermbg=none cterm=underline
highlight DiagnosticUnderlineWarn ctermfg=11 ctermbg=none cterm=underline
highlight DiagnosticUnderlineInfo ctermfg=12 ctermbg=none cterm=underline
highlight DiagnosticUnderlineHint ctermfg=14 ctermbg=none cterm=underline
highlight DiagnosticUnderlineOk ctermfg=10 ctermbg=none cterm=underline

highlight! link LspReferenceText Visual
highlight! link LspReferenceRead Visual
highlight! link LspReferenceWrite Visual
highlight! link LspReferenceTarget Visual
highlight! link LspInlayHint Comment
highlight! link LspCodeLens Comment
highlight! link LspCodeLensSeparator Comment
highlight! link LspSignatureActiveParameter CurSearch
" }}}

" Plugins (vim-lsp, gitgutter, copilot) {{{
highlight GitGutterAdd ctermfg=darkgreen ctermbg=none cterm=none
highlight GitGutterChange ctermfg=darkyellow ctermbg=none cterm=none
highlight GitGutterDelete ctermfg=darkred ctermbg=none cterm=none

highlight CopilotSuggestion ctermfg=darkgrey cterm=italic

highlight! link LspErrorHighlight DiagnosticUnderlineError
highlight! link LspWarningHighlight DiagnosticUnderlineWarn
highlight! link LspInformationHighlight DiagnosticUnderlineInfo
highlight! link LspHintHighlight DiagnosticUnderlineHint

highlight! link LspErrorText DiagnosticError
highlight! link LspWarningText DiagnosticWarn
highlight! link LspInformationText DiagnosticInfo
highlight! link LspHintText DiagnosticHint

highlight! link LspErrorVirtualText LspErrorText
highlight! link LspWarningVirtualText LspWarningText
highlight! link LspInformationVirtualText LspInformationText
highlight! link LspHintVirtualText LspHintText
" }}}

" Neovim Treesitter Mappings (Modus Semantics) {{{
highlight! link @variable Normal
highlight! link @variable.builtin Statement
highlight! link @variable.parameter Normal
highlight! link @variable.member Normal

highlight! link @constant Constant
highlight! link @constant.builtin Statement
highlight! link @constant.macro PreProc

highlight! link @string String
highlight! link @string.regex Special
highlight! link @string.escape SpecialChar

highlight! link @character Character
highlight! link @number Number
highlight! link @boolean Boolean
highlight! link @float Float

highlight! link @function Function
highlight! link @function.builtin Function
highlight! link @function.call Function
highlight! link @function.macro Macro
highlight! link @function.method Function

highlight! link @constructor Type
highlight! link @keyword Keyword
highlight! link @keyword.function Keyword
highlight! link @keyword.operator Keyword
highlight! link @keyword.return Keyword
highlight! link @keyword.import Include
highlight! link @keyword.repeat Repeat
highlight! link @keyword.conditional Conditional

highlight! link @conditional Conditional
highlight! link @repeat Repeat
highlight! link @label Label
highlight! link @operator Operator
highlight! link @exception Exception

highlight! link @type Type
highlight! link @type.builtin Type
highlight! link @type.qualifier StorageClass
highlight! link @type.definition Typedef

highlight! link @tag Tag
highlight! link @tag.attribute Identifier
highlight! link @tag.delimiter Delimiter

highlight! link @comment Comment
highlight! link @comment.documentation SpecialComment
highlight! link @comment.todo Todo
highlight! link @comment.warning DiagnosticWarn
highlight! link @comment.error DiagnosticError

highlight! link @markup.heading Title
highlight! link @markup.link Underlined
highlight! link @markup.strong Bold
highlight! link @markup.italic Italic
highlight! link @markup.raw String
highlight! link @markup.list Special
" }}}
