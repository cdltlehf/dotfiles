#!/bin/sh
(curl https://raw.githubusercontent.com/homebrew-zathura/homebrew-zathura/refs/heads/master/convert-into-app.sh | sh)

d=$(brew --prefix zathura)/lib/zathura
mkdir -p $d
for n in cb djvu pdf-mupdf pdf-poppler ps; do
  p=$(brew --prefix zathura-$n)/lib$n.dylib
  [ -f "$p" ] && ln -s "$p" "$d"
done
