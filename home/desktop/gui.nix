{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    blender
    obs-studio
    mediawriter # fedoras media writer
    trayscale
    libreoffice
    discord
    zoom-us
    kicad
    kdePackages.dolphin
    #kdePackages.dolphin
    #kdePackages.dolphin-plugins
    #kdePackages.baloo-widgets
    #kdePackages.baloo
    freecad

    obsidian
    spotify
    chromium
    anydesk
    davinci-resolve
    celeste
    kdePackages.okular # pdf

  ];
}
