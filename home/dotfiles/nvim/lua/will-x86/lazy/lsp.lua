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
        "anurag3301/nvim-platformio.lua",
        "MunifTanjim/eslint.nvim",
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local cmp = require('cmp')
        local eslint = require("eslint")

        -- Reserve space in the gutter
        vim.opt.signcolumn = 'yes'

        -- Add borders to floating windows
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )

        -- Setup capabilities
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        require("conform").setup({
            formatters_by_ft = {
                javascript = { "prettier", "eslint" },
                typescript = { "prettier", "eslint" },
                javascriptreact = { "prettier", "eslint" },
                typescriptreact = { "prettier", "eslint" },
                jsx = { "prettier", "eslint" },
                tsx = { "prettier", "eslint" },
                vue = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                rust = { "rustfmt" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        require("mason").setup({
            PATH = "append",
            ensure_installed = {
                "eslint_d",
                "prettierd",
                "tailwindcss-language-server",
                "typescript-language-server",
                "css-lsp",
                "html-lsp",
                "emmet-ls",
            }
        })

        require('nvim-ts-autotag').setup()

        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        local lsp_format_on_save = function(bufnr)
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    require("conform").format({ bufnr = bufnr })
                end,
            })
        end

        local system_name = vim.loop.os_uname().sysname
        local is_nixos = false
        if system_name == "Linux" then
            local file = io.open("/etc/os-release", "r")
            if file then
                local content = file:read("*all")
                file:close()
                if string.find(content, "ID=nixos") then
                    is_nixos = true
                end
            end
        end

        local ensure_installed = is_nixos and {} or {
            'gopls', 'volar', 'clangd', 'rust_analyzer',
            'yamlls', 'pyright', 'lua_ls', 'hls', 'typescript-language-server',
            'tailwindcss', 'eslint', 'cssls', 'html',
            'emmet_ls', 'rustfmt'
        }

        require('mason-lspconfig').setup({
            ensure_installed = ensure_installed,
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = lspconfig_defaults.capabilities,
                        on_attach = function(client, bufnr)
                            lsp_format_on_save(bufnr)
                        end
                    })
                end
            }
        })

        eslint.setup({
            bin = 'eslint',
            code_actions = {
                enable = true,
                apply_on_save = {
                    enable = true,
                    types = { "directive", "problem", "suggestion", "layout" },
                },
                disable_rule_comment = {
                    enable = true,
                    location = "separate_line",
                },
            },
            diagnostics = {
                enable = true,
                report_unused_disable_directives = false,
                run_on = "type",
            },
        })

        require('java').setup()

        if is_nixos then
            require('lspconfig').volar.setup({
                filetypes = { 'typescript', 'javascript', 'vue', 'json' },
                init_options = {
                    languageFeatures = {
                        implementation = true,
                        references = true,
                        definition = true,
                        typeDefinition = true,
                        callHierarchy = true,
                        hover = true,
                        rename = true,
                        renameFileRefactoring = true,
                        signatureHelp = true,
                        codeAction = true,
                        workspaceSymbol = true,
                        completion = {
                            defaultTagNameCase = 'both',
                            defaultAttrNameCase = 'kebabCase',
                            getDocumentNameCasesRequest = false,
                            getDocumentSelectionRequest = false,
                        },
                    },
                    documentFeatures = {
                        selectionRange = true,
                        foldingRange = true,
                        linkedEditingRange = true,
                        documentSymbol = true,
                        documentColor = true,
                        documentFormatting = {
                            defaultPrintWidth = 100,
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    lsp_format_on_save(bufnr)
                end,
            })

            require('lspconfig').clangd.setup {
                cmd = {
                    "/etc/profiles/per-user/will/bin/clangd",
                    "--background-index",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = require("lspconfig.util").root_pattern(".git", "platformio.ini"),
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }

            require('lspconfig').pyright.setup {}

            require('lspconfig').jdtls.setup {
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end
            }

            require('lspconfig').rust_analyzer.setup {
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end
            }

            require('lspconfig').lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            }

            require('lspconfig').hls.setup {}

            require('lspconfig').gopls.setup({
                capabilities = lspconfig_defaults.capabilities,
                init_options = {
                    usePlaceholders = true,
                },
                settings = {
                    gopls = {
                        allExperiments = true,
                        usePlaceholders = true,
                        gofumpt = true,
                        analyses = {
                            nilness = true,
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                    },
                },
                flags = {
                    debounce_text_changes = 150,
                },
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gotmpl" },
                single_file_support = true,
            })

            require('lspconfig').tsserver.setup {
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
                root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
            }

            require('lspconfig').tailwindcss.setup {
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }

            require('lspconfig').eslint.setup {
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }

            require('lspconfig').cssls.setup {
                capabilities = lspconfig_defaults.capabilities,
                on_attach = function(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }
        end

        -- LSP Attach keymaps and settings
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "<C-o>", [[<Cmd>lua vim.cmd('normal! <C-O>')<CR>]], opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end,
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = {
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-i>'] = cmp.mapping.confirm({ select = true }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
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
    end
}
