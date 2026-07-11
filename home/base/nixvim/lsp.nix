{ pkgs, lib, ... }:
{
  plugins.lspconfig.enable = true; # Required for proper lsp hints / completions
  lsp.keymaps = [
    {
      key = "K";
      lspBufAction = "hover";
    }
    {
      key = "<C-s>";
      lspBufAction = "signature_help";
      mode = "i";
    }
    {
      key = "gd";
      lspBufAction = "definition";
    }
    {
      key = "gy";
      lspBufAction = "type_definition";
    }
    {
      key = "gi";
      lspBufAction = "implementation";
    }
    {
      key = "vrr";
      lspBufAction = "references";
    }
    {
      key = "vws";
      lspBufAction = "workspace_symbol";
    }
    {
      key = "vca";
      lspBufAction = "code_action";
    }
    {
      key = "vrn";
      lspBufAction = "rename";
    }

    {
      key = "vd";
      action = lib.nixvim.mkRaw "function() vim.diagnostic.open_float() end";
    }
    {
      key = "]d";
      action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1, float = true }) end";
    }
    {
      key = "[d";
      action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1, float = true }) end";
    }
  ];
  #lsp.inlayHints.enable = true;
  lsp.servers = {
    bashls.enable = true;
    ccls.enable = true;
    cmake.enable = true;
    cssls.enable = true;
    gopls.enable = true;
    html = {
      enable = true;
      config = {
        init_options.userLanguages.rust = "html";
      };
    };

    jsonls.enable = true;
    astro.enable = true;
    lua_ls.enable = true;

    nixd = {
      enable = true;
      config.settings = {
        nixd = {
          formatting = {
            command = [ "nixfmt" ];
          };
        };
      };
    };

    ruff.enable = true;
    # pylsp.enable = true;
    basedpyright.enable = true;
    marksman.enable = true;
    ruby_lsp.enable = true;

    ts_ls = {
      enable = true;
      config = {
        filetypes = [
          "typescript"
          "typescriptreact"
          "javascript"
          "javascriptreact"
          "vue"
          "astro"
          # "svelte"
        ];
        root_markers = [
          "package.json"
          "tsconfig.json"
          "jsconfig.json"
          ".git"
        ];
        init_options = {
          typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
        };
      };
    };

    svelte.enable = true;
    vue_ls.enable = true;
    dartls.enable = true;

    rust_analyzer = {
      enable = true;
      package = pkgs.rust-analyzer;
      config.settings = {
        rust-analyzer = {
          cargo = {
            allFeatures = true;
          };
        };
      };
    };

    yamlls.enable = true;
    zls.enable = true;
    eslint.enable = true;
  };
}
