" ~/.vim/after/ftplugin/python.vim

iabbrev <buffer> #! #!/usr/bin/env python3
iabbrev <buffer> python#! #!/usr/bin/env python
iabbrev <buffer> python3#! #!/usr/bin/env python3

compiler pylint
setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab

setlocal foldmethod=indent
setlocal foldlevel=99
