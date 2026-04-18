{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    stylua
    nixfmt
    nodePackages.prettierd
    black
    isort
    gopls
    rustfmt
    eslint_d
  ];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = false;

      format_on_save = {
        timeout_ms = 1000;
        lsp_fallback = true;
      };

      format_on_save_disabled_filetypes = [
        "c"
        "cpp"
      ];

      formatters_by_ft = {
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        javascript = [
          "eslint_d"
          "prettierd"
        ];
        typescript = [
          "eslint_d"
          "prettierd"
        ];
        javascriptreact = [
          "eslint_d"
          "prettierd"
        ];
        typescriptreact = [
          "eslint_d"
          "prettierd"
        ];
        vue = [
          "eslint_d"
          "prettierd"
        ];
        html = [
          "eslint_d"
          "prettierd"
        ];
        css = [
          "eslint_d"
          "prettierd"
        ];
        json = [
          "eslint_d"
          "prettierd"
        ];
        yaml = [
          "eslint_d"
          "prettierd"
        ];
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
