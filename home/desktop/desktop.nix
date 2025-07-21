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

  /*
    custom-bambu-studio = pkgs.bambu-studio.overrideAttrs (oldAttrs: {
      version = "01.00.01.50";
      src = pkgs.fetchFromGitHub {
        owner = "bambulab";
        repo = "BambuStudio";
        rev = "v01.00.01.50";
        hash = "sha256-7mkrPl2CQSfc1lRjl1ilwxdYcK5iRU//QGKmdCicK30=";
      };
    });
  */
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
    wlogout
    bluetui
    #mokutil
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
    xdg-utils
    tailwindcss-language-server
    vscode-langservers-extracted
    jdk17
    signal-desktop
    maven
    platformio
    orca-slicer
    gtk3
    gtk4
    webkitgtk_6_0
    libreoffice
    syncthingtray
    iwd
    polkit
    python312Packages.dbus-python
    mcomix
    dbeaver-bin
    discord
    arduino
    avrdude
    ccls
    vscode
    vulkan-tools
    qmk
    grim
    kicad
    libnotify
    kdePackages.dolphin
    brightnessctl
    greetd.tuigreet
    obsidian
    gocr
    pavucontrol
    cliphist
    wl-clipboard
    udiskie # auto-mount drives
    waybar # bar
    hyprshot # screenshots
    mako
    foot
    swww
    mpv
    #mpc-cli
    imagemagick # convert XXX
    feh
    playerctl
    google-chrome
    nixos-shell # vm's
    nixos-generators
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

  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";
  };
}
