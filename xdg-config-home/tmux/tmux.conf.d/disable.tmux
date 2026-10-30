# Reference: https://github.com/tmux/tmux/wiki/Advanced-Use-Cases

bind-key D \
  set-option key-table disabled\; \
  set-option prefix None\; \
  \
  set-option status-style "bg=default,fg=brightblack,none"\; \
  set-option status-left "#[fg=brightblack]#{E:@disabled_session_label} #{@separator} disabled#{?#{==:#{client_key_table},enable_pending}, #{@separator} #[fg=default]prefix#[fg=brightblack],}"\; \
  set-option status-right "#[fg=brightblack]Press C-b C-b to enable"\; \
  set-option window-status-current-style "bg=default,fg=brightblack,none"\; \
  set-option window-status-style "bg=default,fg=brightblack,none"

bind-key -T disabled C-b \
  set-option key-table enable_pending

bind-key -T enable_pending Escape \
  set-option key-table disabled

bind-key -T enable_pending C-b \
  set-option -u key-table\; \
  set-option -u prefix\; \
  set-option -u status-style\; \
  set-option -u status-left\; \
  set-option -u status-right\; \
  set-option -u window-status-current-style\; \
  set-option -u window-status-style\;
