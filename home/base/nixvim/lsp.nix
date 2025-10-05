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
        atopile.enable = false; # Fuck knows, some error about pkg not found
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
      require("lspconfig").asm_lsp.setup({
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
      require("lspconfig").bashls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })


      -- ccls LSP
      require("lspconfig").ccls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
      -- clang LSP
      --[[require("lspconfig").clangd.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })]]--

      -- cmake LSP
      require("lspconfig").cmake.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- CSS LSP
      require("lspconfig").cssls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- eslitn LSP
      require("lspconfig").eslint.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- golang lsp
      require("lspconfig").gopls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- HTML lsp
      require("lspconfig").html.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- JSON lsp
      require("lspconfig").jsonls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Lua LSP
      require("lspconfig").lua_ls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Markdown LSP
      require("lspconfig").marksman.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Nix LSP
      require("lspconfig").nixd.setup({
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
      require("lspconfig").ruff.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Rust LSP
      require("lspconfig").rust_analyzer.setup({
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
      require("lspconfig").ruby_lsp.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
      -- YAML LSP
      require("lspconfig").yamlls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Zig LSP
      require("lspconfig").zls.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })
    '';
}
