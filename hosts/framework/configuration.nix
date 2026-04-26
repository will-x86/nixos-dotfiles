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
    ./stylix.nix
  ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  virtualisation.waydroid.enable = true;
  boot.loader.systemd-boot.enable = true;
  services.usbmuxd.enable = true;
  programs.steam = {
    enable = true;
  };
  programs.direnv.enable = true; # something something cache

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
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore"; # hypridle/hyprlock handles
    };
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    power-profiles-daemon.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    tailscale.enable = true;
    xserver.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    flatpak.enable = true;
    syncthing = {
      enable = true;
      user = "will";
      dataDir = "/home/will/Documents";
      configDir = "/home/will/Documents/.config/syncthing";
      settings.gui = {
        user = "will";
        password = "${secrets.syncthing.pass}";
      };
      settings = {
        devices = {
          "frac" = {
            id = "${secrets.syncthing.frac}";
            name = "frac";
            addresses = [ "dynamic" ];
          };
          "fone" = {
            id = "${secrets.syncthing.fone}";
            name = "fone";
            addresses = [ "dynamic" ];
          };
        };
        folders = {
          "BooxNotes" = {
            id = "92jht-xiuqh";
            path = "/home/will/Documents/BooxNotes";
            devices = [
              "frac"
              "fone"
            ];
          };
          "BooxBooks" = {
            id = "x2w61-muute";
            path = "/home/will/Documents/BooxBooks";
            devices = [
              "frac"
              "fone"
            ];
          };
          "SyncDoc" = {
            id = "xq7l5-sdtka";
            path = "/home/will/Documents/SyncDoc";
            devices = [
              "frac"
              "fone"
            ];
          };
        };
      };
    };
    udev.packages = [
      pkgs.openocd
      pkgs.qmk-udev-rules
    ];
    desktopManager.plasma6.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    printing.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        user = "will";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
      };
    };
    pulseaudio.enable = false;
    gvfs.enable = true;
  };

  powerManagement.powertop.enable = true;
  networking.hostName = "framework";
  hardware.spacenavd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl # Enables Rusticl (OpenCL) support for resolve
    ];
  };
  hardware.amdgpu.opencl.enable = true; # also support for resolve

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
