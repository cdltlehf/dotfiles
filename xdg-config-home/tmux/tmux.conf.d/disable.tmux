# C-a to disable outmost tmux, C-b C-a to enable it.
bind-key D \
  set-option key-table disabled\; \
  set-option prefix None\; \
  \
  set-option status-left \
  "#[bg=#{?#{==:#{client_key_table},disabled},brightblack,blue}]" \; \
  set-option -a status-left "#[fg=black]"\; \
  set-option -a status-left " #{session_name}[D] "\; \
  \
  set-option status-right \
  "#[bg=brightblack,fg=black] #{pane_title} "\; \
  \
  set-option window-status-current-format \
  "#[bg=black,fg=brightblack] #I #W#F "\; \
  \
  display-message "Tmux is now disabled. Press C-b C-b to enable" \;

bind-key -T disabled C-b \
  set-option key-table enable_pending

bind-key -T enable_pending Escape \
  set-option key-table disabled

bind-key -T enable_pending C-b \
  send-keys C-b\; \
  set-option key-table disabled\;

bind-key -T enable_pending C-b \
  set-option -u key-table\; \
  set-option -u prefix\; \
  set-option -u status-left\; \
  set-option -u status-right\; \
  set-option -u window-status-current-format\; \
  set-option -u status-interval\;
