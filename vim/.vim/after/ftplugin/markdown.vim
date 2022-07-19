" ~/.vim/after/ftplugin/markdown.vim

setlocal tabstop=4 softtabstop=4 shiftwidth=4

setlocal comments=b:*,b:-,b:+,b:1.,n:>
let &formatlistpat = '^\s*\d\+\.\s\+\|^\s*[*-+]\s\+'
setlocal formatoptions=tcroqnl

inoremap <buffer> <tab> <c-t>
inoremap <buffer> <s-tab> <c-d>

inoremap <buffer> <expr> <space> SpaceFunc()
inoremap <buffer> <expr> <cr> EnterFunc()

function! SpaceFunc()
  if col(".") != col("$") | return "\<space>" | endif

  let l:line = getline(".")
  if l:line =~ '^\s*\d\+\.$'
    return "\<tab>"
  elseif l:line =~ '^\s*[*-+]$'
    return "\<tab>"
  endif

  return "\<space>"
endfunction

function! EnterFunc()
  if col(".") != col("$") | return "\<cr>" | endif

  let l:line = getline(".")
  if getline(".") =~ '^\s*\d\+\.\s*$'
    return "\<esc>^C"
  elseif getline(".") =~ '^\s*[*-+]\s*$'
    return "\<esc>^C"
  elseif getline(".") =~ '^#\s*$'
    return "\<esc>^C"
  endif

  return "\<cr>"
endfunction
