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
      kodiPackages.jellyfin
    ]
    ++ (with pkgs-stable; [
      samba
    ]);
}
