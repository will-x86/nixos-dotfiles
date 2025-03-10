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
  services.flatpak.enable = true;
  services.syncthing = {
    enable = true;
    #group = "mygroupname";
    user = "will";
    dataDir = "/home/will/Documents";
    configDir = "/home/will/Documents/.config/syncthing";
    settings.gui = {
      user = "will";
      password = "${secrets.syncthing.pass}";
    };
  };
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  hardware.keyboard.qmk.enable = true;
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.platformio-core
    pkgs.platformio-core.udev
    pkgs.openocd
    pkgs.android-udev-rules
    pkgs.via
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      rocmPackages_5.clr
      rocmPackages_5.rocminfo
      rocmPackages_5.rocm-runtime
    ];
  };
  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
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
    networkmanagerapplet
    kdePackages.plasma-nm
    via
  ];
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["will"];
  };

  services.gvfs.enable = true;

  # Add user 'will' to dialout group for serial port access
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
  users.users.will.extraGroups = ["dialout"];
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

  fileSystems."/mnt/FractalVault" = {
    device = "//${secrets.tailscale.rootDomain}/Vault";
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
