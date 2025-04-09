{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true; # This enables Windows detection
    configurationLimit = 20; # Limits the number of configurations to keep, stops boot being full
  };

  services.tailscale.enable = true;
  boot.initrd.luks.devices."luks-14f78eb6-ba40-4c72-96c5-2924fca0f147".device = "/dev/disk/by-uuid/14f78eb6-ba40-4c72-96c5-2924fca0f147";

  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "bigDaddy";
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # Set your time zone.
  time.timeZone = "Europe/London";
  services.ollama = {
    enable = true;
    acceleration = "rocm";
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

  services.xserver.videoDrivers = ["amdgpu"];
  /*
    services.ollama = {
    enable = true;
    package = pkgs.nixos-unstable.ollama;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1103"; # used to be necessary, but doesn't seem to anymore
    };
    rocmOverrideGfx = "10.3.1";
  };
  */

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
    polkitPolicyOwners = ["will"];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    (import (builtins.fetchGit {
      name = "my-old-revision";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixos-unstable";
      rev = "028048884dc9517e548703beb24a11408cc51402";
    }) {system = "x86_64-linux";})
    .neovim
  ];

  system.stateVersion = "24.11";
}
