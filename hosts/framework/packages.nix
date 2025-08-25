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
    ]
    ++ (with pkgs-stable; [
      samba
    ]);
}
