{
  config,
  pkgs,
  ...
}: {
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
    ### Neovim
    lua-language-server
    "@vue/typescript-plugin"

    stylua
    # gofmt  is in go
    gotools
    rustfmt
    nodePackages.prettier
    typescript
    eslint_d
    vue-language-server
    vscode-langservers-extracted
    zig

    ### End neovim
    nodejs_23
    alacritty
    unzip
    immich-go
    go-blueprint
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
    zoxide
    ripgrep
    file
  ];
  programs = {
    home-manager.enable = true;
    git.enable = true;
    zsh.enable = true;
    firefox.enable = true;
    direnv.enable = true;
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
  };
}
