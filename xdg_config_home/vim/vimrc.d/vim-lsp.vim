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
" let g:lsp_diagnostics_signs_error = {'text': 'X'}
" let g:lsp_diagnostics_signs_warning = {'text': '!'}
let g:lsp_diagnostics_signs_error = {'text': "\uEA87"}
let g:lsp_diagnostics_signs_warning = {'text': "\uF071"}

let g:lsp_diagnostics_virtual_text_prefix = "    \u258C"
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

let g:lsp_diagnostics_signs_priority_map = {
        \'LspError': 11,
        \'LspWarning': 7,
        \'clangd_LspWarning': 11,
        \'clangd_LspInformation': 11
        \}

" :help vim-lsp-semantic
if has('textprop') || has('nvim')
  let g:lsp_semantic_enabled = 1
endif
