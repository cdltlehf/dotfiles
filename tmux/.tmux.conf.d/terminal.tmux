# Set terminal. See the following post {{{1
# https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
set-option -g default-terminal 'xterm-256color'
set-option -as terminal-overrides ',*256col*:Tc'
set-option -as terminal-overrides '*italic:sitm=\E[3m:ritm=\E[23m'
