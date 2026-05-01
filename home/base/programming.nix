{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # nix-specific
    nixos-shell # vm's
    nixos-generators

    devenv
    # Languages
    typescript # nixvim
    go
    gcc
    nodejs
    python3
    ccls
    jdk17
    # lsp stuff
    typescript-language-server # nixvim
    black
    eslint
    # extensions / other
    maven
    uv
    rust-analyzer
    yarn
    cargo
    openssl
    pkg-config
    python312Packages.marimo
    python312Packages.dbus-python
    # tui programing
    opencode

  ];
}
