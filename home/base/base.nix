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
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    unzip
    lsof
    libpq
    moonlight-qt
    ntfsprogs
    dig
    curl
    exfat
    ffmpeg-full
    hfsprogs
    tailscale
    openssl
    rclone
    samba
    unrar-wrapper
    gnumake
    zip
    jq
    distrobox
    fastfetch
    tree
    dnsmasq # Used for pretending to be a router lol
    fzf
    ripgrep
    file
    zoxide
  ];
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      initContent = builtins.readFile ../dotfiles/.zshrc;
    };
    #firefox.enable = true; # byebye
    direnv.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    starship.enable = true;
    kitty.enable = true;
    foot.enable = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: true; # Allow all unfree packages
  };

  home.file = {
    ".config/starship.toml".source = ../dotfiles/starship.toml;
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
