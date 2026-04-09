{ pkgs, inputs, ... }:
{
  stylix = {
    enable = true;
    image = ../../home/dotfiles/hypr/wallpapers/wallpaper2.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.SF-Pro;
        name = "SF Pro Display";
      };
      monospace = {
        package = pkgs.nerd-fonts.departure-mono;
        name = "DepartureMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        terminal = 12;
        applications = 11;
        desktop = 11;
        popups = 11;
      };
    };

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

  };

  home-manager.sharedModules = [
    {

      # dotfiles/rofi
      stylix.targets.rofi.enable = false;

      # Tokyo Night palette in dotfiles/hypr/mako/config.
      stylix.targets.mako.enable = false;

      # style.css by wal/GTK variables.
      #stylix.targets.waybar.enable = false;

      # set borders/colors in hyprland.nix.
      stylix.targets.hyprland.enable = false;

      # Stylix doesn't support
      stylix.targets.qt.enable = false;
      # ugly withotu
      stylix.targets.neovim.enable = false;
    }
  ];
}
