" tab (buffer) line

augroup bufferline_highligh
  autocmd!
  autocmd ColorScheme,VimEnter * highlight link TabLineSelNr TabLineSel
augroup end

function! TabLine() abort
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
        let l:s .= '%#TabLineSelNr# ' . l:i . ' '
      endif

    endfor

    let l:s .= '%#TabLineFill#'
    return l:s
  endif
endfunction

function! BufferLine() abort
  let l:s = ''
  let l:bufls = filter(range(1, bufnr('$')), 'buflisted(v:val)')

  for l:i in l:bufls

    let l:bufname = bufname(l:i)
    if empty(l:bufname)
      let l:bufname = '[No Name]'
    else
      let l:bufname = fnamemodify(bufname(l:i), ":p:~:.")
      let l:bufname = substitute(
            \ l:bufname, '\(\.[^/]\|[^/]\)[^/]*/', '\1/', 'g')
      if l:i != bufnr('%')
        let l:bufname = substitute(
              \ l:bufname,
              \ '\(\.\{0,1}\w\)/\%(\.\{0,1}\w/\)\{3,}',
              \ '\1/.../', 'g')
      endif
    endif

    let l:flags = ''
    if !getbufvar(l:i, '&modifiable')
      let l:flags = '[-]'
    elseif getbufinfo(l:i)[0].changed
      let l:flags = '[+]'
    endif

    if l:i != bufnr('%')
      let l:s .= '%#TabLine# ' . l:i . " "
      let l:s .= '%#TabLine#' . l:bufname
    else
      let l:s .= '%#TabLineSelNr# ' . l:i . " \u258f"
      let l:s .= '%#TabLineSel#' . l:bufname
    endif
    let l:s .= l:flags . " "
  endfor

  let l:s .= '%#TabLineFill#'
  return l:s
endfunction

set tabline=%!TabLine()

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
