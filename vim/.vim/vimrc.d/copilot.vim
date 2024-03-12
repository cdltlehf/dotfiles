" https://github.com/github/copilot.vim

imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
imap <silent><script><expr> <C-l> copilot#Accept("\<C-y>")
let g:copilot_no_tab_map = v:true
