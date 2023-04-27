background='#282a36'
foreground='#f8f8f2'
selection='#44475a'
comment='#6272a4'

red='#ff5555'
orange='#ffb86c'
yellow='#f1fa8c'
green='#50fa7b'
purple='#bd93f9'
cyan='#8be9fd'
pink='#ff79c6'

# C-a to disable outmost tmux, C-b C-a to enable it.
bind-key D \
  set-option key-table disabled\; \
  set-option prefix None\; \
  \
  set-option status-left \
  "#[bg=#{?#{==:#{client_key_table},disabled},${comment},${purple}}]" \; \
  set-option -a status-left "#[fg=${background}]"\; \
  set-option -a status-left " #{session_name}[D] "\; \
  \
  set-option status-right \
  "#[bg=${comment},fg=${background}] #{pane_title} "\; \
  \
  set-option window-status-current-format \
  "#[bg=${background},fg=${comment}] #I #W#F "\; \
  \
  display-message "Tmux is now disabled. Press C-b E to enable" \;

bind-key -T disabled C-b \
  set-option key-table enable_pending

bind-key -T enable_pending Escape \
  set-option key-table disabled

bind-key -T enable_pending C-b \
  send-keys C-b\; \
  set-option key-table disabled\;

bind-key -T enable_pending E \
  set-option -u key-table\; \
  set-option -u prefix\; \
  set-option -u status-left\; \
  set-option -u status-right\; \
  set-option -u window-status-current-format\; \
  set-option -u status-interval\;
