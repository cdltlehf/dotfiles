" tpope/vim-unimpaired

if exists('g:loaded_unimpaired') || &compatible
  finish
endif
let g:loaded_unimpaired = 1

" argument list
nnoremap [a :prev<CR>
nnoremap ]a :next<CR>

" buffer list
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>

" location list
" nnoremap [l :lprev<CR>
" nnoremap ]l :lnext<CR>

" quickfix list
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

" tab page list
nnoremap [t :tprev<CR>
nnoremap ]t :tnext<CR>

" add newline
nnoremap [<Space> O<ESC>j<C-E>
nnoremap ]<Space> o<ESC>k

" move line
nnoremap [e ddkP
nnoremap ]e ddp

" options
nnoremap [oh :set<Space>hlsearch<CR>
nnoremap ]oh :set<Space>nohlsearch<CR>
nnoremap [oi :set<Space>ignorecase<CR>
nnoremap ]oi :set<Space>noignorecase<CR>
" nnoremap [ol :setlocal<Space>list<CR>
" nnoremap ]ol :setlocal<Space>nolist<CR>
nnoremap [on :setlocal<Space>number<CR>
nnoremap ]on :setlocal<Space>nonumber<CR>
nnoremap [or :setlocal<Space>relativenumber<CR>
nnoremap ]or :setlocal<Space>norelativenumber<CR>
nnoremap [os :setlocal<Space>spell<CR>
nnoremap ]os :setlocal<Space>nospell<CR>
nnoremap [ow :setlocal<Space>wrap<CR>
nnoremap ]ow :setlocal<Space>nowrap<CR>
nnoremap [ob :set<Space>background=dark<CR>
nnoremap ]ob :set<Space>background=light<CR>

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
