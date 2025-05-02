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
        #  normal = {
        #    family = "DepartureMono Nerd Font Mono";
        #    style = "Regular";
        #  };
        #family_fallback = ["Iosevka Nerd Font"];
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#1E1E2E";
          foreground = "#d3d3d3";
        };
      };
    };
  };
}
