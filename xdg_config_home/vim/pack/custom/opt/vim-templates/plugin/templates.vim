if !exists('g:template_dir')
  let g:template_dir = expand('~/.vim/templates')
endif

augroup TemplateLoader
  autocmd!
  autocmd BufNewFile [Mm]akefile call s:load_template('Makefile.template')
  autocmd BufNewFile pyproject.toml call s:load_template('pyproject.template')
  autocmd BufNewFile pylintrc,.pylintrc call s:load_template('pylintrc.template')
  autocmd BufNewFile *.h call s:load_template('h.template')
  autocmd BufNewFile *.py call s:load_template('py.template')
  autocmd BufNewFile *.{cc,cpp,cxx}
        \ if expand('%:t:r') ==# 'main' |
        \   call s:load_template('main_cxx.template') |
        \ else |
        \   call s:load_template('cpp.template') |
        \ endif
augroup END


function! s:load_template(template_name)
  let template_path = g:template_dir . '/' . a:template_name
  if filereadable(template_path)
    silent! execute '0read' template_path
    silent! execute '$,$g/^$/d'
    silent! execute 'g/^#/d'
    silent! execute '%s/`v:\([^`]\+\)`/\=eval(submatch(1))/g'
  endif
endfunction
