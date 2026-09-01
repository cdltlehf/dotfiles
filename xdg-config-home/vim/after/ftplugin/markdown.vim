
let &l:comments = ""
      \."b:*,b:-,b:+"
      \."b:1,b:2,b:3,b:4,b:5,b:6,b:7.,b:8.,b:9,"
      \."n:>"
setlocal comments=b:*,b:-,b:+,b:1.,b:2.,b:3.,b:4.,b:5.,b:6.,b:7.,b:8.,b:9.,n:>
let &formatlistpat = '^\s*\d\+\.\s\+\|^\s*[*-+]\s\+'
setlocal formatoptions=tcroqnl
