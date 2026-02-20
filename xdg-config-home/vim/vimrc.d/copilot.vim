" https://github.com/github/copilot.vim
" :help copilot.txt

inoremap <silent><script><expr> <c-j> copilot#Accept()
inoremap <c-l> <plug>(copilot-accept-word)

let g:copilot_no_tab_map = v:true
