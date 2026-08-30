{
  pkgs,
  pkgs-stable,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      blender
      obs-studio
      mediawriter # fedoras media writer
      trayscale
      libreoffice
      discord
      zoom-us
      kicad
      freecad

      obsidian
      spotify
      chromium
      anydesk
      davinci-resolve
      signal-desktop
      kdePackages.okular # pdf

    ]
  );
}
