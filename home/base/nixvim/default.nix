{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };
    imports = [
      ./keymaps.nix
      ./tmux.nix
      ./set.nix
      ./harpoon.nix
      ./telescope.nix
      ./lsp.nix
      ./cmp.nix
      ./conform.nix
      ./transparent.nix # stolen from https://github.com/fred-drake/neovim/blob/c8ec1f4495b175cfcd9b0f4fa56844c51b01e5fa/config/transparent.nix
      ./treesitter.nix
    ];

    globals.mapleader = " ";
    colorschemes.nord.enable = true;

    diagnostic.settings = {
      virtual_text = true;
      signs = true;
      underline = true;
      update_in_insert = false;
      severity_sort = false;
    };
    extraPackages = with pkgs; [
      texliveFull
      zathura
      xdotool
    ];
    plugins = {
      #bufferline.enable = true;
      web-devicons.enable = true;
      render-markdown.enable = true;
      vimtex = {
        enable = true;
        texlivePackage = pkgs.texliveFull;
        settings = {
          view_method = "zathura";
        };
      };
      #copilot-vim.enable = true;
    };
  };
}
