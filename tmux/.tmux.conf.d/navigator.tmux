# navigator
bind-key h select-pane -L
bind-key C-h select-pane -L
bind-key j select-pane -D
bind-key C-j select-pane -D
bind-key k select-pane -U
bind-key C-k select-pane -U
bind-key l select-pane -R
bind-key C-l select-pane -R

# Vim-like resize pane
bind-key -r - resize-pane -D 5
bind-key -r + resize-pane -U 5
bind-key -r < resize-pane -L 5
bind-key -r > resize-pane -R 5

# Split window with a current path
bind-key "%" split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -v -c "#{pane_current_path}"
# bind-key "c" new-window -c "#{pane_current_path}"

# Navigate window
bind-key C-p previous-window
bind-key C-n next-window
