" Reference: https://github.com/prabirshrestha/vim-lsp
" :help vim-lsp.txt

" help vim-lsp-performance
if !has('nvim')
  let g:lsp_use_native_client = 1
  " NOTE: If vim is slow, suspect the following line.
  " let g:lsp_semantic_enabled = 1
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
  nnoremap <buffer> <expr><c-e>
        \ lsp#document_hover_preview_winid() isnot v:null
        \ ? lsp#scroll(+1)
        \ : "\<c-e>"
  nnoremap <buffer> <expr><c-y>
        \ lsp#document_hover_preview_winid() isnot v:null
        \ ? lsp#scroll(-1)
        \ : "\<c-y>"

  nnoremap <buffer> grn <plug>(lsp-rename)<C-u>
  nnoremap <buffer> gra <plug>(lsp-code-action)
  nnoremap <buffer> grr <plug>(lsp-references)
  inoremap <buffer> <c-s> <c-o>:LspSignatureHelp<CR>

  " :help vim-lsp-folding
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
if getenv('LC_TERMINAL_GLYPHS') ==# 'nerdfont'
  let g:lsp_diagnostics_signs_error = {'text': ""}
  let g:lsp_diagnostics_signs_warning = {'text': ""}
  let g:lsp_diagnostics_signs_information = {'text': ""}
  let g:lsp_diagnostics_signs_hint = {'text': ""}
  let g:lsp_document_code_action_signs_hint = {'text': ""}
  let g:lsp_diagnostics_virtual_text_prefix = "▌"
elseif getenv('LC_TERMINAL_GLYPHS') ==# 'unicode'
  let g:lsp_diagnostics_signs_error = {'text': "✖"}
  let g:lsp_diagnostics_signs_warning = {'text': "⚠"}
  let g:lsp_diagnostics_signs_information = {'text': "ℹ"}
  let g:lsp_diagnostics_signs_hint = {'text': "?"}
  let g:lsp_document_code_action_signs_hint = {'text': "»"}
  let g:lsp_diagnostics_virtual_text_prefix = "■"
else
  let g:lsp_diagnostics_signs_error = {'text': "E"}
  let g:lsp_diagnostics_signs_warning = {'text': "W"}
  let g:lsp_diagnostics_signs_information = {'text': "I"}
  let g:lsp_diagnostics_signs_hint = {'text': "H"}
  let g:lsp_document_code_action_signs_hint = {'text': ">"}
  let g:lsp_diagnostics_virtual_text_prefix = ". "
endif

let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_padding_left = 5
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

" Refer: https://microsoft.github.io/language-server-protocol/implementors/servers/

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

if executable('ty')
  augroup LspTy
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'ty',
          \   'cmd': {server_info->['ty', 'server']},
          \   'allowlist': ['python'],
          \ })
  augroup END
endif

if executable('ruff')
  augroup LspRuff
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'ruff',
          \   'cmd': {server_info->['ruff', 'server']},
          \   'allowlist': ['python'],
          \ })
  augroup END
endif

if executable('html-languageserver')
  augroup LspHtml
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'html-languageserver',
          \   'cmd': {server_info->['html-languageserver', '--stdio']},
          \   'allowlist': ['html'],
          \ })
  augroup END
endif

if executable('bash-language-server')
  augroup LspBash
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'bash-language-server',
          \   'cmd': {server_info->['bash-language-server', 'start']},
          \   'allowlist': ['sh', 'bash', 'zsh'],
          \ })
  augroup END
endif

if executable('lua-language-server')
  augroup LspLua
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'lua-language-server',
          \   'cmd': {server_info->['lua-language-server']},
          \   'allowlist': ['lua'],
          \ })
  augroup END
endif

if executable('yaml-language-server')
  augroup LspYaml
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'yaml-language-server',
          \   'cmd': {server_info->['yaml-language-server', '--stdio']},
          \   'allowlist': ['yaml', 'yaml.docker-compose', 'yaml.gitlab'],
          \ })
  augroup END
endif

if executable('clangd')
  augroup LspClangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'clangd',
          \   'cmd': {server_info->[
          \     'clangd',
          \     '--fallback-style=google'
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

if executable('marksman')
  augroup LspMarksman
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'marksman',
          \   'cmd': {server_info->['marksman', 'server']},
          \   'allowlist': ['markdown'],
          \ })
  augroup END
endif

command LspDisableDiagnostics call lsp#disable_diagnostics_for_buffer()
command LspEnableDiagnostics call lsp#enable_diagnostics_for_buffer()

if executable('markdownlint-lsp')
  augroup LspMarkdownlint
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'markdownlint-lsp',
          \   'cmd': {server_info->['markdownlint-lsp', '--stdio']},
          \   'allowlist': ['markdown', 'markdown.mdx'],
          \ })
  augroup END
endif

if executable('efm-langserver')
  augroup LspEfm
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \   'name': 'efm-langserver',
          \   'cmd': {server_info->['efm-langserver']},
          \   'allowlist': ['yaml'],
          \ })
  augroup END
endif
