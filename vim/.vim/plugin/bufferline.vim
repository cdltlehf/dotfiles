" tab (buffer) line
" Dracula Color Palette {{{1
" https://spec.draculatheme.com/
let s:background='#282a36'
let s:foreground='#f8f8f2'
let s:selection='#44475a'
let s:comment='#6272a4'

let s:red='#ff5555'
let s:orange='#ffb86c'
let s:yellow='#f1fa8c'
let s:green='#50fa7b'
let s:purple='#bd93f9'
let s:cyan='#8be9fd'
let s:pink='#ff79c6'
"}}}

set showtabline=2
set tabline=%!TabLine()

augroup tabline_highlight "{{{1
  autocmd!
  autocmd ColorScheme,VimEnter *
        \ highlight clear TabLine
        \|highlight clear TabLineSelNR
        \|highlight clear TabLineSel
        \|highlight clear TabLineFill
        \|execute 'highlight TabLine'
        \ . ' guibg=' . s:selection . ' guifg=' . s:foreground
        \ . ' cterm=None gui=None'
        \|execute 'highlight TabLineSelNR'
        \ . ' guibg=' . s:background . ' guifg=' . s:purple
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight TabLineSel'
        \ . ' guibg=' . s:background . ' guifg=' . s:foreground
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight TabLineFill'
        \ . ' guibg=' . s:selection . ' guifg=' . s:selection
        \ . ' cterm=None gui=None'
augroup END "}}}

augroup bufline_highlight "{{{1
  autocmd!
  autocmd ColorScheme,VimEnter *
        \ highlight clear BufLine
        \|highlight clear BufLineUntitled
        \|highlight clear BufLineSelNR
        \|highlight clear BufLineSel
        \|highlight clear BufLineSelUntitled
        \|highlight clear BufLineFill
        \|execute 'highlight BufLine'
        \ . ' guibg=' . s:selection . ' guifg=' . s:foreground
        \ . ' cterm=None gui=None'
        \|execute 'highlight BufLineUntitled'
        \ . ' guibg=' . s:selection . ' guifg=' . s:foreground
        \ . ' cterm=italic gui=italic'
        \|execute 'highlight BufLineSelNR'
        \ . ' guibg=' . s:background . ' guifg=' . s:green
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight BufLineSel'
        \ . ' guibg=' . s:background . ' guifg=' . s:foreground
        \ . ' cterm=bold gui=bold'
        \|execute 'highlight BufLineSelUntitled'
        \ . ' guibg=' . s:background . ' guifg=' . s:foreground
        \ . ' cterm=bold,italic gui=bold,italic'
        \|execute 'highlight BufLineFill'
        \ . ' guibg=' . s:selection . ' guifg=' . s:selection
        \ . ' cterm=None gui=None'
augroup END "}}}

function! TabLine() abort "{{{1
  if tabpagenr('$') ==# 1
    return BufferLine()
  else
    let l:s = ''
    let l:tabls = range(1, tabpagenr('$'))

    for l:i in l:tabls

      let l:bufname = l:i

      if l:i != tabpagenr()
        let l:s .= '%#TabLine# ' . l:i . ' '
      else
        let l:s .= '%#TabLineSelNR# ' . l:i . ' '
      endif

    endfor

    let l:s .= '%#TabLineFill#'
    return l:s
  endif
endfunction "}}}

function! BufferLine() abort "{{{1
  let l:s = ''
  let l:bufls = filter(range(1, bufnr('$')), 'buflisted(v:val)')

  for l:i in l:bufls

    let l:bufname = bufname(l:i)
    let l:untitled = 0

    if l:bufname ==# ''
      let l:untitled = 1

    elseif l:i != bufnr('%')
      let l:bufname = fnamemodify(bufname(l:i), ":~:.")
      let l:bufname =
            \ substitute(l:bufname, '\(\.[^/]\|[^/]\)[^/]*/', '\1/', 'g')

    end

    let l:flags = ''
    if !getbufvar(l:i, '&modifiable')
      let l:flags = '[-]'
    elseif getbufinfo(l:i)[0].changed
      let l:flags = '[+]'
    endif

    if l:i != bufnr('%')
      let l:s .= '%#BufLine# ' . l:i
      if !l:untitled
        let l:s .= '%#BufLine# ' . l:bufname
      else
        let l:s .= '%#BufLineUntitled# Untitled'
      endif
    else
      let l:s .= '%#BufLineSelNR# ' . l:i
      if !l:untitled
        let l:s .= '%#BufLineSel# ' . l:bufname
      else
        let l:s .= '%#BufLineSelUntitled# Untitled'
      endif

    endif

    let l:s .= l:flags . ' '

  endfor

  let l:s .= '%#BufLineFill#'
  return l:s
endfunction "}}}

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
