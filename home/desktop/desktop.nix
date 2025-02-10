{
  config,
  pkgs,
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
    exfat
    hfsprogs
    python312Packages.dbus-python
    mcomix
    swaylock
    dbeaver-bin
    discord
    postman
    arduino
    llvmPackages_latest.lldb
    clang-tools
    lldb
    avrdude
    ccls
    vscode
    ffmpeg-full
    vulkan-tools
    grim
    kicad
    libnotify
    dolphin
    davinci-resolve
    platformio
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
