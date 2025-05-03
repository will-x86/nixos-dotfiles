{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      # True color
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Unbind <C-b> as the prefix key
      unbind C-b

      # Bind <C-a> as the prefix key
      unbind C-a
      set -g prefix C-a
      bind a send-prefix

      # Enable mouse support
      set -g mouse on

      # Bind kim keys to resizing panes
      bind -r - resize-pane -D 2
      bind -r = resize-pane -U 2
      bind -r 0 resize-pane -R 2
      bind -r 9 resize-pane -L 2

      # Bind { and } to move windows
      bind -r [ previous-window
      bind -r ] next-window

      # Unbind + Rebind window splits
      unbind %
      unbind '"'
      bind \\ split-window -h -c "#{pane_current_path}"
      bind Enter split-window -v -c "#{pane_current_path}"

      bind x kill-pane

      # Bind m to maximize the current pane
       unbind M
       bind -r m resize-pane -Z

      unbind k
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded 🚀"

      # Enable vim keys for copy mode
      set-window-option -g mode-keys vi

      bind V copy-mode
      bind -T copy-mode-vi V send-keys -X cancel

      unbind -T copy-mode-vi v
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "#{pkgs.xclip}/bin/xclip -in -selection clipboard"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "#{pkgs.xclip}/bin/xclip -in -selection clipboard"

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      set -g default-terminal "tmux-256color"

      # Smart pane switching with awareness of Vim splits.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

      bind -n 'C-\' if-shell "$is_vim" 'send-keys C-\\' 'select-pane -l'
      #bind -n 'C-Space' if-shell "$is_vim" 'send-keys C-Space' 'select-pane -t:.+'
      # Enable switching panes while in copy-mode-vi
      bind -T copy-mode-vi 'C-h' select-pane -L
      bind -T copy-mode-vi 'C-j' select-pane -D
      bind -T copy-mode-vi 'C-k' select-pane -U
      bind -T copy-mode-vi 'C-l' select-pane -R
      bind -T copy-mode-vi 'C-\' select-pane -l
      #bind -T copy-mode-vi 'C-Space' select-pane -t:.+
      bind-key -r f run-shell "tmux neww ~/tmux-sessioniser"

    '';
    plugins = with pkgs.tmuxPlugins; [
      nord
      sensible
      yank
    ];
  };
}
