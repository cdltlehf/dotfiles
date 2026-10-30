set-option -g pane-border-indicators off
set-option -g pane-active-border-style fg=default
set-option -g pane-border-style fg=brightblack
set-option -g pane-border-status bottom
set-option -g pane-border-format ""

set-option -g window-style default
set-option -g window-active-style default

set-option -g message-style bg=default,fg=default,fill=terminal
set-option -g message-command-style bg=default,fg=default,fill=terminal
set-option -g status-style bg=default,fg=default
set-option -g status on
set-option -g status-interval 5
set-option -g status-justify absolute-centre
set-option -gu status-format

set-option -g window-status-current-style "bg=default,fg=default,none"
set-option -g window-status-style "bg=default,fg=brightblack,none"
set-option -g window-status-activity-style "fg=brightblack,none"
set-option -g window-status-bell-style "fg=yellow,none"

%if "#{==:$LC_TERMINAL_GLYPHS,ascii}"
set-option -g @separator "."
set-option -g @session_label "[#{session_name}]"
set-option -g @disabled_session_label "[#{session_name}]"

set-option -g window-status-current-format "#I:#W#{?window_flags,#{window_flags},}#{?pane_synchronized,#[fg=brightred]S#[default],}"
set-option -g window-status-format "#I:#W#{?window_flags,#{window_flags},}#{?pane_synchronized,#[fg=brightred]S#[default],}"
set-option -gu window-status-separator

%elif "#{==:$LC_TERMINAL_GLYPHS,unicode}"
set-option -g @separator "·"
set-option -g @session_label "[#{session_name}]"
set-option -g @disabled_session_label "[#{session_name}]"

set-option -g window-status-current-format "#I:#W*#{?pane_synchronized, #[fg=brightred]S#[default],#{?window_zoomed_flag, Z,#{?window_marked_flag, M,}}}"
set-option -g window-status-format "#I:#W#{?window_bell_flag, #[fg=yellow]‼#[default],#{?window_activity_flag, ∙,#{?window_silence_flag, ○,#{?window_last_flag, ←,}}}}"
set-option -g window-status-separator " #[fg=brightblack]· "

%else
set-option -g @separator "·"
set-option -g @session_label " #{session_name}"
set-option -g @disabled_session_label " #{session_name}"

set-option -g window-status-current-format "#I:#W*#{?pane_synchronized, #[fg=brightred]#[default],#{?window_zoomed_flag, ,#{?window_marked_flag, ,}}}"
set-option -g window-status-format "#I:#W#{?window_bell_flag, #[fg=yellow]#[default],#{?window_activity_flag, ,#{?window_silence_flag, ,#{?window_last_flag, ,}}}}"
set-option -g window-status-separator " #[fg=brightblack]· "

%endif

set-option -g status-left-length 50
set-option -g status-left "#[fg=default]#{E:@session_label}#{?client_prefix, #[fg=brightblack]#{@separator} #[fg=default]prefix#[default],}"
set-option -g status-right-length 30
set-option -g status-right "#[fg=brightblack]%a %b %d #{@separator} %H:%M"
