{
  config,
  secrets,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    opts = {
      number = true;
      relativenumber = true;
    };

    plugins = {
      treesitter.enable = true;
      lsp.enable = true;
    };
  };

}
