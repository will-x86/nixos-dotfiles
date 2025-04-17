{
  config,
  inputs,
  pkgs,
  system ? pkgs.system,
  secrets,
  ...
}: let
  base = import ../base/base.nix {inherit config pkgs;};
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  custom-bambu-studio = pkgs.bambu-studio.overrideAttrs (oldAttrs: {
    version = "01.00.01.50";
    src = pkgs.fetchFromGitHub {
      owner = "bambulab";
      repo = "BambuStudio";
      rev = "v01.00.01.50";
      hash = "sha256-7mkrPl2CQSfc1lRjl1ilwxdYcK5iRU//QGKmdCicK30=";
    };
  });
in {
  imports = [
    base
  ];

  home.file = {
    ".config/hypr" = {
      source = ../dotfiles/hypr;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    pulsemixer
    custom-bambu-studio
    ventoy-full
    pkgs-stable.google-chrome
    wineWowPackages.waylandFull
    pkgs-stable.beekeeper-studio
    jellyfin-web
    kodi-jellyfin
    winetricks
    mokutil
    lsb-release
    obs-studio
    trezor-suite
    trezor-agent
    mediawriter
    gettext
    cabextract
    samba4Full
    glxinfo
    #spacenavd
    bc
    mokutil
    gawk
    coreutils
    polkit
    xdg-utils
    tailwindcss-language-server
    vscode-langservers-extracted
    quickemu
    mysql84
    zoom-us
    jdk17
    signal-desktop
    #openjdk
    maven
    prusa-slicer
    platformio
    orca-slicer
    gtk3
    gtk4
    webkitgtk_6_0
    inputs.zen-browser.packages.${system}.default
    syncthingtray
    iwd
    feishin
    polkit
    python312Packages.dbus-python
    mcomix
    swaylock
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
    davinci-resolve
    brightnessctl
    greetd.tuigreet
    obsidian
    gocr
    #nfs-utils
    python311Packages.pip
    upx
    wl-clipboard
    ryujinx
    waybar
    viewnior
    wofi
    mako
    foot
    swww
    rofi
    mpv
    mpc-cli
    mpd
    slurp
    imagemagick
    feh
    playerctl
  ];

  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${secrets.anthropic.api_key}";
  };
}
