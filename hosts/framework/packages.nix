{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    networkmanagerapplet
    kdePackages.plasma-nm
    via
    android-studio
    kodiPackages.jellyfin
    jellyfin-web
  ];
}
