{ ... }:
{
  users.users.will.extraGroups = [
    "dialout"
    "adbusers"
    # Other groups like "networkmanager", "wheel", "docker" are already in all.nix
  ];

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
