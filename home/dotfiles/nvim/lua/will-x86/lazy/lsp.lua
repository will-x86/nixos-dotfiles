return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"williamboman/mason.nvim", -- ONLY used for finding lsp servers
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofumpt", "goimports" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt", lsp_format = "fallback" },
				zig = { "zigfmt" },
				javascript = { "eslint_d", "prettier" },
				javascriptreact = { "eslint_d", "prettier" },
				typescript = { "eslint_d", "prettier" },
				typescriptreact = { "eslint_d", "prettier" },
				vue = { "eslint_d", "prettier" },
				nix = { "nixfmt" },
				yaml = { "yamlfix" },
			},
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf, async = false })
			end,
		})
		require("mason").setup()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})

		local lspconfig = require("lspconfig")
		local on_attach = function(client, bufnr)
			-- Define keymap options
			local opts = { buffer = bufnr, remap = false }

			-- Set your keymaps (exactly as provided)
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "<C-o>", [[<Cmd>lua vim.cmd('normal! <C-O>')<CR>]], opts) -- Keep original mapping exactly
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>vws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, opts)
			-- NOTE: Your original mappings for [d and ]d were swapped compared to common usage.
			-- Keeping them exactly as you provided:
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_next()
			end, opts) -- Usually previous
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_prev()
			end, opts) -- Usually next
			vim.keymap.set("n", "<leader>vca", function()
				vim.lsp.buf.code_action()
			end, opts)
			vim.keymap.set("n", "<leader>vrr", function()
				vim.lsp.buf.references()
			end, opts)
			vim.keymap.set("n", "<leader>vrn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)

			-- Note: lsp_format_on_save(bufnr) was removed as it's not defined
			-- and formatting is handled by the conform autocmd above.
		end
		-- TypeScript
		--
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			init_options = { hostInfo = "neovim" },
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			single_file_support = true,
		})
		--yaml
		lspconfig.yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- nix
		lspconfig.nil_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["nil"] = {
					formatting = {
						command = { "nixfmt" },
					},
				},
			},
		})
		-- Go
		lspconfig.gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					usePlaceholders = true, -- enables parameter completion
					completeUnimported = true,
					analyses = {
						unusedparams = true,
					},
				},
			},
		})
		-- Zig
		lspconfig.zls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
			settings = {
				zls = {
					enable_inlay_hints = true,
					enable_snippets = true,
					warn_style = true,
				},
			},
		})
		vim.g.zig_fmt_parse_errors = 0
		vim.g.zig_fmt_autosave = 0

		-- Lua
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
				},
			},
		})
		lspconfig.eslint.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = lspconfig.util.root_pattern(
				"package.json",
				".git",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.json"
			),
		})
		lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
		lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
		lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-Space>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			virtual_text = true,
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}

--[[require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tsserver.setup({
                        capabilities = capabilities,
                        init_options = { hostInfo = 'neovim' },
                        cmd = { 'typescript-language-server', '--stdio' },
                        filetypes = {
                            'javascript',
                            'javascriptreact',
                            'javascript.jsx',
                            'typescript',
                            'typescriptreact',
                            'typescript.tsx',
                        },
                        root_dir = lspconfig.util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
                        single_file_support = true,
                    })
                end,

                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                usePlaceholders = true,  -- enables parameter completion
                                completeUnimported = true,
                                analyses = {
                                    unusedparams = true,
                                },
                            },
                        },
                    })
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
            }
        })
        ]]
--
