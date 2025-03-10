{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        title = "Alacritty - Managed by Home Manager";
      };
      font = {
        normal = {
          family = "Monaspace Neon";
          style = "monospace";
        };
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };
      };
    };
  };
}
