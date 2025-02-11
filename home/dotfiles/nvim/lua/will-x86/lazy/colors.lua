function _G.ColorMyPencils()
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("tokyonight")
    vim.cmd("TransparentEnable")
end

--ColorMyPencils()

return {

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()
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

}
