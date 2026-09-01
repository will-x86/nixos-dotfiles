{
  config,
  pkgs,
  # system ? pkgs.system,
  secrets,
  ...
}:
let
  base = import ../base/base.nix { inherit config pkgs; };
  hyprland = import ./hyprland.nix { inherit config pkgs secrets; };
in
{
  imports = [
    base
    hyprland
    ./gui-programming.nix
    ./zed.nix
    ./gui.nix
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland # For deskflow
    ];
    config.common.default = "*";
  };
  home.file = {
    ".config/hypr" = {
      source = ../dotfiles/hypr;
      recursive = true;
    };
  };

  # Hyprland mako uses ~/.config/hypr/mako/config but for timeout for other apps
  # we need ~/.config/mako/config too
  home.file.".config/mako/config".source = ../dotfiles/hypr/mako/config;
  home.file = {
    ".config/btop" = {
      source = ../dotfiles/btop;
      recursive = true;
    };
  };

  home.file = {
    ".config/rofi" = {
      source = ../dotfiles/rofi;
      recursive = true;
    };
  };

  home.file = {
    ".config/wlogout" = {
      source = ../dotfiles/wlogout;
      recursive = true;
    };
  };
  services = {
    kdeconnect.enable = true;
    gnome-keyring.enable = true;
  };
  dconf.enable = true;
  home.packages = with pkgs; [
    # --- hyprland / wayland ---
    brightnessctl
    grim
    hyprshot
    libnotify
    mako
    playerctl
    slurp
    hyprpaper
    waybar
    wl-clipboard
    wlogout
    xdg-utils

    # --- audio / media ---
    feh
    mpv
    pavucontrol

    # --- system / desktop ---
    coreutils
    gawk
    gtk3
    gtk4
    iwd
    polkit
    python312Packages.dbus-python
    udiskie # auto-mount drives
    vulkan-tools
    webkitgtk_6_0

    libsecret
    neutronsync
    proton-drive
    # --- cli utils ---
    bc
    gocr
    usbutils

    # --- apps ---
    orca-slicer
    qmk
    syncthingtray
    (pkgs.callPackage (
      { stdenv }:

      stdenv.mkDerivation {
        name = "nothing-fonts";
        src = ./fonts;
        installPhase = ''
          mkdir -p $out/share/fonts/{opentype,truetype}
          cp *.otf $out/share/fonts/opentype/
          cp *.ttf $out/share/fonts/truetype/
        '';
      }
    ) { })
  ];
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-emoji ];
  };
  qt = {
    enable = true;
  };

  home.file = {
    ".config/scripts" = {
      source = ../dotfiles/scripts;
      recursive = true;
    };
  };

  # neutronsync config
  home.file.".config/neutronsync/neutronsync.toml".source = ../dotfiles/neutronsync.toml;

}
