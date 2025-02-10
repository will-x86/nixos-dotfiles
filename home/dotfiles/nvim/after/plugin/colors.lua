function _G.ColorMyPencils()
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("tokyonight")
    vim.cmd("TransparentEnable")
end

ColorMyPencils()
