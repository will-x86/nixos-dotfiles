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
    system = pkgs.system;
    config.allowUnfree = true;
  };

in
{
  imports = [
    base
    hyprland
  ];

  home.file = {
    ".config/hypr" = {
      source = ../dotfiles/hypr;
      recursive = true;
    };
  };
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
  };
  home.packages = with pkgs; [
    pulsemixer
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
    pywal
    blender
    arduino-ide
    thonny
    python312
    python312Packages.pip
    python312Packages.setuptools
    wlogout
    bluetui
    proton-pass
    obs-studio
    pywalfox-native
    slurp
    eslint
    mediawriter
    devenv
    bc
    gawk
    coreutils
    polkit
    jetbrains.idea-ultimate
    xdg-utils
    jdk17
    #lan-mouse
    signal-desktop
    maven
    orca-slicer
    gtk3
    gtk4
    webkitgtk_6_0
    libreoffice
    syncthingtray
    iwd
    polkit
    python312Packages.dbus-python
    dbeaver-bin
    discord
    ccls
    vscode
    vulkan-tools
    qmk
    zoom-us
    grim
    kicad
    libnotify
    kdePackages.dolphin
    brightnessctl
    obsidian
    gocr
    pavucontrol
    wl-clipboard
    udiskie # auto-mount drives
    waybar # bar
    hyprshot # screenshots
    mako
    spotify
    bottles
    swww
    mpv
    feh
    playerctl
    google-chrome
    nixos-shell # vm's
    nixos-generators
    anydesk
    stm32cubemx
    tidal-hifi
    freecad
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
  programs.lan-mouse = {
    enable = true;
    # systemd = false;
    # package = inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Configuration converted from TOML to Nix syntax
    settings = {
      release_bind = [
        "KeyA"
        "KeyS"
        "KeyD"
        "KeyF"
      ];
      port = 4242;

      authorized_fingerprints = {
        "${secrets.lan-mouse.windowsTLS}" = "desktopdaddy";
      };

      clients = [
        {
          position = "right";
          hostname = "DESKTOP-ACLK4KR";
          activate_on_startup = true;
          ips = [ "${secrets.lan-mouse.windows}" ];
          port = 4242;
        }
      ];
    };
  };

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-emoji ];
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";

  };
}
