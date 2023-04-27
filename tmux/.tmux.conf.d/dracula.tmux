# https://spec.draculatheme.com/
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

# Set border style
set-option -g pane-active-border-style "fg=${purple}"
set-option -g pane-border-style "fg=${selection}"

# Set message, status style
set-option -g message-style "bg=${selection},fg=${foreground}"
set-option -g status-style "bg=${selection},fg=${foreground}"
set-option -g status-interval 6

# Set status-left
set-option -g status-left-length 100
set-option -g status-left \
  "#[bg=#{?client_prefix,${yellow},${green}},fg=${background}]"
set-option -ag status-left " #{session_name} "

# Set window-status
set-option -g window-status-current-format \
  "#[bg=${background},fg=${foreground}] #I #W#F "
set-option -g window-status-format \
  "#[bg=${selection},fg=${foreground}] #I #W#F "
set-option -g window-status-separator ''

set-option -g window-status-activity-style "bold"
set-option -g window-status-bell-style "bold"

# Set status-right
set-option -g status-right-length 100
set-option -g status-right "#[bg=${cyan},fg=${background}] #{pane_title} "
set-option -ag status-right "#[bg=${orange},fg=${background}] %H:%M %Y-%m-%d "
