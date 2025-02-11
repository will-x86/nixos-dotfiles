local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
    "folke/lazy.nvim",
    {
        "anurag3301/nvim-platformio.lua",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        }
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'alexghergh/nvim-tmux-navigation',
        lazy = true,
        event = "VeryLazy",
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    {
        'xiyaowong/transparent.nvim',
        config = function()
            require("transparent").setup({
                extra_groups = {
                    "NormalFloat"
                },
            })
        end
    },
    'folke/tokyonight.nvim',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,
                highlight = { enable = true },
            }
        end
    },
    'MunifTanjim/prettier.nvim',
    {
        'yetone/avante.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            }
        },
        config = function()
            require('avante').setup({
                provider = "claude",
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-3-5-sonnet-latest",
                    temperature = 0,
                    max_tokens = 8192,
                },
                windows = {
                    width = 40,
                },
            })
        end,
        build = 'make', -- Optional, only if you want to use tiktoken_core to calculate tokens count
    },
    'nvim-treesitter/playground',
    {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
},
    'folke/zen-mode.nvim',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        }
    }
})

require("will-x86")
