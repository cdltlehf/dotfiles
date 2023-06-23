# https://github.com/tmux-plugins/tmux-pain-control

# pane navigation
bind-key h select-pane -L
bind-key C-h select-pane -L
bind-key j select-pane -D
bind-key C-j select-pane -D
bind-key k select-pane -U
bind-key C-k select-pane -U
bind-key l select-pane -R
bind-key C-l select-pane -R

# window moving
bind-key -r "<" swap-window -d -t -1
bind-key -r ">" swap-window -d -t +1

# pane resizing
bind-key -r H resize-pane -L 5
bind-key -r J resize-pane -D 5
bind-key -r K resize-pane -U 5
bind-key -r L resize-pane -R 5

# Split window with a current path
bind-key "%" split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -v -c "#{pane_current_path}"
bind-key "c" new-window -c "#{pane_current_path}"

# Navigate window
bind-key -r C-p previous-window
bind-key -r C-n next-window
