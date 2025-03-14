{
  config,
  pkgs,
  secrets,
  ...
}: {
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.dates = "weekly";
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  /*
    networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant
    userControlled.enable = true;
    networks = {
      "eduroam" = {
        auth = ''
          key_mgmt=WPA-EAP
          eap=PEAP
          identity="${secrets.eduroam.email}"
          password="${secrets.eduroam.pass}"
          phase2="auth=MSCHAPV2"
        '';
      };
    };
  };
  */
  #networking.networkmanager.enable = true;
  /*
    networking.wireless.iwd.settings = {
    IPv6 = {
      Enabled = true;
    };
    Settings = {
      AutoConnect = true;
    };
  };
  networking.networkmanager.wifi.backend = "iwd";
  */
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
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

  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.jetbrains-mono
    font-awesome
    apl386
    noto-fonts
    dejavu_fonts
    font-awesome
    fira-code-symbols
    powerline-symbols
    material-design-icons
  ];
  #fonts.fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font"];
  fonts.fontconfig.defaultFonts.monospace = ["Monaspace Neon"];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager
    wpa_supplicant
    python3
    python312Packages.dbus-python
    openssl
  ];
  services.dbus.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  services.tailscale.enable = true;

  programs._1password.enable = true;

  users.users.will = {
    isNormalUser = true;
    description = "will";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  home-manager.backupFileExtension = null;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

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
    device = "//${secrets.samba.fracLocal}/Vault";
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

  networking.firewall = {
    enable = false;
    allowPing = true;
  };
}
