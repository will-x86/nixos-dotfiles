{
  config,
  secrets,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = true;

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
