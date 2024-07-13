# https://github.com/tmux-plugins/tmux-sensible

# Address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0
set -g history-limit 50000
set -g display-time 4000
set -g status-interval 5

set -g default-terminal "screen-256color"
set -g status-keys emacs
set -g focus-events on
setw -g aggressive-resize on

bind-key C-p previous-window
bind-key C-n next-window

bind-key R source-file "${XDG_CONFIG_HOME}"/tmux/tmux.conf \; \
  display-message "Sourced ${XDG_CONFIG_HOME}/tmux/tmux.conf"
