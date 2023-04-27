# Vim-like visual mode
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi V send-keys -X select-line
bind-key -T copy-mode-vi C-v \
  send-keys -X begin-selection \; send-keys -X rectangle-toggle
bind-key -T copy-mode-vi Escape send-keys -X cancel
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key P paste-buffer
# bind-key C-r choose-buffer

# Set vi keys
set-option -g status-keys vi
set-option -g mode-keys vi
