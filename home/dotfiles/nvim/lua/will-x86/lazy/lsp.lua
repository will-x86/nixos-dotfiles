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
        "MunifTanjim/prettier.nvim",
        "anurag3301/nvim-platformio.lua",
    },
    config = function()
        local lsp = require("lsp-zero")
        local cmp = require('cmp')
        local cmp_action = lsp.cmp_action()
        local prettier = require("prettier")
        --local nvim_lsp = require('lspconfig')

        -- Mason setup
        require("mason").setup({ PATH = "append" })
        -- Remove this section as we're setting capabilities in the mason-lspconfig setup
        -- Format on save setup

        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        local lsp_format_on_save = function(bufnr)
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end

        -- NixOS detection
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

        -- LSP servers setup
        local ensure_installed = is_nixos and {} or {
            'gopls', 'volar', 'clangd', 'rust_analyzer',
            'yamlls', 'pyright', 'lua_ls', 'hls', 'ts_ls'
        }

        -- Set up default capabilities for all LSP servers
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

        -- NixOS specific LSP configurations
        if is_nixos then
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
            --[[require 'lspconfig'.ccls.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp.default_setup(client, bufnr)
                    lsp_format_on_save(bufnr)
                end,
                init_options = {
                    cache = {
                        directory = ".ccls-cache",
                    },
                    clang = {
                        extraArgs = { "-std=c++17" },
                        excludeArgs = { "-frounding-math" },
                    },
                    formatting = {
                        command = { "clang-format" },
                    },
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
            })
            ]] --
            require 'lspconfig'.rust_analyzer.setup {
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

            -- TypeScript/React Native setup
            require('lspconfig').ts_ls.setup({
                filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
                root_dir = require('lspconfig.util').root_pattern("package.json", "tsconfig.json", ".git"),
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            })
        end

        -- Prettier setup
        prettier.setup({
            bin = 'prettier',
            filetypes = {
                "css", "graphql", "html", "javascript", "javascriptreact",
                "json", "less", "scss", "typescript", "typescriptreact", "yaml",
            },
            cli_options = {
                arrow_parens = "always",
                bracket_spacing = true,
                bracket_same_line = false,
                embedded_language_formatting = "auto",
                end_of_line = "lf",
                html_whitespace_sensitivity = "css",
                jsx_bracket_same_line = false,
                jsx_single_quote = false,
                print_width = 80,
                prose_wrap = "preserve",
                quote_props = "as-needed",
                semi = true,
                single_quote = false,
                tab_width = 2,
                trailing_comma = "es5",
                use_tabs = false,
            },
        })

        -- Completion setup
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

        -- LSP preferences and keymaps
        --lsp.set_preferences({
        --suggest_lsp_servers = false,
        --sign_icons = {
        --error = 'E', warn = 'W', hint = 'H', info = 'I'
        --}
        --})

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

        -- Diagnostic configuration
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
