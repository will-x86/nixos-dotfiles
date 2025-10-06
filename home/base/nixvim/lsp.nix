{ pkgs, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        #clangd.enable = true;
        ccls.enable = true;
        cmake.enable = true;
        cssls.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nixd.enable = true;
        ruff.enable = true;
        marksman.enable = true;
        ruby_lsp.enable = true;
        pylsp.enable = true;
        asm_lsp.enable = false;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        yamlls.enable = true;
        zls.enable = true;
        eslint.enable = true;
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
  ];
  extraConfigLua =
    # lua
    ''
      local function set_cmn_lsp_keybinds()
      	local lsp_keybinds = {
      		-- LSP Information
      		{
      			mode = "n",
      			key = "K",
      			action = vim.lsp.buf.hover,
      			options = {
      				buffer = 0,
      				desc = "LSP: Hover [K]nowledge",
      			},
      		},
      		{
      			mode = "i",
      			key = "<C-s>",
      			action = vim.lsp.buf.signature_help,
      			options = {
      				buffer = 0,
      				desc = "LSP: Signature Help",
      			},
      		},

      		-- Go to / Navigation
      		{
      			mode = "n",
      			key = "gd",
      			action = vim.lsp.buf.definition,
      			options = {
      				buffer = 0,
      				desc = "LSP: [G]oto [D]efinition",
      			},
      		},
      		{
      			mode = "n",
      			key = "gy",
      			action = vim.lsp.buf.type_definition,
      			options = {
      				buffer = 0,
      				desc = "LSP: [G]oto [T]ype Definition",
      			},
      		},
      		{
      			mode = "n",
      			key = "gi",
      			action = vim.lsp.buf.implementation,
      			options = {
      				buffer = 0,
      				desc = "LSP: [G]oto [I]mplementation",
      			},
      		},
      		{
      			mode = "n",
      			key = "vrr",
      			action = vim.lsp.buf.references,
      			options = {
      				buffer = 0,
      				desc = "LSP: View [R]eferences",
      			},
      		},
      		{
      			mode = "n",
      			key = "vws",
      			action = vim.lsp.buf.workspace_symbol,
      			options = {
      				buffer = 0,
      				desc = "LSP: View [W]orkspace [S]ymbols",
      			},
      		},

      		-- Diagnostics
      		{
      			mode = "n",
      			key = "vd",
      			action = vim.diagnostic.open_float,
      			options = {
      				buffer = 0,
      				desc = "LSP: [V]iew [D]iagnostics in float",
      			},
      		},
      		{
      			mode = "n",
      			key = "]d",
      			action = vim.diagnostic.goto_next,
      			options = {
      				buffer = 0,
      				desc = "LSP: Next [D]iagnostic ([j]ump down)",
      			},
      		},
      		{
      			mode = "n",
      			key = "[d",
      			action = vim.diagnostic.goto_prev,
      			options = {
      				buffer = 0,
      				desc = "LSP: Previous [D]iagnostic ([k]ey up)",
      			},
      		},

      		-- Actions / Refactoring
      		{
      			mode = "n",
      			key = "vca",
      			action = vim.lsp.buf.code_action,
      			options = {
      				buffer = 0,
      				desc = "LSP: View [C]ode [A]ctions",
      			},
      		},
      		{
      			mode = "n",
      			key = "vrn",
      			action = vim.lsp.buf.rename,
      			options = {
      				buffer = 0,
      				desc = "LSP: [R]e[n]ame variable",
      			},
      		},
      	}

      	for _, bind in ipairs(lsp_keybinds) do
      		vim.keymap.set(bind.mode, bind.key, bind.action, bind.options)
      	end
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true


      -- asm LSP
      vim.lsp.config.asm_lsp = {
      	cmd = { 'asm-lsp' },
      	filetypes = { 'asm', 's' },
      	root_dir = function(fname)
      		return vim.fs.root(0, { '.git' }) or vim.loop.cwd()
      	end,
      	capabilities = capabilities,
      }

      -- Bash LSP
      vim.lsp.config.bashls = {
      	cmd = { 'bash-language-server', 'start' },
      	filetypes = { 'sh' },
      	root_dir = vim.fs.root(0, { '.git' }),
      }

      -- ccls LSP
      vim.lsp.config.ccls = {
      	cmd = { 'ccls' },
      	filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
      	root_dir = vim.fs.root(0, { 'compile_commands.json', '.ccls', '.git' }),
      }

      -- cmake LSP
      vim.lsp.config.cmake = {
      	cmd = { 'cmake-language-server' },
      	filetypes = { 'cmake' },
      	root_dir = vim.fs.root(0, { 'CMakeLists.txt', '.git' }),
      }

      -- CSS LSP
      vim.lsp.config.cssls = {
      	cmd = { 'vscode-css-language-server', '--stdio' },
      	filetypes = { 'css', 'scss', 'less' },
      	root_dir = vim.fs.root(0, { 'package.json', '.git' }),
      }

      -- eslint LSP
      vim.lsp.config.eslint = {
      	cmd = { 'vscode-eslint-language-server', '--stdio' },
      	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      	root_dir = vim.fs.root(0, { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'package.json', '.git' }),
      }

      -- golang lsp
      vim.lsp.config.gopls = {
      	cmd = { 'gopls' },
      	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      	root_dir = vim.fs.root(0, { 'go.mod', '.git' }),
      }

      -- HTML lsp
      vim.lsp.config.html = {
      	cmd = { 'vscode-html-language-server', '--stdio' },
      	filetypes = { 'html' },
      	root_dir = vim.fs.root(0, { 'package.json', '.git' }),
      }

      -- JSON lsp
      vim.lsp.config.jsonls = {
      	cmd = { 'vscode-json-language-server', '--stdio' },
      	filetypes = { 'json', 'jsonc' },
      	root_dir = vim.fs.root(0, { 'package.json', '.git' }),
      }

      -- Lua LSP
      vim.lsp.config.lua_ls = {
      	cmd = { 'lua-language-server' },
      	filetypes = { 'lua' },
      	root_dir = vim.fs.root(0, { '.luarc.json', '.luarc.jsonc', '.git' }),
      }

      -- Markdown LSP
      vim.lsp.config.marksman = {
      	cmd = { 'marksman', 'server' },
      	filetypes = { 'markdown' },
      	root_dir = vim.fs.root(0, { '.git' }),
      }

      -- Nix LSP
      vim.lsp.config.nixd = {
      	cmd = { 'nixd' },
      	filetypes = { 'nix' },
      	root_dir = vim.fs.root(0, { 'flake.nix', '.git' }),
      	settings = {
      		nixd = {
      			formatting = {
      				command = { 'nixfmt' },
      			},
      		},
      	},
      }

      -- Python LSP (ruff)
      vim.lsp.config.ruff = {
      	cmd = { 'ruff', 'server' },
      	filetypes = { 'python' },
      	root_dir = vim.fs.root(0, { 'pyproject.toml', 'setup.py', '.git' }),
      }

      -- Rust LSP
      vim.lsp.config.rust_analyzer = {
      	cmd = { 'rust-analyzer' },
      	filetypes = { 'rust' },
      	root_dir = vim.fs.root(0, { 'Cargo.toml', '.git' }),
      	settings = {
      		['rust-analyzer'] = {
      			cargo = {
      				allFeatures = true,
      			},
      		},
      	},
      }

      -- ruby LSP
      vim.lsp.config.ruby_lsp = {
      	cmd = { 'ruby-lsp' },
      	filetypes = { 'ruby' },
      	root_dir = vim.fs.root(0, { 'Gemfile', '.git' }),
      }

      -- YAML LSP
      vim.lsp.config.yamlls = {
      	cmd = { 'yaml-language-server', '--stdio' },
      	filetypes = { 'yaml', 'yaml.docker-compose' },
      	root_dir = vim.fs.root(0, { '.git' }),
      }

      -- Zig LSP
      vim.lsp.config.zls = {
      	cmd = { 'zls' },
      	filetypes = { 'zig', 'zir' },
      	root_dir = vim.fs.root(0, { 'build.zig', '.git' }),
      }

      -- Python LSP (pylsp)
      vim.lsp.config.pylsp = {
      	cmd = { 'pylsp' },
      	filetypes = { 'python' },
      	root_dir = vim.fs.root(0, { 'pyproject.toml', 'setup.py', '.git' }),
      }

      -- Set up on_attach for all LSP servers
      vim.api.nvim_create_autocmd('LspAttach', {
      	callback = function(args)
      		set_cmn_lsp_keybinds()
      	end,
      })

    '';
}
