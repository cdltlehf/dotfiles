" https://github.com/prabirshrestha/vim-lsp

" Also see: https://neovim.io/doc/user/lsp.html
function! s:on_lsp_buffer_enabled() abort
  setlocal signcolumn=yes

  setlocal omnifunc=lsp#complete

  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nnoremap <buffer> <c-]> <plug>(lsp-definition)
  nnoremap <buffer> <c-w>] :rightbelow LspDefinition<CR>
  nnoremap <buffer> <c-w><c-]> :rightbelow LspDefinition<CR>
  nnoremap <buffer> <c-w>} <plug>(lsp-peek-definition)
  nnoremap <buffer> <c-w><c-}> <plug>(lsp-peek-definition)

  nnoremap <buffer> gq <plug>(lsp-document-range-format)
  nnoremap <buffer> gqq V<plug>(lsp-document-range-format)
  vnoremap <buffer> gq <plug>(lsp-document-range-format)
  " NOTE: https://clang.llvm.org/docs/ClangFormat.html#vim-integration
  nnoremap <buffer> <c-k> <plug>(lsp-document-format)

  nnoremap <buffer> K <plug>(lsp-hover)

  nnoremap <buffer> grn <plug>(lsp-rename)<C-u>
  nnoremap <buffer> gra <plug>(lsp-code-action)
  nnoremap <buffer> grr <plug>(lsp-references)
  inoremap <buffer> <c-s> <c-o>:LspSignatureHelp<CR>

  " :help vim-lsp-folding
  set foldmethod=expr
  set foldexpr=lsp#ui#vim#folding#foldexpr()
  set foldtext=lsp#ui#vim#folding#foldtext()

  " nmap <buffer> gd <plug>(lsp-definition)
  " nmap <buffer> gs <plug>(lsp-document-symbol-search)
  " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  " nmap <buffer> gr <plug>(lsp-references)
  " nmap <buffer> gI <plug>(lsp-implementation)
  " nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)

  " nnoremap <buffer> <leader>g <plug>(lsp-document-diagnostics)
  " nnoremap <buffer> <leader>cl <plug>(lsp-code-lens)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1

" :help g:lsp_diagnostics_signs_enabled
" nf-cod-error nf-cod-warning nf-cod-info nf-cod-question
let g:lsp_diagnostics_signs_error = {'text': "\uEA87"}
let g:lsp_diagnostics_signs_warning = {'text': "\uea6c"}
let g:lsp_diagnostics_signs_information = {'text': "\uea74"}
let g:lsp_diagnostics_signs_hint = {'text': "\ueb32"}
" nf-cod-lightbulb
let g:lsp_document_code_action_sign = {'text': "\ueb13"}

let g:lsp_diagnostics_virtual_text_prefix = "\u258C"
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_padding_left = 5
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

" :help vim-lsp-semantic
if has('textprop') || has('nvim')
  let g:lsp_semantic_enabled = 1
endif

" npm install -g vim-language-server
if executable('vim-language-server')
  augroup LspVim
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'vim-language-server',
          \ 'cmd': {server_info->['vim-language-server', '--stdio']},
          \ 'allowlist': ['vim'],
          \ 'initialization_options': {
          \   'vimruntime': $VIMRUNTIME,
          \   'runtimepath': &runtimepath,
          \ }})
  augroup END
endif

" pip install 'python-lsp-server[all]'
" pip install python-lsp-isort
" pip install pylsp-mypy
" pip install python-lsp-black
if executable('pylsp')
  augroup LspPylsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pylsp',
          \ 'cmd': {server_info->['pylsp']},
          \ 'allowlist': ['python'],
          \ 'workspace_config': {
          \   'pylsp': {
          \     'plugins': {
          \       'black': {'enabled': v:true},
          \       'autopep8': {'enabled': v:false},
          \       'yapf': {'enabled': v:false},
          \       'pylint': {'enabled': v:true},
          \       'pyflakes': {'enabled': v:false},
          \       'pycodestyle': {'enabled': v:false},
          \       'pylsp_mypy': {'enabled': v:true, 'strict': v:true},
          \       'pyls_isort': {'enabled': v:true},
          \     },
          \   },
          \ },
          \ })
  augroup END
endif

" npm install --global vscode-html-languageserver-bin
if executable('html-languageserver')
  augroup LspHtml
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'html-languageserver',
          \ 'cmd': {
          \   server_info->[
          \     &shell,
          \     &shellcmdflag,
          \     'html-language-server',
          \     '--stdio'
          \   ]
          \ },
          \ 'allowlist': ['html'],
          \ })
  augroup END
endif

" macOS: brew install llvm
" TODO: Linux
if executable('clangd')
  augroup LspClangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->[
          \   'clangd',
          \   '--background-index',
          \   '--fallback-style=google',
          \ ]},
          \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cuda'],
          \ })
  augroup END
endif

" macOS: brew instal shellcheck
" TODO: Linux
if executable('shellcheck')
  augroup LspShellcheck
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'shellcheck',
          \ 'cmd': {server_info->['shellcheck', '--stdio']},
          \ 'allowlist': ['sh', 'bash', 'zsh'],
          \ })
  augroup END
endif
