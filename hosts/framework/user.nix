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
  # Ts ain't user
  services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8010", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8010", GROUP="dialout", MODE="0660"

    # Programmer in ARM mode
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8012", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8012", GROUP="dialout", MODE="0660"

    # Programmer in IAP mode
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4348", ATTRS{idProduct}=="55e0", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4348", ATTRS{idProduct}=="55e0", GROUP="dialout", MODE="0660"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", GROUP="dialout", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", GROUP="plugdev", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", GROUP="dialout", MODE="0660"

    # rv003usb bootloader
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b003", GROUP="plugdev", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b003", GROUP="dialout", MODE="0660"
    #KERNEL=="hiddev*", SUBSYSTEM=="usbmisc", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b003", GROUP="plugdev", MODE="0660"
    #KERNEL=="hiddev*", SUBSYSTEM=="usbmisc", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b003", GROUP="dialout", MODE="0660"

    # ch32v003 programming rvswdio dongle
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1206", ATTRS{idProduct}=="5d10", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1206", ATTRS{idProduct}=="5d10", GROUP="dialout", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1206", ATTRS{idProduct}=="5d10", GROUP="plugdev", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1206", ATTRS{idProduct}=="5d10", GROUP="dialout", MODE="0660"

  '';
}
