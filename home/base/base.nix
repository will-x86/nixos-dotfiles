{
  config,
  pkgs,
  ...
}:
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
    ### Neovim
    lua-language-server
    stylua
    tailwindcss-language-server
    svelte-language-server
    lua-language-server
    alejandra
    typescript-language-server
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
    arduino-language-server
    zig
    arduino-cli
    ### End neovim
    nodejs
    #alacritty
    unzip
    #immich-go
    #go-blueprint
    #flutter
    lsof
    #virt-viewer
    moonlight-qt
    ntfsprogs
    #awscli2
    #cloudflared
    dig
    #libcgroup
    #wget
    #p7zip
    curl
    #gh
    #nnn
    exfat
    deno
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
    #sshpass
    jq
    go
    fastfetch
    python3
    gopls
    btop
    #gcc
    tree
    rust-analyzer
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
  };
}
