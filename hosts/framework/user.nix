{ pkgs, ... }:
{
  users.users.will.extraGroups = [
    "dialout"
    "adbusers"
    "libvirtd"
    # Other groups like "networkmanager", "wheel", "docker" are already in all.nix
  ];
  virtualisation = {
    libvirtd.enable = true;
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
  # Remap caps log key to escape
  services.xremap = {
    enable = true;
    package = pkgs.xremap;
    userName = "will";
    yamlConfig = ''
      modmap:
        - remap:
            CapsLock: Esc
    '';
  };
}
