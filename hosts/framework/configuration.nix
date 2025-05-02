{
  config,
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./smb.nix
    ./user.nix
    ./packages.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.initrd.luks.devices."luks-a26d1b6a-644e-425e-89d3-a7619fcf22ea".device = "/dev/disk/by-uuid/a26d1b6a-644e-425e-89d3-a7619fcf22ea";
  boot.kernelParams = [
    /*
      "quiet"
    "splash"
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1"
    "nvme.noacpi=1"
    "amd_pstate=active"
    "mem_sleep_default=s2idle"
    "amdgpu.sg_display=0"
    "amdgpu.abmlevel=3"
    */
    "amdgpu.dcdebugmask=0x10"
  ];
  services.fwupd.enable = true;
  services.jellyfin.enable = true;
  services.power-profiles-daemon.enable = true;
  powerManagement.powertop.enable = true;
  networking.hostName = "framework";
  hardware.spacenavd.enable = true;
  services.tailscale.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  boot.initrd.kernelModules = ["amdgpu"];
  services.flatpak.enable = true;
  services.mullvad-vpn.enable = true;
  services.trezord.enable = true;
  services.syncthing = {
    enable = true;
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
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  hardware.keyboard.qmk.enable = true;

  programs.adb.enable = true;
  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };
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


  services.gvfs.enable = true;

  # Add user 'will' to dialout group for serial port access
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  system.stateVersion = "24.05"; # Did you read the comment?
}
