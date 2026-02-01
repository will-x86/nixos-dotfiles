{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    stylua
    nixfmt
    nodePackages.prettier
    black
    isort
    gopls
    rustfmt
  ];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = false;

      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };

      format_on_save_disabled_filetypes = [
        "c"
        "cpp"
      ];

      formatters_by_ft = {
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        vue = [ "prettier" ];
        html = [ "prettier" ];
        css = [ "prettier" ];
        json = [ "prettier" ];
        yaml = [ "prettier" ];
        python = [
          "isort"
          "black"
        ];
        go = [ "gofmt" ];
        rust = [ "rustfmt" ];
        ruby = [ "ruby" ];
      };
    };
  };

  keymaps = [
    {
      mode = "v";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end
      '';
      options = {
        desc = "[F]ormat buffer";
      };
    }
  ];
}
