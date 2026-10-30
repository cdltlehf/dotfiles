" Reference: https://github.com/prabirshrestha/vim-lsp
" Reference: https://clang.llvm.org/docs/ClangFormat.html#vim-integration
" Reference: https://neovim.io/doc/user/lsp.html#lsp-defaults

if !has('nvim')
  let g:lsp_use_native_client = 1
  let g:lsp_format_sync_timeout = 1000
endif

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

if getenv('LC_TERMINAL_GLYPHS') ==# 'nerdfont'
  let g:lsp_diagnostics_signs_error = {'text': ""}
  let g:lsp_diagnostics_signs_warning = {'text': ""}
  let g:lsp_diagnostics_signs_information = {'text': ""}
  let g:lsp_diagnostics_signs_hint = {'text': ""}
  let g:lsp_document_code_action_signs_hint = {'text': ""}
  let g:lsp_diagnostics_virtual_text_prefix = "▌"
elseif getenv('LC_TERMINAL_GLYPHS') ==# 'unicode'
  let g:lsp_diagnostics_signs_error = {'text': "×"}
  let g:lsp_diagnostics_signs_warning = {'text': "W"}
  let g:lsp_diagnostics_signs_information = {'text': "I"}
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

" Reference: https://microsoft.github.io/language-server-protocol/implementors/servers/
function! s:register_servers() abort
  let l:servers = [
        \   {
        \     'name': 'vim-language-server',
        \     'cmd': ['vim-language-server', '--stdio'],
        \     'allowlist': ['vim'],
        \     'initialization_options': {
        \       'vimruntime': $VIMRUNTIME,
        \       'runtimepath': &runtimepath,
        \     },
        \   },
        \   {'name': 'ty', 'cmd': ['ty', 'server'], 'allowlist': ['python']},
        \   {'name': 'ruff', 'cmd': ['ruff', 'server'], 'allowlist': ['python']},
        \   {
        \     'name': 'html-languageserver',
        \     'cmd': ['html-languageserver', '--stdio'],
        \     'allowlist': ['html'],
        \   },
        \   {
        \     'name': 'bash-language-server',
        \     'cmd': ['bash-language-server', 'start'],
        \     'allowlist': ['sh', 'bash', 'zsh'],
        \   },
        \   {
        \     'name': 'lua-language-server',
        \     'cmd': ['lua-language-server'],
        \     'allowlist': ['lua'],
        \   },
        \   {
        \     'name': 'yaml-language-server',
        \     'cmd': ['yaml-language-server', '--stdio'],
        \     'allowlist': ['yaml', 'yaml.docker-compose', 'yaml.gitlab'],
        \   },
        \   {
        \     'name': 'clangd',
        \     'cmd': ['clangd', '--fallback-style=google'],
        \     'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cuda'],
        \   },
        \   {
        \     'name': 'deno',
        \     'cmd': ['deno', 'lsp'],
        \     'workspace_config': {
        \       'deno': {
        \         'enable': v:true,
        \         'lint': v:true,
        \         'unstable': v:true,
        \         'compilerOptions': {
        \           'lib': ['deno.ns', 'dom', 'esnext'],
        \         },
        \       },
        \     },
        \     'allowlist': [
        \       'javascript', 'typescript',
        \       'javascriptreact', 'typescriptreact',
        \     ],
        \   },
        \   {'name': 'rust-analyzer', 'cmd': ['rust-analyzer'], 'allowlist': ['rust']},
        \   {'name': 'glasgow', 'cmd': ['glasgow'], 'allowlist': ['wgsl']},
        \   {'name': 'taplo', 'cmd': ['taplo', 'lsp', 'stdio'], 'allowlist': ['toml']},
        \   {'name': 'marksman', 'cmd': ['marksman', 'server'], 'allowlist': ['markdown']},
        \   {
        \     'name': 'markdownlint-lsp',
        \     'cmd': ['markdownlint-lsp-server', '--stdio'],
        \     'allowlist': ['markdown', 'markdown.mdx'],
        \   },
        \   {'name': 'efm-langserver', 'cmd': ['efm-langserver'], 'allowlist': ['yaml']},
        \ ]
  for l:server in l:servers
    if executable(l:server.cmd[0])
      call lsp#register_server(l:server)
    endif
  endfor
endfunction

augroup lsp_servers
  autocmd!
  autocmd User lsp_setup call s:register_servers()
augroup END

command LspDisableDiagnostics call lsp#disable_diagnostics_for_buffer()
command LspEnableDiagnostics call lsp#enable_diagnostics_for_buffer()
