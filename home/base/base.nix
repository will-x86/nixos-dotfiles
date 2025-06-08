{
  config,
  pkgs,
  ...
}:
let
  arduino-nvim = pkgs.fetchFromGitHub {
    owner = "yuukiflow";
    repo = "arduino-nvim";
    rev = "main";
    sha256 = "sha256-WTFbo5swtyAjLBOk9UciQCiBKOjkbwLStZMO/0uaZYg=";
  };
in

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./tui/tmux.nix
  ];
  home.username = "will";
  home.homeDirectory = "/home/will";
  home.stateVersion = "24.11";
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    ### Espressif
    flex
    bison
    gperf
    python3Packages.virtualenv
    cmake
    ninja
    ccache
    libffi
    openssl
    dfu-util
    libusb1
    ### End espressif
    ### Neovim
    lua-language-server
    kotlin-language-server
    stylua
    # gofmt  is in go
    gotools
    yaml-language-server
    yamlfix
    gofumpt
    rustfmt
    nil # nix
    nixfmt-rfc-style
    nodePackages.prettier
    typescript
    eslint_d
    vue-language-server
    vscode-langservers-extracted
    zig

    ### End neovim
    nodejs
    alacritty
    unzip
    immich-go
    go-blueprint
    flutter
    lsof
    virt-viewer
    moonlight-qt
    ntfsprogs
    zls
    awscli2
    cloudflared
    dig
    libcgroup
    wget
    p7zip
    curl
    gh
    tailwindcss-language-server
    nnn
    exfat
    deno
    typescript-language-server
    killall
    ffmpeg-full
    clang-tools
    hfsprogs
    tailscale
    git-crypt
    samba
    unrar-wrapper
    yarn
    cargo
    gnumake
    zip
    sshpass
    jq
    go
    fastfetch
    python3
    gopls
    lua-language-server
    btop
    gcc
    tree
    rust-analyzer
    alejandra
    tmux
    fzf
    ripgrep
    file
    zoxide
  ];
  programs = {
    home-manager.enable = true;
    git.enable = true;
    zsh.enable = true;
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
    ".zshrc".source = ../dotfiles/.zshrc;
    ".config/kitty" = {
      source = ../dotfiles/kitty;
      recursive = true;
    };
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
    ".config/nvim/lua/Arduino-Nvim" = {
      source = arduino-nvim;
      recursive = true;
    };
  };
}
