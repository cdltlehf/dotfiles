let s:modes = {
      \ '!': 'shell',
      \ "\<C-S>": 'select:block',
      \ "\<C-V>": 'visual:block',
      \ 'R': 'replace',
      \ 'Rc': 'replace',
      \ 'Rv': 'replace:virtual',
      \ 'Rx': 'replace',
      \ 'S': 'select:line',
      \ 'V': 'visual:line',
      \ 'c': 'command',
      \ 'ce': 'ex',
      \ 'cv': 'ex',
      \ 'i': 'insert',
      \ 'ic': 'insert',
      \ 'ix': 'insert',
      \ 'n': '',
      \ 'r': 'prompt',
      \ 'r?': 'confirm',
      \ 'rm': 'more',
      \ 's': 'select',
      \ 't': 'terminal',
      \ 'v': 'visual'
      \ }

augroup statusline_highlight
  autocmd!
  autocmd ColorScheme,VimEnter *
        \ highlight StatusLine ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
        \|highlight StatusLineNC ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
        \|highlight StatusLineDim ctermfg=8 guifg=DarkGray
        \|highlight StatusLineText ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
        \|highlight StatusLineBold ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE gui=NONE cterm=NONE
        \|highlight StatusLineLspError ctermfg=9 guifg=Red
        \|highlight StatusLineLspWarn ctermfg=11 guifg=Yellow
augroup end

function! s:format_smart_path(raw_path) abort
  if empty(a:raw_path)
    return '[No Name]'
  endif

  let l:glyphs = getenv('LC_TERMINAL_GLYPHS')
  let l:ellipsis = (l:glyphs ==# 'ascii') ? '...' : '…'

  let l:git_root = exists('*FugitiveGitDir') ? FugitiveExtractGitDir(a:raw_path) : ''
  if !empty(l:git_root)
    let l:git_root = fnamemodify(l:git_root, ':h')
    let l:repo_name = fnamemodify(l:git_root, ':t')
    let l:abs_path = fnamemodify(a:raw_path, ':p')
    let l:subpath = strpart(l:abs_path, len(l:git_root) + 1)

    if empty(l:subpath)
      return l:repo_name
    endif

    let l:parts = split(l:subpath, '/')
    if len(l:parts) > 2
      return printf('%s/%s/%s/%s', l:repo_name, l:ellipsis, l:parts[-2], l:parts[-1])
    else
      return printf('%s/%s', l:repo_name, l:subpath)
    endif
  else
    let l:full_path = fnamemodify(a:raw_path, ':~:.')
    if l:full_path =~# '^~/'
      let l:home_subpath = strpart(l:full_path, 2)
      let l:parts = split(l:home_subpath, '/')
      if len(l:parts) > 2
        return printf('~/%s/%s/%s', l:ellipsis, l:parts[-2], l:parts[-1])
      else
        return l:full_path
      endif
    else
      let l:sys_subpath = (l:full_path =~# '^/') ? strpart(l:full_path, 1) : l:full_path
      let l:parts = split(l:sys_subpath, '/')
      if len(l:parts) > 2
        return printf('/%s/%s/%s', l:ellipsis, l:parts[-2], l:parts[-1])
      else
        return l:full_path
      endif
    endif
  endif
endfunction

function! s:format_buffer_name() abort
  let l:buftype = &buftype
  let l:raw_name = bufname('%')

  if l:buftype ==# 'help'
    return 'help: ' . expand('%:t')
  elseif l:buftype ==# 'quickfix'
    let l:is_loc = !empty(getloclist(0))
    return l:is_loc ? 'location-list' : 'quickfix'
  elseif l:buftype ==# 'terminal'
    return 'terminal'
  endif

  let l:match = matchlist(l:raw_name, '^\([a-zA-Z0-9_-]\+\)://\(.*\)$')
  if !empty(l:match)
    let l:scheme = l:match[1]
    let l:subpath = l:match[2]
    if empty(l:subpath)
      return l:scheme
    endif
    return printf('%s: %s', l:scheme, s:format_smart_path(l:subpath))
  endif

  return s:format_smart_path(l:raw_name)
endfunction

function! StatusLineRender() abort
  let l:glyphs = getenv('LC_TERMINAL_GLYPHS')
  let l:sep = (l:glyphs ==# 'ascii') ? '%#StatusLineDim# . ' : '%#StatusLineDim# · '

  let l:left_parts = []

  let l:target_string = '%#StatusLineBold#' . s:format_buffer_name()
  let l:branch = exists('*FugitiveHead') ? FugitiveHead() : ''
  if !empty(l:branch)
    let l:target_string .= l:sep . '%#StatusLineBold#' . l:branch
  endif

  if &readonly
    let l:target_string .= '%#StatusLineDim#:readonly'
  endif
  call add(l:left_parts, l:target_string)

  let l:mode_code = mode(1)
  let l:mode_str = get(s:modes, l:mode_code, '')
  if !empty(l:mode_str)
    call add(l:left_parts, '%#StatusLineDim#' . l:mode_str)
  endif

  let l:center_parts = []
  if &modified
    call add(l:center_parts, '%#StatusLineDim#modified')
  endif

  if l:mode_code !~# '^[iR]' && exists('*lsp#get_buffer_diagnostics_counts')
    let l:counts = lsp#get_buffer_diagnostics_counts()
    let l:err = get(l:counts, 'error', 0)
    let l:warn = get(l:counts, 'warning', 0)
    if l:err > 0
      let l:err_lbl = l:err == 1 ? '1 error' : l:err . ' errors'
      call add(l:center_parts, '%#StatusLineLspError#' . l:err_lbl)
    endif
    if l:warn > 0
      let l:warn_lbl = l:warn == 1 ? '1 warning' : l:warn . ' warnings'
      call add(l:center_parts, '%#StatusLineLspWarn#' . l:warn_lbl)
    endif
  endif

  let l:right_parts = []
  if !empty(&filetype)
    call add(l:right_parts, '%#StatusLineText#' . &filetype)
  endif

  let l:encoding = empty(&fileencoding) ? &encoding : &fileencoding
  let l:format = &fileformat
  if (l:encoding !=# 'utf-8' && !empty(l:encoding)) || l:format !=# 'unix'
    call add(l:right_parts, '%#StatusLineLspWarn#' . l:encoding . ':' . l:format)
  endif

  call add(l:right_parts, '%#StatusLineText#%l:%c')
  call add(l:right_parts, '%#StatusLineText#%p%%')

  let l:left_out = join(l:left_parts, l:sep)
  let l:center_out = join(l:center_parts, l:sep)
  let l:right_out = join(l:right_parts, l:sep)

  if empty(l:center_out)
    return l:left_out . '%=' . l:right_out
  endif

  return l:left_out . '%=' . l:center_out . '%=' . l:right_out
endfunction

set statusline=%!StatusLineRender()
