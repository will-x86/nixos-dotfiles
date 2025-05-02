return {
    {
        --"zenbones-theme/zenbones.nvim",
        "arcticicestudio/nord-vim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.opt.background = "dark"
            vim.cmd("colorscheme nord")
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
            vim.cmd("TransparentEnable")
        end
    },
}
