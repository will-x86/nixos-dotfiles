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
  boot.initrd.luks.devices."luks-9d66bf13-c491-40fc-94df-ced4fa14f219".device = "/dev/disk/by-uuid/9d66bf13-c491-40fc-94df-ced4fa14f219";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "bigDaddy"; # Define your hostname.
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.xserver.enable = true;

  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.displayManager.gdm.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
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

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["will"];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
