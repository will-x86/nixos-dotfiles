{
  config,
  inputs,
  pkgs,
  system ? pkgs.system,
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
    ".config/lf" = {
      source = ../dotfiles/lf;
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
    #google-cloud-sdk
    #custom-bambu-studio
    #bambu-studio
    #ventoy-full
    lf
    pywal
    wlogout
    bluetui
    #pkgs-stable.google-chrome
    #wineWowPackages.waylandFull
    jellyfin-media-player
    pkgs-stable.beekeeper-studio
    # winetricks
    mokutil
    finamp
    #lsb-release
    jellyfin-web
    obs-studio
    # trezor-suite
    # trezor-agent
    pywalfox-native
    slurp # color picker
    eslint
    mediawriter
    #gettext
    #cabextract
    ctpv
    samba4Full
    devenv
    glxinfo
    #spacenavd
    bc
    gawk
    coreutils
    polkit
    bruno
    xdg-utils
    tailwindcss-language-server
    vscode-langservers-extracted
    quickemu
    mysql84
    zoom-us
    jdk17
    signal-desktop
    maven
    prusa-slicer
    platformio
    orca-slicer
    gtk3
    gtk4
    webkitgtk_6_0
    #inputs.zen-browser.packages.${system}.default
    syncthingtray
    iwd
    polkit
    python312Packages.dbus-python
    mcomix
    #swaylock
    dbeaver-bin
    discord
    postman
    arduino
    #llvmPackages_latest.lldb
    #lldb
    avrdude
    ccls
    vscode
    vulkan-tools
    qmk
    grim
    kicad
    jdt-language-server
    libnotify
    kdePackages.dolphin
    #davinci-resolve
    brightnessctl
    greetd.tuigreet
    obsidian
    gocr
    #nfs-utils
    python311Packages.pip
    upx
    pavucontrol
    cliphist
    wl-clipboard
    udiskie
    #ryujinx
    anydesk
    qutebrowser
    waybar
    #viewnior
    hyprshot
    mako
    foot
    swww
    mpv
    mpc-cli
    mpd
    #slurp
    imagemagick
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
  programs.qutebrowser = {
    enable = true;
    settings = {
      content.greasemonkey = [
        {
          name = "1password";
          namespace = "1password";
          match = [ "*://*/*" ];
          "run-at" = "document-end";
          script = builtins.readFile ../dotfiles/qutebrowser/1pass.js;
        }
      ];
    };
    searchEngines = {
      w = "https://wikipedia.org/w/index.php?search={}";
      aw = "https://wiki.archlinux.org/?search={}";
    };
  };
  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";
  };
}
