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
        "VonHeikemen/lsp-zero.nvim",
        "anurag3301/nvim-platformio.lua",
        "MunifTanjim/eslint.nvim",
        "windwp/nvim-ts-autotag",

    },
    config = function()
        local lsp = require("lsp-zero")
        local cmp = require('cmp')
        local cmp_action = lsp.cmp_action()
        local eslint = require("eslint");
        require("conform").setup({
            formatters_by_ft = {
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

                        -- Keep your existing formats
                    },
                    format_on_save = {
                        timeout_ms = 500,
                        lsp_fallback = true,
                    },
                })
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        require("mason").setup({
            PATH = "append",
            ensure_installed = {
                -- Add React/Next.js related tools
                "eslint_d",
                "prettierd",
                "tailwindcss-language-server",
                "ts_ls", -- TypeScript/JavaScript server
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
            'yamlls', 'pyright', 'lua_ls', 'hls', 'ts_ls',
            'tailwindcss', 'eslint', 'cssls', 'html',
            'emmet_ls', 'rustfmt'
        }

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require('mason-lspconfig').setup({
            ensure_installed = ensure_installed,
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            lsp.default_setup(client, bufnr)
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
                    location = "separate_line", -- or `same_line`
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
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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
                    -- Disable formatting by Volar since we're using Prettier
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    -- Your existing on_attach logic
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            })
            require 'lspconfig'.clangd.setup {
                cmd = {
                    "/etc/profiles/per-user/will/bin/clangd",
                    "--background-index",
                },

                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = require("lspconfig.util").root_pattern(".git", "platformio.ini"),
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }
            require 'lspconfig'.pyright.setup {}
            require('lspconfig').jdtls.setup {
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end
            }
            require 'lspconfig'.rust_analyzer.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end
            }
            require 'lspconfig'.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                'vim',
                            },
                        },
                    },
                },
            }
            require 'lspconfig'.hls.setup {}
            require('lspconfig').gopls.setup({
                capabilities = capabilities,
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
            require 'lspconfig'.ts_ls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
                root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
            }

            require 'lspconfig'.tailwindcss.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }

            require 'lspconfig'.eslint.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }

            require 'lspconfig'.cssls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
            }
        end

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = {
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-f>'] = cmp_action.luasnip_jump_forward(),
            ['<C-b>'] = cmp_action.luasnip_jump_backward(),
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-i>'] = cmp.mapping.confirm({ select = true }),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }

        cmp.setup({
            mapping = cmp.mapping(cmp_mappings),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            }),
        })

        local disable_lsp_filetypes = { sql = true, mysql = true }
        lsp.on_attach(function(client, bufnr)
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

            if disable_lsp_filetypes[filetype] then
                client.stop()
                return
            end
            local opts = { buffer = bufnr, remap = false }
            lsp_format_on_save(bufnr)
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
        end)

        lsp.setup()

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
