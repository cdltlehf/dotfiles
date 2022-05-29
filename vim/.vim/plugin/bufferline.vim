" tab (buffer) line
" Dracula Color Palette {{{1
" https://spec.draculatheme.com/
let background='#282a36'
let foreground='#f8f8f2'
let selection='#44475a'
let comment='#6272a4'

let red='#ff5555'
let orange='#ffb86c'
let yellow='#f1fa8c'
let green='#50fa7b'
let purple='#bd93f9'
let cyan='#8be9fd'
let pink='#ff79c6'

set showtabline=2
set tabline=%!TabLine()

" highlight clear TabLineSelNR
" highlight clear TabLineSel
" highlight clear TabLine
" highlight clear TabLineFill
augroup tabline_highlight "{{{1
  autocmd!
  autocmd ColorScheme,VimEnter * 
        \ execute 'highlight TabLineSelNR '
        \ . 'guibg=' . background . ' guifg=' . green |
        \ execute 'highlight TabLineSel '
        \ . 'guibg=' . background . ' guifg=' . foreground |
        \ execute 'highlight TabLine '
        \ . 'guibg=' . selection . ' guifg=' . foreground |
        \ execute 'highlight TabLineFill '
        \ . 'guibg=' . selection . ' guifg=' . selection
augroup END

function! TabLine() abort "{{{1
  if tabpagenr('$') == 1
    return BufferLine()
  else
    return ''
  endif
endfunction

function! BufferLine() abort "{{{1
  let s = ''
  let bufls = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  " let leftmost = min(1, bufnr('$')))

  for i in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if i == bufnr('%')
      let s .= '%#TabLineSelNR# '
      let s .= i
      let s .= ' %#TabLineSel#'
    else
      let s .= '%#TabLine# '
      let s .= i
      let s .= ' '
    endif
    let filename = '%{'
    if i != bufnr('%')
      let filename .= 'substitute('
    endif
    let filename .= 'fnamemodify(bufname(' . i . '), ":~:.")'
    if i != bufnr('%')
      let filename .= ', "\\(\\.[^/]\\|[^/]\\)[^/]*/", "\\1/", "g")'
    endif
    let filename .= '}'
    let s .= filename
    let s .= '%{!getbufvar(' . i . ', "&modifiable") ?'
    let s .= ' "[-]" :' 
    let s .= ' (getbufinfo(' . i . ')[0].changed ? "[+]" : "")}'
    let s .= ' '
  endfor
  let s .= '%#TabLineFill#'
  return s
endfunction
"}}}

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
