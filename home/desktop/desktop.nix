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
    zoom-us
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
        "tT" = "config-cycle tabs.position top left";

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
        hints = "15pt";
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
      auto_save.session = true;
      tabs.width = "7%";

      content = {
        blocking.enabled = true;
        javascript.clipboard = "access";
      };
      colors = {
        webpage = {
          darkmode = {
            enabled = false;
            algorithm = "lightness-cielab";
            policy.images = "never";
          };
        };
        completion = {
          category = {
            bg = "#2e3440";
            border.bottom = "#2e3440";
            border.top = "#2e3440";
            fg = "#e5e9f0";
          };
          even.bg = "#3b4252";
          odd.bg = "#3b4252";
          fg = "#d8dee9";
          match.fg = "#ebcb8b";
          item.selected = {
            bg = "#4c566a";
            border.bottom = "#4c566a";
            border.top = "#4c566a";
            fg = "#eceff4";
          };
          scrollbar = {
            bg = "#3b4252";
            fg = "#e5e9f0";
          };
        };
        downloads = {
          bar.bg = "#2e3440";
          error = {
            bg = "#bf616a";
            fg = "#e5e9f0";
          };
          stop.bg = "#b48ead";
          system.bg = "none";
        };
        hints = {
          bg = "#ebcb8b";
          fg = "#2e3440";
          match.fg = "#5e81ac";
        };
        keyhint = {
          bg = "#3b4252";
          fg = "#e5e9f0";
          suffix.fg = "#ebcb8b";
        };
        messages = {
          error = {
            bg = "#bf616a";
            border = "#bf616a";
            fg = "#e5e9f0";
          };
          info = {
            bg = "#88c0d0";
            border = "#88c0d0";
            fg = "#e5e9f0";
          };
          warning = {
            bg = "#d08770";
            border = "#d08770";
            fg = "#e5e9f0";
          };
        };
        prompts = {
          bg = "#434c5e";
          border = "1px solid #2e3440";
          fg = "#e5e9f0";
          selected.bg = "#4c566a";
        };
        statusbar = {
          caret = {
            bg = "#b48ead";
            fg = "#e5e9f0";
            selection = {
              bg = "#b48ead";
              fg = "#e5e9f0";
            };
          };
          command = {
            bg = "#434c5e";
            fg = "#e5e9f0";
            private = {
              bg = "#434c5e";
              fg = "#e5e9f0";
            };
          };
          insert = {
            bg = "#a3be8c";
            fg = "#3b4252";
          };
          normal = {
            bg = "#2e3440";
            fg = "#e5e9f0";
          };
          passthrough = {
            bg = "#5e81ac";
            fg = "#e5e9f0";
          };
          private = {
            bg = "#4c566a";
            fg = "#e5e9f0";
          };
          progress.bg = "#e5e9f0";
          url = {
            error.fg = "#bf616a";
            fg = "#e5e9f0";
            hover.fg = "#88c0d0";
            success = {
              http.fg = "#e5e9f0";
              https.fg = "#a3be8c";
            };
            warn.fg = "#d08770";
          };
        };
        tabs = {
          bar.bg = "#4c566a";
          even = {
            bg = "#4c566a";
            fg = "#e5e9f0";
          };
          odd = {
            bg = "#4c566a";
            fg = "#e5e9f0";
          };
          indicator = {
            error = "#bf616a";
            system = "none";
          };
          selected = {
            even = {
              bg = "#2e3440";
              fg = "#e5e9f0";
            };
            odd = {
              bg = "#2e3440";
              fg = "#e5e9f0";
            };
          };
        };
      };
    };
    searchEngines = {
      w = "https://wikipedia.org/w/index.php?search={}";
      no = "https://search.nixos.org/packages?channel=unstable&query={}";
      aw = "https://wiki.archlinux.org/?search={}";
      ap = "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=";
      gh = "https://github.com/search?o=desc&q={}&s=stars";
      y = "https://www.youtube.com/results?search_query={}";
    };
  };
  xdg.configFile."qutebrowser/userscripts/1password.js" = {
    source = pkgs.writeScript "1password.js" (builtins.readFile ../dotfiles/qutebrowser/1pass.js);
  };
  xdg.configFile."qutebrowser/userscripts/yt-ads.js" = {
    source = pkgs.writeScript "yt-ads.js" (builtins.readFile ../dotfiles/qutebrowser/yt-ads.js);
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
