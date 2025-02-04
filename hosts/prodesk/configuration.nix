{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.initrd.luks.devices."luks-eed0d0b4-c47c-4f35-9e77-643a504f0777".device = "/dev/disk/by-uuid/eed0d0b4-c47c-4f35-9e77-643a504f0777";

  networking.hostName = "prodesk";
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
  ];

  services.gvfs.enable = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
