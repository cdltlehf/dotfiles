" https://github.com/prabirshrestha/vim-lsp

" help vim-lsp-performance
if !has('nvim')
  let g:lsp_use_native_client = 1
  " NOTE: If vim is slow, suspect the following line.
  let g:lsp_semantic_enabled = 1
  let g:lsp_format_sync_timeout = 1000
endif

" Also see: https://neovim.io/doc/user/lsp.html#lsp-defaults
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

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

  " " :help vim-lsp-folding
  set foldmethod=expr
  " XXX: The following code makes vim very slow
  " set foldexpr=lsp#ui#vim#folding#foldexpr()
  set foldtext=lsp#ui#vim#folding#foldtext()

  " nmap <buffer> gd <plug>(lsp-definition)
  " nmap <buffer> gs <plug>(lsp-document-symbol-search)
  " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  " nmap <buffer> gr <plug>(lsp-references)
  " nmap <buffer> gI <plug>(lsp-implementation)
  " nmap <buffer> gt <plug>(lsp-type-definition)
  nnoremap <buffer> [g <plug>(lsp-previous-diagnostic)
  nnoremap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 0

" :help g:lsp_diagnostics_signs_enabled
" nf-cod-error nf-cod-warning nf-cod-info nf-cod-question
if $NERD_FONT == 1
  let g:lsp_diagnostics_signs_error = {'text': ""}
  let g:lsp_diagnostics_signs_warning = {'text': ""}
  let g:lsp_diagnostics_signs_information = {'text': ""}
  let g:lsp_diagnostics_signs_hint = {'text': ""}
  let g:lsp_document_code_action_signs_hint = {'text': ""}
  let g:lsp_diagnostics_virtual_text_prefix = "▌"
else
  let g:lsp_diagnostics_signs_error = {'text': "E>"}
  let g:lsp_diagnostics_signs_warning = {'text': "W>"}
  let g:lsp_diagnostics_signs_information = {'text': "I>"}
  let g:lsp_diagnostics_signs_hint = {'text': "H>"}
  let g:lsp_document_code_action_signs_hint = {'text': "A>"}
  let g:lsp_diagnostics_virtual_text_prefix = "|"
endif

let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_padding_left = 5
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

" Refer: https://microsoft.github.io/language-server-protocol/implementors/servers/

" npm install -g vim-language-server
if executable('vim-language-server')
  augroup LspVim
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'vim-language-server',
          \   'cmd': {server_info->['vim-language-server', '--stdio']},
          \   'allowlist': ['vim'],
          \   'initialization_options': {
          \     'vimruntime': $VIMRUNTIME,
          \     'runtimepath': &runtimepath,
          \   }
          \ })
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
          \   'name': 'pylsp',
          \   'cmd': {server_info->['pylsp']},
          \   'allowlist': ['python'],
          \   'workspace_config': {
          \     'pylsp': {
          \       'plugins': {
          \         'autopep8': {'enabled': v:false},
          \         'yapf': {'enabled': v:false},
          \         'pyflakes': {'enabled': v:false},
          \         'pycodestyle': {'enabled': v:false},
          \         'rope_autoimport': {'enabled': v:false},
          \         'pylint': {'enabled': v:true},
          \         'black': {
          \           'enabled': v:true,
          \           'cache_config': v:true,
          \           'line_length': 80,
          \           'preview': v:true,
          \         },
          \         'pylsp_mypy': {
          \           'enabled': v:true,
          \           'strict': v:true,
          \           'overrides': [
          \             "--python-executable",
          \             trim(system('which python3')),
          \             v:true,
          \           ],
          \         },
          \         'isort': {'enabled': v:true, 'profile': 'google'},
          \       },
          \     },
          \   },
          \ })
  augroup END
endif

" npm install --global vscode-html-languageserver-bin
if executable('html-languageserver')
  augroup LspHtml
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'html-languageserver',
          \   'cmd': {
          \     server_info->[
          \       &shell,
          \       &shellcmdflag,
          \       'html-language-server',
          \       '--stdio'
          \     ]
          \   },
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
          \   'name': 'clangd',
          \   'cmd': {server_info->[
          \     'clangd',
          \     '--background-index',
          \     '--fallback-style=google',
          \   ]},
          \   'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cuda'],
          \ })
  augroup END
endif

if executable('deno')
  augroup LspDeno
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'deno',
          \   'cmd': {server_info->['deno', 'lsp']},
          \   'workspace_config': {
          \     'deno': {
          \       'enable': v:true,
          \       'lint': v:true,
          \       'unstable': v:true,
          \       'compilerOptions': {
          \         'lib': ['deno.ns', 'dom', 'esnext'],
          \       },
          \     },
          \   },
          \   'allowlist': [
          \     'javascript', 'typescript',
          \     'javascriptreact', 'typescriptreact',
          \   ],
          \ })
  augroup END
endif

if executable('rust-analyzer')
  augroup LspRust
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'rust-analyzer',
          \   'cmd': {server_info->['rust-analyzer']},
          \   'allowlist': ['rust'],
          \ })
  augroup END
endif

if executable('glasgow')
  augroup LspGlasgow
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'glasgow',
          \   'cmd': {server_info->['glasgow']},
          \   'allowlist': ['wgsl'],
          \ })
  augroup END
endif

if executable('taplo')
  augroup LspTaplo
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'taplo',
          \   'cmd': {server_info->['taplo', 'lsp', 'stdio']},
          \   'allowlist': ['toml'],
          \ })
  augroup END
endif

command LspDisableDiagnostics call lsp#disable_diagnostics_for_buffer()
command LspEnableDiagnostics call lsp#enable_diagnostics_for_buffer()
