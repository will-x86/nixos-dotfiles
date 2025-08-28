{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    stylua
    nixfmt
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.eslint_d
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
        html = [ "prettier" ];
        css = [ "prettier" ];
        json = [ "prettier" ];
        yaml = [ "prettier" ];
        python = [ "isort" "black" ];
        go = [ "gofmt" ];
        rust = [ "rustfmt" ];
      };
    };
  };

  plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics = {
        eslint_d.enable = true;
      };
      
      code_actions = {
        eslint_d.enable = true;
      };
    };
    
    settings = {
      debounce = 150;
      
      diagnostics_format = "[#{c}] #{m} (#{s})";
      
      update_in_insert = false;
    };
  };

  keymaps = [
    {
      mode = "";
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
    {
      mode = "n";
      key = "<leader>ef";
      action.__raw = ''
        function()
          vim.cmd("EslintFixAll")
        end
      '';
      options = {
        desc = "[E]SLint [F]ix All";
      };
    }
  ];
}
