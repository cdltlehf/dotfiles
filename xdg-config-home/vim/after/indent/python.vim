" Reference:
" - https://github.com/google/styleguide/blob/gh-pages/google_python_style.vim
"
" Copyright 2019 Google LLC
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"    https://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" Indent Python in the Google way.

setlocal indentexpr=GetCustomPythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

let g:pyindent_nested_paren="&sw"
let g:pyindent_open_paren="&sw"

function! GetCustomPythonIndent(lnum)
  " XXX: I do not consider edge cases now
  "
  " If the previous line ends with backslash, align with the 'open()' function
  " E.g.
  "   with open(foo.txt, 'r') as foo \
  "        open(bar.txt, 'r') as bar \
  "        ...
  let plnum = prevnonblank(a:lnum - 1)

  if getline(plnum) =~ '\\$'
    call cursor(plnum, 1)
    let [open_line, open_col] = searchpos('open', 'n')
    echom open_col
    if open_col > 0
      return open_col - 1
    endif
  endif

  " If the previous line ends with a colon and starts with 'open' function,
  " align with previous 'with' or 'def' statement
  " E.g.
  "   with open(foo.txt, 'r') as foo \
  "        open(bar.txt, 'r') as bar:
  "       do_something()
  if getline(plnum) =~ ':$' && getline(plnum) =~ '^\s*open'
    let with_line = search('with', 'bn')
    if with_line > 0
      let with_line_indent = indent(with_line)
      if with_line_indent > -1
        return with_line_indent + shiftwidth()
      endif
    endif
  endif

  " If the line starts with close paren, align with start of line of its
  " opening paren
  " E.g.
  "   foo = [
  "     0,
  "     1,
  "   ]
  if getline(a:lnum) =~ '^\s*[)\|}\|\]]'
    echo "Hello"
    echo a:lnum
    call cursor(a:lnum, 1)

    let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
          \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
          \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
          \ . " =~ '\\(Comment\\|String\\)$'")
    if par_line > 0
      call cursor(par_line, 1)
      if par_col != col("$") - 1
        return par_col
      else
        return indent(par_line)
      endif
    endif
  endif

  return GetGooglePythonIndent(a:lnum)

endfunction


function! GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction
