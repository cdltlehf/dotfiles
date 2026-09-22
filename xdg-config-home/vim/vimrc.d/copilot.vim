" Reference: https://github.com/github/copilot.vim
" :help copilot.txt

imap <silent><script><expr> <c-j> copilot#Accept("")
imap <c-l> <plug>(copilot-accept-word)

let g:copilot_no_tab_map = v:true
