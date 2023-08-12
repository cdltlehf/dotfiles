" https://github.com/prabirshrestha/vim-lsp

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
  nmap <buffer> <localleader>rn <plug>(lsp-rename)<C-u>
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  " nnoremap <buffer> \g <plug>(lsp-document-diagnostics)
  nnoremap <buffer> <localleader>ca <plug>(lsp-code-action)
  " nnoremap <buffer> <localleader>cl <plug>(lsp-code-lens)
  nnoremap <buffer> <localleader>fm <plug>(lsp-document-format)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1

" :help g:lsp_diagnostics_signs_enabled
" let g:lsp_diagnostics_signs_error = {'text': 'X'}
" let g:lsp_diagnostics_signs_warning = {'text': '!'}
let g:lsp_diagnostics_signs_error = {'text': "\uea87"}
let g:lsp_diagnostics_signs_warning = {'text': "\uf071"}

let g:lsp_diagnostics_virtual_text_prefix = "-- "
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

let g:lsp_diagnostics_signs_priority_map = {
        \'LspError': 11,
        \'LspWarning': 7,
        \'clangd_LspWarning': 11,
        \'clangd_LspInformation': 11
        \}

" :help colorscheme-override
augroup vim_lsp_my_colorschemes
  autocmd!
  autocmd Colorscheme *
        \ highlight! link LspErrorHighlight Error
        \|highlight! link LspWarningHighlight Todo
        \|highlight LspInformationHighlight
        \   ctermfg=darkblue ctermbg=none cterm=none
        \|highlight LspHintHighlight
        \   ctermfg=darkgreen ctermbg=none cterm=none
        \
        \|highlight! link LspErrorText Error
        \|highlight! link LspWarningText Todo
        \|highlight! link LspInformationText LspInformationHighlight
        \|highlight! link LspHintText LspHintHighlight
        \
        \|highlight! link LspErrorVirtualText LspErrorText
        \|highlight! link LspWarningVirtualText LspWarningText
        \|highlight! link LspInformationVirtualText LspInformationText
        \|highlight! link LspHintVirtualText LspHintText
augroup END
