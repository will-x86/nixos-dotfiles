{
  config,
  pkgs,
  inputs,
  secrets,
  ...
}:
{
  system.autoUpgrade.enable = true;
  hardware.keyboard.qmk.enable = true;

  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.dates = "weekly";
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #networking.networkmanager = {
  #  enable = true;
  #wifi.backend = "wpa_supplicant";
  #};
  time.timeZone = "Europe/London";
  networking.wireless.iwd.settings = {
    Network = {
      EnableIPv6 = true;
    };
    Settings = {
      AutoConnect = true;
    };
  };

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
  fonts = {
    packages = with pkgs; [
      material-symbols

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      #inputs.self.packages.${pkgs.system}.SF-Pro
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.SF-Pro
      #inputs.self.packages.${pkgs.system}.SF-Pro-mono
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.SF-Pro-mono

      # nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.departure-mono
      departure-mono
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
      defaultFonts =
        let
          addAll = builtins.mapAttrs (_: v: [ "Symbols Nerd Font" ] ++ v ++ [ "Noto Color Emoji" ]);
        in
        addAll {
          serif = [ "Noto Sans Serif" ];
          sansSerif = [ "SF Pro Display" ];
          monospace = [ "Departure Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
    };
    enableDefaultPackages = true;
  };
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "containerd"
      "kvm"
      "adbusers"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  home-manager.backupFileExtension = "backup";

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    containerd.enable = true;
    podman.enable = true;
  };

  networking.firewall = {
    enable = false;
    allowPing = true;
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };
}
