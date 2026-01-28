{ ... }:
{
  users.users.will.extraGroups = [
    "dialout"
    "adbusers"
    "libvirtd"
    # Other groups like "networkmanager", "wheel", "docker" are already in all.nix
  ];
  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
    podman.dockerCompat = true;
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;

  nix.settings.trusted-users = [
    "root"
    "will"
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "will" ];
  };
}
