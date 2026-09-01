{
  config,
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
    ./fan.nix
  ];
  nixpkgs.config.allowUnfree = true;
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
      HandleLidSwitchDocked = "ignore";
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
      enableKwallet = true;

      settings.default_session = {
        user = "will";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      };
    };
    pulseaudio.enable = false;
    gvfs.enable = true;
  };

  powerManagement.powertop.enable = true;
  networking.hostName = "framework";
  hardware.spacenavd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.initrd.systemd.enable = true;
  ## Stolen https://discourse.nixos.org/t/how-to-automatically-unlock-kwallet-at-start-up/61308/9
  security.pam.services.greetd.kwallet = {
    enable = true;
    forceRun = true;
  };

  services.dbus.packages = with pkgs.kdePackages; [ kwallet ];
  xdg.portal.extraPortals = with pkgs.kdePackages; [ kwallet ];

  systemd.user.services.pam-kwallet-init = {
    description = "Unlock kwallet from pam credentials";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Slice = "background.slice";
      Restart = "no";
    };
  };
  ## End stolen

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
