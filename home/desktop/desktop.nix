{
  config,
  lib,
  pkgs,
  inputs,
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
    inputs.noctalia.homeModules.default
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
    ".config/btop" = {
      source = ../dotfiles/btop;
      recursive = true;
    };
    ".config/alacritty/alacritty.toml".source = ../dotfiles/hypr/alacritty/alacritty.toml;
    ".config/alacritty/fonts.toml".source = ../dotfiles/hypr/alacritty/fonts.toml;
    ".config/neutronsync/neutronsync.toml".source = ../dotfiles/neutronsync.toml;
  };

  services = {
    kdeconnect.enable = true;
    gnome-keyring.enable = true;
  };
  dconf.enable = true;
  home.packages = with pkgs; [
    # --- hyprland / wayland ---
    grim
    hyprpicker
    playerctl
    slurp
    wl-clipboard
    xdg-utils

    # Noctalia application-theme integration
    adw-gtk3
    qt6Packages.qt6ct

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
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.SF-Pro
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.SF-Pro-mono
    noto-fonts
    noto-fonts-color-emoji
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
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    checkConfig = true;
    settings = import ./noctalia-settings.nix { inherit config; };
  };

  # Noctalia persists the selected wallpaper in its mutable settings. Older
  # configurations exposed the repository's Nix store path here, so garbage
  # collection could leave the persisted default/last/monitor paths dangling.
  # Migrate those saved paths to the stable Home Manager link.
  home.activation.migrateNoctaliaWallpaperPaths = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_file="${config.xdg.stateHome}/noctalia/settings.toml"

    if [[ -f "$settings_file" ]]; then
      ${pkgs.gnused}/bin/sed -i -E \
        's#path = "/nix/store/[^\"]*/wallpapers/([^\"]+)"#path = "${config.xdg.configHome}/hypr/wallpapers/\1"#g' \
        "$settings_file"
    fi
  '';

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
  gtk.gtk2.force = true;

  qt.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

}
