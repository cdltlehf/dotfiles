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
  nnoremap <buffer> <localleader>fm <plug>(lsp-document-format)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_diagnostics_signs_error = {'text': 'X'}
let g:lsp_diagnostics_signs_warning = {'text': '!'}

function! s:on_colorscheme() abort
  if exists('g:colors_name') && g:colors_name ==# 'dracula'
    highlight link LspErrorHighlight DraculaRed
    highlight link LspWarningHighlight DraculaOrange

    highlight link LspErrorText DraculaRed
    highlight link LspWarningText DraculaOrange
  endif
endfunction

augroup DraculaColor
  autocmd!
  autocmd ColorScheme * call s:on_colorscheme()
augroup END
