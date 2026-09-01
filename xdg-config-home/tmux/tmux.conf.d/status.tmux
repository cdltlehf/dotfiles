# Set border style
set-option -g pane-border-indicators off
set-option -g pane-active-border-style fg=default
set-option -g pane-border-style fg=brightblack
set-option -g pane-border-status bottom
set-option -g pane-border-format ""

# Set window pane style
set-option -g window-style default
set-option -g window-active-style default

# Set message, status style
set-option -g message-style bg=default,fg=default
set-option -g message-command-style bg=default,fg=default
set-option -g status-style bg=default,fg=default
set-option -g status on
set-option -g status-interval 5
set-option -g status-justify absolute-centre
set-option -gu status-format

# Set status-left, window-status, status-right based on LC_TERMINAL_GLYPHS
%if "#{==:$LC_TERMINAL_GLYPHS,ascii}"
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default]#{session_id}:#{session_name}"
set-option -ag status-left "#{?window_zoomed_flag, #[fg=brightblack]. #[fg=default]zoom#[default],}"
set-option -ag status-left "#{?pane_in_mode, #[fg=brightblack]. #[fg=default]copy#[default],}"
set-option -ag status-left "#{?pane_synchronized, #[fg=brightblack]. #[fg=brightred]synchronizing#[default],}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]. #[fg=default]prefix#[default],}"

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W*"
set-option -g window-status-format "#{?window_bell_flag,#[fg=yellow]! #[default],#{?window_activity_flag,#[fg=brightblack]## #[default],}}#I:#W"
set-option -g window-status-separator " #[fg=brightblack]. "

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d . %H:%M"
%elif "#{==:$LC_TERMINAL_GLYPHS,unicode}"
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default]#{session_id}:#{session_name}"
set-option -ag status-left "#{?window_zoomed_flag, #[fg=brightblack]· #[fg=default]zoom#[default],}"
set-option -ag status-left "#{?pane_in_mode, #[fg=brightblack]· #[fg=default]copy#[default],}"
set-option -ag status-left "#{?pane_synchronized, #[fg=brightblack]· #[fg=brightred]synchronizing#[default],}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]· #[fg=default]prefix#[default],}"

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W*"
set-option -g window-status-format "#{?window_bell_flag,#[fg=yellow]⚠ #[default],#{?window_activity_flag,#[fg=brightblack]✦ #[default],}}#I:#W"
set-option -g window-status-separator " #[fg=brightblack]· "

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d · %H:%M"
%else
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default]#{session_id}:#{session_name}"
set-option -ag status-left "#{?window_zoomed_flag, #[fg=brightblack]· #[fg=default]zoom#[default],}"
set-option -ag status-left "#{?pane_in_mode, #[fg=brightblack]· #[fg=default]copy#[default],}"
set-option -ag status-left "#{?pane_synchronized, #[fg=brightblack]· #[fg=brightred]synchronizing#[default],}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]· #[fg=default]prefix#[default],}"

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W*"
set-option -g window-status-format "#{?window_bell_flag,#[fg=yellow] #[default],#{?window_activity_flag,#[fg=brightblack] #[default],}}#I:#W"
set-option -g window-status-separator " #[fg=brightblack]· "

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d · %H:%M"
%endif
