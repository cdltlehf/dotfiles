" https://github.com/prabirshrestha/vim-lsp

if executable('clangd')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->[
        \   'clangd',
        \   '--all-scopes-completion',
        \   '--completion-style=bundled',
        \ ]},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(
        \   lsp#utils#find_nearest_parent_file_directory(
        \     lsp#utils#get_buffer_path(),
        \     ['.clangd', 'compile_commands.json', '.git/']))},
        \ 'allowlist': ['c', 'cpp', 'cc']})
endif

if executable('pylsp')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'python-lsp-server',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python']})
endif

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

function! s:lsp_buffer_mappings()
  nmap <buffer> gd <Plug>(lsp-definition)
  " nmap <buffer> gi <Plug>(lsp-implementation)
  " nmap <buffer> gr <Plug>(lsp-references)
  " nmap <buffer> gy <Plug>(lsp-type-definition)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  " nmap <buffer> \g <Plug>(lsp-document-diagnostics)
  " nmap <buffer> <LocalLeader>ca <Plug>(lsp-code-action)
  " nmap <buffer> <localLeader>cl <Plug>(lsp-code-lens)
  nmap <buffer> <LocalLeader>rn <Plug>(lsp-rename)
  nmap <buffer> K <Plug>(lsp-hover)
  nmap <buffer> <LocalLeader>fm <Plug>(lsp-document-format)
  xmap <buffer> <LocalLeader>fm <Plug>(lsp-document-format)
endfunction

autocmd User lsp_buffer_enabled call s:lsp_buffer_mappings()
