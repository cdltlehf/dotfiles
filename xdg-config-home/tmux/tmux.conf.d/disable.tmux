# Reference:
# - https://github.com/tmux/tmux/wiki/Advanced-Use-Cases#nested-tmux-sessions

# C-a to disable outmost tmux, C-b C-a to enable it.
%if "#{==:$LC_TERMINAL_GLYPHS,ascii}"
bind-key D \
  set-option key-table disabled\; \
  set-option prefix None\; \
  \
  set-option status-style "bg=default,fg=brightblack,dim"\; \
  set-option status-left "#[fg=brightblack]#{session_id}:#{session_name} . disabled"\; \
  set-option status-right "#[fg=brightblack]Press C-b C-b to enable"\; \
  set-option window-status-current-style "bg=default,fg=brightblack,none"\; \
  set-option window-status-style "bg=default,fg=brightblack,dim"
%else
bind-key D \
  set-option key-table disabled\; \
  set-option prefix None\; \
  \
  set-option status-style "bg=default,fg=brightblack,dim"\; \
  set-option status-left "#[fg=brightblack]#{session_id}:#{session_name} · disabled"\; \
  set-option status-right "#[fg=brightblack]Press C-b C-b to enable"\; \
  set-option window-status-current-style "bg=default,fg=brightblack,none"\; \
  set-option window-status-style "bg=default,fg=brightblack,dim"
%endif

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
