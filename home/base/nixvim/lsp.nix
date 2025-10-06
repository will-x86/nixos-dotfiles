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
      -- Extra nvim-lspconfig configuration
      -- Common LSP key mappings
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
      			key = "vrr", -- Changed from original "gr" to avoid conflict with `vrn`
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

      -- Additional lsp-config
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Individual LSP configs
      -- asm LSP
      vim.lsp.config.asm_lsp.setup({
      	capabilities = capabilities,
      	filetypes = { "asm" },

      	-- Fix for missing root dir
      	root_dir = function(fname)
      		return vim.loop.cwd()
      	end,
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Bash LSP
      vim.lsp.config.bashls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })


      -- ccls LSP
      vim.lsp.config.ccls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
      -- clang LSP
      --[[vim.lsp.config.clangd.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })]]--

      -- cmake LSP
      vim.lsp.config.cmake.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- CSS LSP
      vim.lsp.config.cssls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- eslitn LSP
      vim.lsp.config.eslint.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- golang lsp
      vim.lsp.config.gopls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- HTML lsp
      vim.lsp.config.html.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- JSON lsp
      vim.lsp.config.jsonls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Lua LSP
      vim.lsp.config.lua_ls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Markdown LSP
      vim.lsp.config.marksman.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Nix LSP
      vim.lsp.config.nixd.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      	settings = {
      		nixd = {
      			formatting = {
      				command = { "nixfmt" },
      			},
      		},
      	},
      })


      -- Python LSP
      vim.lsp.config.ruff.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Rust LSP
      vim.lsp.config.rust_analyzer.setup({
      	root_dir = function(fname)
      		return vim.loop.cwd()
      	end,
      	settings = {
      		['rust-analyzer'] = {
      			cargo = {
      				allFeatures = true,
      			},
      		},
      	},
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- ruby LSP
      vim.lsp.config.ruby_lsp.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
      -- YAML LSP
      vim.lsp.config.yamlls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Zig LSP
      vim.lsp.config.zls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
    '';
}
