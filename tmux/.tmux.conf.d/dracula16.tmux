# Set border style
set-option -g pane-active-border-style "fg=blue"
set-option -g pane-border-style "fg=black"

# Set message, status style
set-option -g message-style "bg=black,fg=terminal"
set-option -g status-style "bg=black,fg=terminal"
set-option -g status-interval 6

# Set status-left
set-option -g status-left-length 100
set-option -g status-left \
  "#[bg=#{?client_prefix,yellow,green},fg=black]"
set-option -ag status-left " #{session_name} "

# Set window-status
set-option -g window-status-current-format \
  "#[bg=terminal,fg=terminal] #I #W#F "
set-option -g window-status-format \
  "#[bg=black,fg=terminal] #I #W#F "
set-option -g window-status-separator ''

set-option -g window-status-activity-style "bold"
set-option -g window-status-bell-style "bold"

# Set status-right
set-option -g status-right-length 100
set-option -g status-right "#[bg=cyan,fg=black] #{pane_title} "
set-option -ag status-right "#[bg=yellow,fg=black] %H:%M %Y-%m-%d "
