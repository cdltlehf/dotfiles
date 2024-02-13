function s:set_guard() abort
  let s:filename = expand('%:t')
  let s:guard = substitute(toupper(s:filename), '\c[^a-z0-9_]', '_', 'g')."_"
  call setbufline('%', '$', "#ifndef " . s:guard)
  call appendbufline('%', '$', "#define " . s:guard)
  call appendbufline('%', '$', "")
  call appendbufline('%', '$', "")
  call appendbufline('%', '$', "")
  call appendbufline('%', '$', "#endif  // " . s:guard)
  call cursor(4, 0)
  echo s:guard
endfunction

augroup vim_template
  autocmd!
  autocmd BufNewFile *.h call s:set_guard()
augroup END
