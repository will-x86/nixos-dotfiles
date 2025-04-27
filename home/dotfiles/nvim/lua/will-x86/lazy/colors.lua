return {
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.opt.background = "dark"
            vim.cmd("colorscheme tokyobones")
        end
    },
    {
        'xiyaowong/transparent.nvim',
        dependencies = "zenbones-theme/zenbones.nvim",
        config = function()
            require("transparent").setup({
                extra_groups = {
                    "NormalFloat"
                },
            })
            vim.cmd("TransparentEnable")
        end
    },
}
