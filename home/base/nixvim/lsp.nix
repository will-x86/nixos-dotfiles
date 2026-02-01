{ pkgs, lib, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      keymaps = {
        lspBuf = {
          K = "hover";
          "<C-s>" = {
            action = "signature_help";
            mode = "i";
          };
          gd = "definition";
          gy = "type_definition";
          gi = "implementation";
          vrr = "references";
          vws = "workspace_symbol";
          vca = "code_action";
          vrn = "rename";
        };
        diagnostic = {
          vd = "open_float";
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
      };
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
        ts_ls.enable = true;
        dartls.enable = true;
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
        ## AI !!!  wow !
        copilot.enable = true;
      };
    };
  };
}
