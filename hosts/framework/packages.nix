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
      llama-cpp-rocm

    ]
    ++ (with pkgs-stable; [
      samba
    ]);
}
