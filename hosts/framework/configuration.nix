{
  #config,
  pkgs,
  secrets,
  pkgs-stable,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./smb.nix
    ./user.nix
    ./packages.nix
    ./flatpack.nix
  ];
  systemd.services.proton-bisync = {
    description = "Bidirectional sync between local directory and Proton Drive";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "will";
      ExecStart = "${pkgs.rclone}/bin/rclone bisync /home/will/Documents/Proton remote:/ --config=/etc/rclone-proton.conf";
    };
  };

  systemd.timers.proton-bisync = {
    description = "Timer for Proton Drive bidirectional sync";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "30min"; # Run every 30 minutes
      Unit = "proton-bisync.service";
    };
  };
  programs.nix-ld.enable = true;
  virtualisation.waydroid.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.initrd.luks.devices."luks-a26d1b6a-644e-425e-89d3-a7619fcf22ea".device =
    "/dev/disk/by-uuid/a26d1b6a-644e-425e-89d3-a7619fcf22ea";
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];
  security.pki.certificates = [
    (builtins.readFile "${./../../secrets/NextDNS.cer}")
  ];
  services = {
    fwupd.enable = true;
    #jellyfin.enable = true;
    power-profiles-daemon.enable = true;
    tailscale.enable = true;
    xserver.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    flatpak.enable = true;
    mullvad-vpn.enable = true;
    #trezord.enable = true;
    syncthing = {
      enable = true;
      user = "will";
      dataDir = "/home/will/Documents";
      configDir = "/home/will/Documents/.config/syncthing";
      settings.gui = {
        user = "will";
        password = "${secrets.syncthing.pass}";
      };
    };
    udev.packages = [
      pkgs.platformio-core
      pkgs.platformio-core.udev
      pkgs.openocd
      pkgs.android-udev-rules
      pkgs.via
      pkgs.qmk-udev-rules
      pkgs.vial
    ];
    blueman.enable = true;
    desktopManager.plasma6.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    printing.enable = true;
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
    pulseaudio.enable = false;
    gvfs.enable = true;
  };

  powerManagement.powertop.enable = true;
  networking.hostName = "framework";
  hardware.spacenavd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  programs.adb.enable = true;
  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking.firewall.allowedTCPPorts = [
    8384
    22000
  ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
