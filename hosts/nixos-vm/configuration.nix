{
  config,
  pkgs,
  ...
}: {
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
  nix.trustedUsers = ["root" "will"];
  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
      passwordAuthentication = true;
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
    }) {system = "x86_64-linux";})
    .neovim
  ];

  system.stateVersion = "24.11";
}
