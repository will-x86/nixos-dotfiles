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

  home.packages = with pkgs; [
    nodejs_23
    alacritty
    unzip
    immich-go
    go-blueprint
    lsof
    awscli2
    dig
    libcgroup
    gh
    nnn
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
  ];
  programs = {
  home-manager.enable = true;
  git.enable = true;
  zsh.enable = true;
  neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped.overrideAttrs (old: {
      version = "0.10.4";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "5eeeafe5160f880da38cc00385e1ea3fdfe5667e";
        hash = "sha256-TAuoa5GD50XB4OCHkSwP1oXfedzVrCBRutNxBp/zGLY=";
      };
    });
  };
  firefox.enable = true;
  direnv.enable = true;
};

  home.file = {
    ".p10k.zsh".source = ../dotfiles/.p10k.zsh;
    ".tmux-sessioniser".source = ../dotfiles/.tmux-sessioniser;
    "tmux-sessioniser".source = ../dotfiles/tmux-sessioniser;
    ".zshrc".source = ../dotfiles/.zshrc;
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
  };
}
