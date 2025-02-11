return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "VonHeikemen/lsp-zero.nvim",
        "MunifTanjim/prettier.nvim",
        "normen/vim-platformio",
    },
    config = function()
        local lsp = require("lsp-zero")
        local cmp = require('cmp')
        --local nvim_lsp = require('lspconfig')

        -- Set up mason
        require("mason").setup({ PATH = "append" })

        -- Format on save setup
        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        local function lsp_format_on_save(bufnr)
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                    filter = function(client)
                        return client.name == "null-ls"
                    end
                end,
            })
        end

        -- NixOS detection
        local is_nixos = (function()
            if vim.loop.os_uname().sysname == "Linux" then
                local file = io.open("/etc/os-release", "r")
                if file then
                    local content = file:read("*all")
                    file:close()
                    return string.find(content, "ID=nixos") and true or false
                end
            end
            return false
        end)()

        -- LSP servers setup
        local ensure_installed = is_nixos and {} or {
            'denols', 'gopls', 'volar', 'clangd', 'rust_analyzer',
            'yamlls', 'pyright', 'lua-ls', 'hls'
        }

        require('mason-lspconfig').setup({
            ensure_installed = ensure_installed,
            handlers = { lsp.default_setup }
        })

        -- NixOS specific configurations
        if is_nixos then
            -- Your NixOS specific LSP configurations here
            local nixos_configs = {
                clangd = { cmd = { "/etc/profiles/per-user/will/bin/clangd" } },
                pyright = {},
                rust_analyzer = {
                    on_attach = function(client, bufnr)
                        lsp.default_setup(client, bufnr)
                        lsp_format_on_save(bufnr)
                    end
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' }
                            }
                        }
                    }
                },
                hls = {},
                gopls = {
                    settings = {
                        gopls = { gofumpt = true }
                    }
                }
            }

            for server, config in pairs(nixos_configs) do
                require('lspconfig')[server].setup(config)
            end
        end

        -- Completion setup
        local cmp_mappings = {
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-f>'] = lsp.cmp_action().luasnip_jump_forward(),
            ['<C-b>'] = lsp.cmp_action().luasnip_jump_backward(),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ['<C-i>'] = cmp.mapping.confirm({ select = true }),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }

        cmp.setup({
            mapping = cmp.mapping(cmp_mappings),
        })

        -- Disable completion for specific filetypes
        cmp.setup.filetype('sql', { enabled = false })

        -- LSP preferences and keymaps
        lsp.set_preferences({
            suggest_lsp_servers = false,
            sign_icons = {
                error = 'E',
                warn = 'W',
                hint = 'H',
                info = 'I'
            }
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

            -- Your keymaps here
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<C-o>", [[<Cmd>lua vim.cmd('normal! <C-O>')<CR>]], opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end)

        lsp.setup()

        vim.diagnostic.config({ virtual_text = true })
    end
}

