{ pkgs, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      keymaps = [
        {
          mode = "n";
          key = "K";
          lspBufAction = "hover";
        }
        {
          mode = "i";
          key = "<C-s>";
          lspBufAction = "signature_help";
        }
        {
          mode = "n";
          key = "gd";
          lspBufAction = "definition";
        }
        {
          mode = "n";
          key = "gy";
          lspBufAction = "type_definition";
        }
        {
          mode = "n";
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          mode = "n";
          key = "vrr";
          lspBufAction = "references";
        }
        {
          mode = "n";
          key = "vws";
          lspBufAction = "workspace_symbol";
        }
        {
          mode = "n";
          key = "vd";
          action = "vim.diagnostic.open_float";
        }
        {
          mode = "n";
          key = "]d";
          action = "vim.diagnostic.goto_next";
        }
        {
          mode = "n";
          key = "[d";
          action = "vim.diagnostic.goto_prev";
        }
        {
          mode = "n";
          key = "vca";
          lspBufAction = "code_action";
        }
        {
          mode = "n";
          key = "vrn";
          lspBufAction = "rename";
        }
      ];
      servers = {
        bashls.enable = true;
        ccls.enable = true;
        cmake.enable = true;
        cssls.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nixd = {
          enable = true;
          settings = {
            nixd = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };
        ruff.enable = true;
        marksman.enable = true;
        ruby_lsp.enable = true;
        pylsp.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
          settings = {
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
    };
  };
}
