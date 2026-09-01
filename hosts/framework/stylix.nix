{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  SF-Pro = inputs.self.packages.${system}.SF-Pro;
  SF-Pro-mono = inputs.self.packages.${system}.SF-Pro-mono;
in
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
        package = SF-Pro;
        name = "SF Pro Display";
      };
      # kitty.conf: font_family Liga SFMono Nerd Font
      monospace = {
        package = SF-Pro-mono;
        name = "Liga SFMono Nerd Font";
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
      stylix.targets.nixvim.enable = false;
      # managed in home/desktop/zed.nix
      stylix.targets.zed.enable = false;

      # Stops conflict of .gtkrc 2.0 or whatever
      stylix.targets.gtk.enable = false;
    }
  ];
}
