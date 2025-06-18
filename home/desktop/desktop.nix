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
    nextcloud-client
    #inputs.zen-browser.packages.${system}.default
    libreoffice
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
    keyBindings = {
      normal = {
        ",p" = "spawn --userscript 1password.js";
      };
    };
    settings = {
      tabs.show = "multiple";
      fonts = {
        default_size = "12pt";
        web.size.default = 16;
        completion.entry = "12pt";
        statusbar = "12pt";
        tabs.selected = "12pt";
        tabs.unselected = "12pt";
        hints = "12pt";
        messages.error = "12pt";
        messages.info = "12pt";
        messages.warning = "12pt";
        prompts = "12pt";
      };
      zoom = {
        default = "150%";
        levels = [
          "25%"
          "33%"
          "50%"
          "67%"
          "75%"
          "90%"
          "100%"
          "110%"
          "125%"
          "150%"
          "175%"
          "200%"
          "250%"
          "300%"
          "400%"
          "500%"
        ];
      };
      colors = {
          webpage.prefers_color_scheme_dark = true;
        completion = {
          category = {
            bg = "#3b4252";
            border.bottom = "#3b4252";
            border.top = "#3b4252";
            fg = "#eceff4";
          };
          even.bg = "#434c5e";
          odd.bg = "#434c5e";
          fg = "#eceff4";
          match.fg = "#eee8d5";
          item.selected = {
            bg = "#8fbcbb";
            border.bottom = "#8fbcbb";
            border.top = "#8fbcbb";
            fg = "#eceff4";
          };
          scrollbar = {
            bg = "#4c566a";
            fg = "#eee8d5";
          };
        };
        downloads = {
          bar.bg = "#3b4252";
          error = {
            bg = "#bf616a";
            fg = "#eceff4";
          };
          start = {
            fg = "#eceff4";
          };
        };
        hints = {
          bg = "#8fbcbb";
          fg = "#eceff4";
          match.fg = "#eee8d5";
        };
        keyhint = {
          fg = "#eceff4";
          suffix.fg = "#ebcb8b";
        };
        messages = {
          error = {
            bg = "#bf616a";
            border = "#bf616a";
            fg = "#eceff4";
          };
          info = {
            bg = "#3b4252";
            border = "#3b4252";
            fg = "#eceff4";
          };
          warning = {
            bg = "#ebcb8b";
            border = "#ebcb8b";
            fg = "#eceff4";
          };
        };
        prompts = {
          bg = "#434c5e";
          border = "1px solid #eceff4";
          fg = "#eceff4";
          selected.bg = "#e5e9f0";
        };
        statusbar = {
          caret = {
            bg = "#5e81ac";
            fg = "#eceff4";
            selection = {
              bg = "#8fbcbb";
              fg = "#eceff4";
            };
          };
          command = {
            bg = "#3b4252";
            fg = "#eceff4";
            private = {
              bg = "#e5e9f0";
              fg = "#eceff4";
            };
          };
          insert = {
            bg = "#a3be8c";
            fg = "#eceff4";
          };
          normal = {
            bg = "#3b4252";
            fg = "#eceff4";
          };
          passthrough = {
            bg = "#b48ead";
            fg = "#eceff4";
          };
          private = {
            bg = "#e5e9f0";
            fg = "#eceff4";
          };
          progress.bg = "#eceff4";
          url = {
            error.fg = "#bf616a";
            fg = "#eceff4";
            hover.fg = "#eee8d5";
            success = {
              http.fg = "#eceff4";
              https.fg = "#eceff4";
            };
            warn.fg = "#ebcb8b";
          };
        };
        tabs = {
          even = {
            bg = "#e5e9f0";
            fg = "#eee8d5";
          };
          odd = {
            bg = "#e5e9f0";
            fg = "#eee8d5";
          };
          indicator = {
            error = "#bf616a";
            start = "#8fbcbb";
            stop = "#ebcb8b";
          };
          selected = {
            even = {
              bg = "#3b4252";
              fg = "#eceff4";
            };
            odd = {
              bg = "#3b4252";
              fg = "#eceff4";
            };
          };
        };
      };
    };
    searchEngines = {
      w = "https://wikipedia.org/w/index.php?search={}";
      no = "https://search.nixos.org/packages?channel=unstable&query={}";
    };
  };
  xdg.configFile."qutebrowser/userscripts/1password.js" = {
    source = pkgs.writeScript "1password.js" (builtins.readFile ../dotfiles/qutebrowser/1pass.js);
  };

  systemd.user.services.nextcloud-client = {
    Unit = {
      Description = "Nextcloud Client";
      After = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };
  # ... rest of your configuration ...
  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";
  };
}
