{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      cifs-utils
      rclone
      nfs-utils
      networkmanagerapplet
      kdePackages.plasma-nm
      via
      #android-studio
      kodiPackages.jellyfin
      jellyfin-web
    ]
    ++ (with pkgs-stable; [
      samba
    ]);
}
