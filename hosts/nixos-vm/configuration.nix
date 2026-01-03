{
  config,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-vm";
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  hardware.enableAllFirmware = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "will";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.tailscale.enable = true;

  nixpkgs.config.allowUnfree = true;
  users.users.will.linger = true;
  nix.settings.trusted-users = [
    "root"
    "will"
  ];
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };
  };

  programs._1password.enable = true;

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    (import (builtins.fetchGit {
      name = "my-old-revision";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixos-unstable";
      rev = "028048884dc9517e548703beb24a11408cc51402";
    }) { system = "x86_64-linux"; }).neovim
  ];

  fileSystems."/mnt/FractalMedia" = {
    device = "//${secrets.samba.fracRemote}/Media";
    fsType = "cifs";
    options = [
      "username=will"
      "password=${secrets.samba.frac}"
      "noauto"
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
      "noauto"
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
