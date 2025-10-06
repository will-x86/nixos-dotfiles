{ pkgs, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      onAttach = ''
        local lsp_keybinds = {
          {
            mode = "n",
            key = "K",
            action = vim.lsp.buf.hover,
            options = {
              buffer = bufnr,
              desc = "LSP: Hover [K]nowledge",
            },
          },
          {
            mode = "i",
            key = "<C-s>",
            action = vim.lsp.buf.signature_help,
            options = {
              buffer = bufnr,
              desc = "LSP: Signature Help",
            },
          },
          {
            mode = "n",
            key = "gd",
            action = vim.lsp.buf.definition,
            options = {
              buffer = bufnr,
              desc = "LSP: [G]oto [D]efinition",
            },
          },
          {
            mode = "n",
            key = "gy",
            action = vim.lsp.buf.type_definition,
            options = {
              buffer = bufnr,
              desc = "LSP: [G]oto [T]ype Definition",
            },
          },
          {
            mode = "n",
            key = "gi",
            action = vim.lsp.buf.implementation,
            options = {
              buffer = bufnr,
              desc = "LSP: [G]oto [I]mplementation",
            },
          },
          {
            mode = "n",
            key = "vrr",
            action = vim.lsp.buf.references,
            options = {
              buffer = bufnr,
              desc = "LSP: View [R]eferences",
            },
          },
          {
            mode = "n",
            key = "vws",
            action = vim.lsp.buf.workspace_symbol,
            options = {
              buffer = bufnr,
              desc = "LSP: View [W]orkspace [S]ymbols",
            },
          },
          {
            mode = "n",
            key = "vd",
            action = vim.diagnostic.open_float,
            options = {
              buffer = bufnr,
              desc = "LSP: [V]iew [D]iagnostics in float",
            },
          },
          {
            mode = "n",
            key = "]d",
            action = vim.diagnostic.goto_next,
            options = {
              buffer = bufnr,
              desc = "LSP: Next [D]iagnostic ([j]ump down)",
            },
          },
          {
            mode = "n",
            key = "[d",
            action = vim.diagnostic.goto_prev,
            options = {
              buffer = bufnr,
              desc = "LSP: Previous [D]iagnostic ([k]ey up)",
            },
          },
          {
            mode = "n",
            key = "vca",
            action = vim.lsp.buf.code_action,
            options = {
              buffer = bufnr,
              desc = "LSP: View [C]ode [A]ctions",
            },
          },
          {
            mode = "n",
            key = "vrn",
            action = vim.lsp.buf.rename,
            options = {
              buffer = bufnr,
              desc = "LSP: [R]e[n]ame variable",
            },
          },
        }

        for _, bind in ipairs(lsp_keybinds) do
          vim.keymap.set(bind.mode, bind.key, bind.action, bind.options)
        end
      '';
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
