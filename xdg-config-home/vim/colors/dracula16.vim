set background=dark
set notermguicolors

highlight clear
let g:colors_name = 'dracula16'

let &t_Co=16

" spec.draculatheme.com {{{
highlight! Dracula16Invalid ctermfg=none ctermbg=darkred cterm=none
highlight! Dracula16Deprecated ctermfg=none ctermbg=darkred cterm=none
highlight! Dracula16Error ctermfg=darkred ctermbg=none cterm=none

highlight! Dracula16DiffText ctermfg=darkgrey ctermbg=none cterm=none
highlight! Dracula16DiffHeader ctermfg=darkgrey ctermbg=none cterm=none
highlight! Dracula16Inserted ctermfg=darkgreen ctermbg=none cterm=underline
highlight! Dracula16Deleted ctermfg=darkred ctermbg=none cterm=underline
highlight! Dracula16Changed ctermfg=darkyellow ctermbg=none cterm=underline

" TODO: Markup

highlight! Dracula16ClassName ctermfg=darkblue ctermbg=none cterm=none
highlight! Dracula16InstanceReservedWords ctermfg=darkmagenta ctermbg=none cterm=italic
highlight! Dracula16InheritedClassName ctermfg=darkcyan ctermbg=none cterm=italic

highlight! Dracula16Comment ctermfg=darkgrey ctermbg=none cterm=none
highlight! Dracula16DocCommentKeywords ctermfg=darkmagenta ctermbg=none cterm=none
highlight! Dracula16DocCommentTypes ctermfg=darkcyan ctermbg=none cterm=italic
highlight! Dracula16DocParameters ctermfg=darkyellow ctermbg=none cterm=italic

highlight! Dracula16Constant ctermfg=darkmagenta ctermbg=none cterm=none
highlight! Dracula16ConstantEscapeSequences ctermfg=darkmagenta ctermbg=none cterm=none

" TODO: Entities

highlight! Dracula16FunctionNames ctermfg=darkgreen ctermbg=none cterm=none
highlight! Dracula16FunctionParameters ctermfg=darkyellow ctermbg=none cterm=italic
highlight! Dracula16Decorators ctermfg=darkgreen ctermbg=none cterm=italic

highlight! Dracula16Keyword ctermfg=darkmagenta ctermbg=none cterm=none
highlight! Dracula16KeyworkNew ctermfg=darkmagenta ctermbg=none cterm=bold
highlight! Dracula16KeywordGenericCssSelector ctermfg=darkmagenta ctermbg=none cterm=none

" TODO: Language Built-ins
" TODO: Punctuation
" TODO: Serializable / Configuration Languages
" TODO: Storage

highlight! Dracula16String ctermfg=darkyellow ctermbg=none cterm=none
highlight! Dracula16StringRegExp ctermfg=darkred ctermbg=none cterm=none

highlight! Dracula16Variable ctermfg=white ctermbg=none cterm=none
highlight! Dracula16ObjectKeys ctermfg=white ctermbg=none cterm=none
highlight! Dracula16DestructuringAliasLHS ctermfg=darkyellow ctermbg=none cterm=italic
highlight! Dracula16DestructuringAliasRHS ctermfg=white ctermbg=none
" }}}

" :help group-name
highlight! link Comment Dracula16Comment

highlight Constant ctermfg=darkblue ctermbg=none cterm=none
highlight! link String Dracula16String
highlight Character ctermfg=darkmagenta ctermbg=none cterm=none
highlight! link Number Constant
highlight! link Boolean Constant
highlight! link Float Constant

highlight Identifier ctermfg=none ctermbg=none cterm=none
highlight! link Function Dracula16FunctionNames

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
" highlight Terminal

highlight Title ctermfg=darkgreen ctermbg=none cterm=bold
highlight Visual ctermfg=white ctermbg=none cterm=inverse
highlight! link VisualNOS Visual

highlight WarningMsg ctermfg=darkyellow ctermbg=none cterm=inverse
highlight WildMenu ctermfg=darkblue ctermbg=none cterm=bold,inverse

" highlight Menu
" highlight Scrollbar
" highlight Tooltip

" airblade/vim-gitgutter {{{
highlight GitGutterAdd ctermfg=darkgreen ctermbg=none cterm=none
highlight GitGutterChange ctermfg=darkyellow ctermbg=none cterm=none
highlight GitGutterDelete ctermfg=darkred ctermbg=none cterm=none
" }}}

" github/copilot {{{
highlight CopilotSuggestion ctermfg=darkgrey cterm=italic
" }}}

" prabirshrestha/vim-lsp {{{
highlight! link LspErrorHighlight Error
highlight! link LspWarningHighlight Todo
highlight LspInformationHighlight ctermfg=darkblue ctermbg=none cterm=none
highlight LspHintHighlight ctermfg=darkgreen ctermbg=none cterm=none

highlight! link LspErrorText Error
highlight! link LspWarningText Todo
highlight! link LspInformationText LspInformationHighlight
highlight! link LspHintText LspHintHighlight

highlight! link LspErrorVirtualText LspErrorText
highlight! link LspWarningVirtualText LspWarningText
highlight! link LspInformationVirtualText LspInformationText
highlight! link LspHintVirtualText LspHintText
" }}}

" Typescript: {{{
highlight! link typescriptArrowFuncArg Identifier
highlight! link typescriptFuncCallArg Identifier

highlight! link typescriptArrowFunction Operator
highlight! link typescriptOperator Operator
highlight! link typescriptUnaryOp Operator
highlight! link typescriptBinaryOp Operator
highlight! link typescriptTernaryOp Operator
highlight! link typescriptAssign Operator

highlight! link typescriptGlobal Type
highlight! link typescriptTypeReference Type

highlight! link typescriptVariable Keyword
highlight! link typescriptKeywordOp Keyword

highlight! link typescriptDestructureLabel Dracula16DestructuringAliasLHS
highlight! link typescriptDestructureVariable Dracula16DestructuringAliasRHS
highlight! link typescriptObjectLabel Dracula16ObjectKeys

highlight! link typescriptRegexpString Dracula16StringRegExp
" }}}
