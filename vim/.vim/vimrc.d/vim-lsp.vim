" https://github.com/prabirshrestha/vim-lsp

"if executable('clangd')
"  autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'clangd',
"        \ 'cmd': {server_info->[
"        \   'clangd',
"        \   '--all-scopes-completion',
"        \   '--completion-style=bundled',
"        \ ]},
"        \ 'root_uri':{server_info->lsp#utils#path_to_uri(
"        \   lsp#utils#find_nearest_parent_file_directory(
"        \     lsp#utils#get_buffer_path(),
"        \     ['.clangd', 'compile_commands.json', '.git/']))},
"        \ 'allowlist': ['c', 'cpp', 'cc']})
"endif
"
"if executable('pylsp')
"  autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'python-lsp-server',
"        \ 'cmd': {server_info->['pylsp']},
"        \ 'allowlist': ['python']})
"endif

"if executable('cmake-language-server')
"  autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'cmake',
"        \ 'cmd': {server_info->['cmake-language-server']},
"        \ 'root_uri': {
"        \   server_info->lsp#utils#path_to_uri(
"        \     lsp#utils#find_nearest_parent_file_directory(
"        \       lsp#utils#get_buffer_path(), 'build/'))},
"        \ 'whitelist': ['cmake'],
"        \ 'initialization_options': {'buildDirectory': 'build'}})
"endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <localleader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  " scroll pop-up
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  " nnoremap <buffer> \g <plug>(lsp-document-diagnostics)
  " nnoremap <buffer> <localleader>ca <plug>(lsp-code-action)
  " nnoremap <buffer> <localleader>cl <plug>(lsp-code-lens)
  let g:lsp_signature_help_enabled = 0
  nnoremap <buffer> <localleader>fm <plug>(lsp-document-format)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
