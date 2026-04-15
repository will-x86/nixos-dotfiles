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

    obsidian
    spotify
    chromium
    anydesk
    davinci-resolve
    texliveFull
    zathura

  ];
}
