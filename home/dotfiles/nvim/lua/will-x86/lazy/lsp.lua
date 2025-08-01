-- lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"stevearc/conform.nvim",
			--"Aietes/esp32.nvim",
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
		},
		--[[opts = function(_, opts)
			local esp32 = require("esp32")
			opts.servers = opts.servers or {}
			opts.servers.clangd = esp32.lsp_config()
			return opts
		end,]]
		--
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofumpt", "goimports" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					svelte = { "prettier" },
					markdown = { "prettier" },
					rust = { "rustfmt", lsp_format = "fallback" },
					zig = { "zigfmt" },
					cpp = { "clang_format" },
					vue = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					nix = { "nixfmt" },
					yaml = { "yamlfix" },
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf, async = true })
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
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
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
			end

			-- ESP32 clangd setup
			--local esp32 = require("esp32")
			--local clangd_config = esp32.lsp_config()
			--clangd_config.capabilities = capabilities
			--clangd_config.on_attach = on_attach
			--lspconfig.clangd.setup(clangd_config)
			--root_dir = util.root_pattern('.clangd', 'sdkconfig', '.git'),
			local esp_idf_path = os.getenv("IDF_PATH")
			local clangd_nix = os.getenv("CLANGD_IDF_PATH")
			local pio_query = os.getenv("PIO_QUERY")
			local pio_test = os.getenv("PIO_TEST")
			if esp_idf_path then
				-- for esp-idf
				require("lspconfig").clangd.setup({
					-- handlers = handlers,
					capabilities = capabilities,
					cmd = { clangd_nix, "--background-index", "--query-driver=**" },
					root_dir = function()
						-- leave empty to stop nvim from cd'ing into ~/ due to global .clangd file
					end,
				})
			elseif pio_test then
				require("lspconfig").clangd.setup({
                        on_attach = on_attach,
    capabilities = capabilities,
                })
			elseif pio_query then
				local home = os.getenv("HOME")
				require("lspconfig").clangd.setup({
					-- handlers = handlers,
					capabilities = capabilities,
					cmd = {
						clangd_nix,
						"--background-index",
						"--query-driver="
							.. home
							.. "/.platformio/**/bin/*-g++,"
							.. home
							.. "/.platformio/**/bin/*-gcc",
						"--log=verbose",
					},
					root_dir = lspconfig.util.root_pattern("platformio.ini", ".git"),
				})
			else
				-- clangd config
				require("lspconfig").clangd.setup({
					-- cmd = { 'clangd', "--background-index", "--clang-tidy"},
					handlers = {
						["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
							disable = { "cpp copyright" },
						}),
					},
				})
			end
			-- Other LSP servers
			lspconfig.kotlin_language_server.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "kotlin", "kt", "kts" },
			})

			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = lspconfig.util.root_pattern("package.json", ".git"),
			})

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

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

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

			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						completeUnimported = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

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
				root_dir = lspconfig.util.root_pattern(".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json"),
			})

			lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })

			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-Space>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			vim.diagnostic.config({
				virtual_text = true,
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
	},
}
