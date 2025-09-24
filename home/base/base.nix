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
    ./tui/tmux.nix
  ];
  home.username = "will";
  home.homeDirectory = "/home/will";
  home.stateVersion = "24.11";
  #programs.neovim.enable = true;
  home.packages = with pkgs; [
    ### Neovim
    /*
      lua-language-server
      jdt-language-server
      stylua
      tailwindcss-language-server
      svelte-language-server
      lua-language-server
      alejandra
      typescript-language-server
      gopls
      gotools
      yaml-language-server
      yamlfix
      rustfmt
      nil # nix
      nixfmt-rfc-style
      zls
      nodePackages.prettier
      typescript
      eslint_d
      vue-language-server
      vscode-langservers-extracted
      zig
      arduino-cli
    */
    ### End neovim
    gcc
    nodejs
    unzip
    lsof
    libpq
    postgresql
    moonlight-qt
    ntfsprogs
    dig
    curl
    exfat
    killall
    ffmpeg-full
    hfsprogs
    tailscale
    git-crypt
    openssl
    rclone
    git-lfs
    samba
    unrar-wrapper
    yarn
    gnumake
    zip
    jq
    go
    fastfetch
    python3
    btop
    tree
    rust-analyzer
    dnsmasq # Used for pretending to be a router lol
    tmux
    fzf
    ripgrep
    file
    zoxide
  ];
  programs = {
    home-manager.enable = true;
    git.enable = true;
    zsh = {
      enable = true;
      initContent = builtins.readFile ../dotfiles/.zshrc;
    };
    firefox.enable = true;
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

  home.file = {
    ".config/starship.toml".source = ../dotfiles/starship.toml;
    ".tmux-sessioniser".source = ../dotfiles/.tmux-sessioniser;
    "tmux-sessioniser".source = ../dotfiles/tmux-sessioniser;
    #".zshrc".source = ../dotfiles/.zshrc;
    ".config/kitty" = {
      source = ../dotfiles/kitty;
      recursive = true;
    };
    ".config/lan-mouse" = {
      source = ../dotfiles/lan-mouse;
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
