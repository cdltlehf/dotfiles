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
set-option -g message-style bg=default,fg=default,fill=terminal
set-option -g message-command-style bg=default,fg=default,fill=terminal
set-option -g status-style bg=default,fg=default
set-option -g status on
set-option -g status-interval 5
set-option -g status-justify absolute-centre
set-option -gu status-format

# Set status-left, window-status, status-right based on LC_TERMINAL_GLYPHS.
# The ascii tier uses the window flags of tmux. The other tiers show one icon:
# for the current window, synchronized > zoomed > marked;
# for other windows, bell > activity > silence > last.
%if "#{==:$LC_TERMINAL_GLYPHS,ascii}"
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default]#{session_name}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]. #[fg=default]prefix#[default],}"

# Use the window flags of tmux (*, -, #, !, ~, M, and Z), and S for synchronized panes.
set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W#{?window_flags,#{window_flags},}#{?pane_synchronized,#[fg=brightred]S#[default],}"
set-option -g window-status-format "#I:#W#{?window_flags,#{window_flags},}#{?pane_synchronized,#[fg=brightred]S#[default],}"
set-option -gu window-status-separator

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d . %H:%M"
%elif "#{==:$LC_TERMINAL_GLYPHS,unicode}"
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default]#{session_name}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]· #[fg=default]prefix#[default],}"

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W*#{?pane_synchronized, #[fg=brightred]S#[default],#{?window_zoomed_flag, Z,#{?window_marked_flag, M,}}}"
set-option -g window-status-format "#I:#W#{?window_bell_flag, #[fg=yellow]‼#[default],#{?window_activity_flag, ∙,#{?window_silence_flag, ○,#{?window_last_flag, ←,}}}}"
set-option -g window-status-separator " #[fg=brightblack]· "

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d · %H:%M"
%else
set-option -g  status-left-length 50
set-option -g  status-left "#[fg=default] #{session_name}"
set-option -ag status-left "#{?client_prefix, #[fg=brightblack]· #[fg=default]prefix#[default],}"

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-current-format "#I:#W*#{?pane_synchronized, #[fg=brightred]#[default],#{?window_zoomed_flag, ,#{?window_marked_flag, ,}}}"
set-option -g window-status-format "#I:#W#{?window_bell_flag, #[fg=yellow]#[default],#{?window_activity_flag, ,#{?window_silence_flag, ,#{?window_last_flag, ,}}}}"
set-option -g window-status-separator " #[fg=brightblack]· "

set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

set-option -g  status-right-length 30
set-option -g  status-right "#[fg=brightblack]%a %b %d · %H:%M"
%endif
