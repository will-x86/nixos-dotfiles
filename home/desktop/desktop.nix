{
  config,
  inputs,
  pkgs,
  system ? pkgs.system,
  secrets,
  ...
}: let
  base = import ../base/base.nix {inherit config pkgs;};
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
    bambu-studio
    #Autodesk start
    /*
      wineWowPackages.waylandFull
    winetricks
    lsb-release
    wget
    p7zip
    gettext
    cabextract
    samba4Full
    spacenavd
    bc
    */
    wineWowPackages.waylandFull
    winetricks
    mokutil
    lsb-release
    wget
    p7zip
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
    curl
    #mesa-utils
    polkit
    xdg-utils
    #Autodesk end
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
    exfat
    hfsprogs
    webkitgtk_6_0
    inputs.zen-browser.packages.${system}.default
    syncthingtray
    iwd
    typescript-language-server
    feishin
    deno
    polkit
    killall
    python312Packages.dbus-python
    mcomix
    swaylock
    dbeaver-bin
    discord
    postman
    arduino
    #llvmPackages_latest.lldb
    clang-tools
    #lldb
    avrdude
    ccls
    vscode
    ffmpeg-full
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
    typescript-language-server
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
