{
  config,
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.initrd.luks.devices."luks-a26d1b6a-644e-425e-89d3-a7619fcf22ea".device = "/dev/disk/by-uuid/a26d1b6a-644e-425e-89d3-a7619fcf22ea";
  networking.hostName = "framework"; # Define your hostname.

  services.tailscale.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.platformio-core.udev
    pkgs.openocd
  ];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services = {
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = "will";
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };

  services.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    qemu_full
  ];
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["will"];
  };

  services.gvfs.enable = true;
  fileSystems."/mnt/FractalMediaRemote" = {
    device = "//${secrets.tailscale.rootDomain}/Media";
    fsType = "cifs";
    options = [
      "username=will"
      "password=${secrets.samba.frac}"
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
      "uid=1000"
      "gid=100"
      "dir_mode=0777"
      "file_mode=0666"
      "nofail"
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
