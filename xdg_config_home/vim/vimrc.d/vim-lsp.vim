" https://github.com/prabirshrestha/vim-lsp

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gI <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)<C-u>
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  " nnoremap <buffer> <leader>g <plug>(lsp-document-diagnostics)
  nnoremap <buffer> <leader>ca <plug>(lsp-code-action)
  " nnoremap <buffer> <leader>cl <plug>(lsp-code-lens)
  nnoremap <buffer> <leader>fm <plug>(lsp-document-format)
  " NOTE: https://clang.llvm.org/docs/ClangFormat.html#vim-integration
  nnoremap <buffer> <c-k> <plug>(lsp-document-format)
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

" :help vim-lsp-folding
set foldmethod=expr
set foldexpr=lsp#ui#vim#folding#foldexpr()
set foldtext=lsp#ui#vim#folding#foldtext()

" :help vim-lsp-semantic
if has('textprop') || has('nvim')
  let g:lsp_semantic_enabled = 1
endif
