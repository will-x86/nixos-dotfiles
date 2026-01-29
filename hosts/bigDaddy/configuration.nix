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
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true; # This enables Windows detection
    configurationLimit = 20; # Limits the number of configurations to keep, stops 500MB boot parition being full
  };
  services.tailscale.enable = true;
  boot.initrd.luks.devices."luks-14f78eb6-ba40-4c72-96c5-2924fca0f147".device =
    "/dev/disk/by-uuid/14f78eb6-ba40-4c72-96c5-2924fca0f147";

  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "bigDaddy";
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    host = "0.0.0.0";
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "will";
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.pulseaudio.enable = false;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "will" ];
  };

  environment.systemPackages =
    with pkgs;
    [
      cifs-utils
      # No longer needed !!
      #(import (builtins.fetchGit {
      #name = "my-old-revision";
      #        url = "https://github.com/NixOS/nixpkgs/";
      #        ref = "refs/heads/nixos-unstable";
      #        rev = "028048884dc9517e548703beb24a11408cc51402";
      #      }) { system = "x86_64-linux"; }).neovim
      neovim
    ]
    ++ (with pkgs-stable; [
      samba
    ]);
  fileSystems."/mnt/FractalMedia" = {
    device = "//${secrets.samba.fracRemote}/Media";
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

  fileSystems."/mnt/Fractal" = {
    device = "//${secrets.samba.fracRemote}/Vault";
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

  system.stateVersion = "24.11";
}
