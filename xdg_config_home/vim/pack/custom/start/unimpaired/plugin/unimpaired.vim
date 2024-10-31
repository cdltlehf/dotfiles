"" See tpope/vim-unimpaired

if exists('g:loaded_unimpaired') || &compatible
  finish
endif
let g:loaded_unimpaired = 1

" argument list
nnoremap [a :previous<cr>
nnoremap ]a :next<cr>
nnoremap [A :first<cr>
nnoremap ]A :last<cr>

" buffer list
nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>
nnoremap [B :bfirst<cr>
nnoremap ]B :blast<cr>

" location list
nnoremap [l :lprev<cr>:ll<cr>
nnoremap ]l :lnext<cr>:ll<cr>

" quickfix list
nnoremap [q :cprev<cr>:cc<cr>
nnoremap ]q :cnext<cr>:cc<cr>

" tab page list
nnoremap [t :tprev<cr>
nnoremap ]t :tnext<cr>

" add newline
nnoremap [<space> O<ESC>j<C-E>
nnoremap ]<space> o<ESC>k

" move line
nnoremap [e ddkP
nnoremap ]e ddp

" options
nnoremap [ob :set<space>background=dark<cr>
nnoremap ]ob :set<space>background=light<cr>

nnoremap [oc :set<space>cursorline<cr>
nnoremap ]oc :set<space>nocursorline<cr>

nnoremap [oh :set<space>hlsearch<cr>
nnoremap ]oh :set<space>nohlsearch<cr>

nnoremap [oi :set<space>ignorecase<cr>
nnoremap ]oi :set<space>noignorecase<cr>

" nnoremap [ol :setlocal<space>list<cr>
" nnoremap ]ol :setlocal<space>nolist<cr>

nnoremap [on :setlocal<space>number<cr>
nnoremap ]on :setlocal<space>nonumber<cr>

nnoremap [or :setlocal<space>relativenumber<cr>
nnoremap ]or :setlocal<space>norelativenumber<cr>

nnoremap [os :setlocal<space>spell<cr>
nnoremap ]os :setlocal<space>nospell<cr>

nnoremap [ou :set<space>cursorcolumn<cr>
nnoremap ]ou :set<space>nocursorcolumn<cr>

nnoremap [ow :setlocal<space>wrap<cr>
nnoremap ]ow :setlocal<space>nowrap<cr>

nnoremap [ox :set<space>cursorline <bar> set<space>cursorcolumn<cr>
nnoremap ]ox :set<space>nocursorline <bar> set<space>nocursorcolumn<cr>

" vim: set ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0:
