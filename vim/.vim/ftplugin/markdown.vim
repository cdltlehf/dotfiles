" ~/.vim/ftplugin/markdown.vim

setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab

setlocal comments=b:*,b:-,b:+,b:1.,b:2.,b:3.,b:4.,b:5.,b:6.,b:7.,b:8.,b:9.,n:>
let &formatlistpat = '^\s*\d\+\.\s\+\|^\s*[*-+]\s\+'
setlocal formatoptions=tcroqnl

inoremap <buffer> <expr> <tab> TabFunc()
" XXX: Why the below mapping works?
inoremap <buffer> <expr> <s-tab> ShiftedTabFunc()

inoremap <buffer> <expr> <space> SpaceFunc()
inoremap <buffer> <expr> <bs> BSFunc()
inoremap <buffer> <expr> <cr> CRFunc()

function TabFunc() "{{{
  if col(".") != col("$") | return "\<tab>" | endif

  let l:line = getline(".")
  if l:line =~ '^\s*\d\.\s*$'
    " Indent auto resetting
    return "\<c-t>a\<bs>\<esc>^ct.1\<esc>A"
  elseif l:line =~ '^\s*[-*+]\s*$'
    return "\<c-t>"
  endif

  return "\<tab>"
endfunction "}}}

function ShiftedTabFunc() "{{{
  if col(".") != col("$") | return "\<s-tab>" | endif

  let l:line = getline(".")
  if l:line =~ '^\s*\d\.\s*$'
    " TODO: Index auto setting
    return "\<c-d>"
  elseif l:line =~ '^\s*[-*+]\s*$'
    return "\<c-d>"
  endif

  return "\<s-tab>"
endfunction "}}}

function! SpaceFunc() "{{{1
  if col(".") != col("$") | return "\<space>" | endif

  let l:line = getline(".")
  if l:line =~ '^\s*\d\.$'
    return "\<tab>"
  elseif l:line =~ '^\s*[-*+]$'
    return "\<tab>"
  endif

  return "\<space>"
endfunction "}}}

function! BSFunc() "{{{
  if col(".") != col("$") | return "\<bs>" | endif

  let l:line = getline(".")

  if l:line =~ '^\s*\d\.\s*$'
    return "\<c-u>"
  elseif l:line =~ '^\s*[-*+]\s*$'
    return "\<c-u>"
  elseif l:line =~ '^#\{1,6\}\s*$'
    return "\<c-u>"
  endif

  return "\<bs>"
endfunction "}}}

function! CRFunc() "{{{
  if col(".") != col("$") | return "\<cr>" | endif

  let l:line = getline(".")

  if l:line =~ '^\s*\d\.\s*$'
    return "\<c-u>"
  elseif l:line =~ '^\s*[-*+]\s*$'
    return "\<c-u>"
  elseif l:line =~ '^#\{1,6\}\s*$'
    return "\<c-u>"
  elseif l:line =~ '^\s*\d\.\s*'
    " Index auto increasing
    return "\<cr>a\<bs>\<esc>^\<c-a>A"
  elseif l:line =~ '^#\{1,6\}\s*'
    " Header auto margin
    if getline(line(".")-1) !~ '^\s*$'
      return "\<esc>O\<esc>jA\<cr>\<cr>"
    else
      return "\<cr>\<cr>"
    endif
  endif

  return "\<cr>"
endfunction "}}}
