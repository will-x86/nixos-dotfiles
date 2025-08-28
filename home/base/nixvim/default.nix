{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    imports = [
      ./keymaps.nix
      ./tmux.nix
      ./set.nix
      ./harpoon.nix
      ./telescope.nix
      ./lsp.nix
      ./cmp.nix
    ];

    globals.mapleader = " ";
    colorschemes.nord.enable = true;
    plugins = {
      #bufferline.enable = true;
      web-devicons.enable = true;
    };
  };
}
