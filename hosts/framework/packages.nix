{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    networkmanagerapplet
    kdePackages.plasma-nm
    via
    android-studio
    kodiPackages.jellyfin
    jellyfin-web
    #    (import (builtins.fetchGit {
    #      name = "nixpkgs-neovim-old";
    #      url = "https://github.com/NixOS/nixpkgs/";
    #      ref = "refs/heads/nixos-unstable";
    #      rev = "028048884dc9517e548703beb24a11408cc51402";
    #    }) {system = pkgs.system;})
    #    .neovim
  ];
}
