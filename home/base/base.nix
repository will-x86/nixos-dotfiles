{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./ssh.nix
    ./nixvim
    ./programming.nix
    ./tui/tmux.nix
    ./tui/tui.nix
  ];
  home.username = "will";
  home.homeDirectory = "/home/will";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    # --- cli utils ---
    nix-index
    curl
    dig
    fastfetch
    file
    fzf
    jq
    ripgrep
    tree
    unzip
    zip
    zoxide

    # --- system / filesystem ---
    dnsmasq # Used for pretending to be a router lol
    exfat
    ffmpeg-full
    gnumake
    hfsprogs
    libpq
    lsof
    ntfsprogs
    openssl
    rclone
    samba
    unrar-wrapper

    # --- apps ---
    distrobox
    moonlight-qt
    tailscale
  ];
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      initContent = builtins.readFile ../dotfiles/.zshrc;
    };
    #firefox.enable = true; # byebye
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship.toml);
    };
    kitty.enable = true;
    foot.enable = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: true; # Allow all unfree packages
  };

  home.file = {
    # starship.toml is now managed via programs.starship.settings
    ".tmux-sessioniser".source = ../dotfiles/.tmux-sessioniser;
    "tmux-sessioniser".source = ../dotfiles/tmux-sessioniser;
    #".zshrc".source = ../dotfiles/.zshrc;
    ".config/kitty" = {
      source = ../dotfiles/kitty;
      recursive = true;
    };
    # You will be missed
    /*
      ".config/nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
    */
  };
}
