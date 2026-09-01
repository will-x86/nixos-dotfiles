{
  config,
  inputs,
  pkgs,
  # system ? pkgs.system,
  secrets,
  ...
}:
let
  base = import ../base/base.nix { inherit config pkgs; };
  hyprland = import ./hyprland.nix { inherit config pkgs secrets; };
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

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

  # mako reads ~/.config/mako/config by default; deploy there.
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
    pulsemixer

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
    proton-drive-cli
    # --- cli utils ---
    bc
    gocr
    usbutils

    # --- apps ---
    orca-slicer
    qmk
    syncthingtray
    (writeShellScriptBin "kabam" ''
      FRP_SERVER_ADDR="${secrets.tunnelDomain}" 
      FRP_SERVER_PORT="7000"

      if [ -z "$1" ]; then
          echo "Usage: kabam <local_port>"
          echo "Example: kabam 8080"
          exit 1
      fi

      LOCAL_PORT=$1
      CONFIG_FILE="/tmp/frpc_config.toml"

      trap "rm -f $CONFIG_FILE" EXIT

      cat > "$CONFIG_FILE" << EOF
      serverAddr = "$FRP_SERVER_ADDR"
      serverPort = $FRP_SERVER_PORT

      [[proxies]]
      name = "web"
      type = "http"
      localPort = $LOCAL_PORT
      customDomains = ["${secrets.tunnelDomain}"]
      EOF

      echo "--- ✅ Tunneling to https://${secrets.tunnelDomain} ---"
      echo "Press Ctrl+C to stop."

      frpc -c "$CONFIG_FILE"

    '')
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
  # stylix doesn't support the 'kde' platform theme
  qt = {
    enable = true;
    #platformTheme.name = "gtk3";
  };

  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";

  };
  home.file = {
    ".config/scripts" = {
      source = ../dotfiles/scripts;
      recursive = true;
    };
  };

  # neutronsync config
  home.file.".config/neutronsync/neutronsync.toml".source = ../dotfiles/neutronsync.toml;

  # Use one not both
  # systemctl --user enable --now neutronsync-watch
  systemd.user.services.neutronsync-watch = {
    Unit = {
      Description = "Proton Drive live sync (neutronsync watch)";
      After = "network-online.target";
      Wants = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.neutronsync}/bin/neutronsync watch";
      Restart = "on-failure";
      RestartSec = 30;
      Nice = 10;
      IOSchedulingClass = "idle";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.neutronsync-sync = {
    Unit = {
      Description = "Proton Drive bidirectional sync (neutronsync)";
      After = "network-online.target";
      Wants = "network-online.target";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.neutronsync}/bin/neutronsync sync";
      Nice = 10;
      IOSchedulingClass = "idle";
    };
  };

}
