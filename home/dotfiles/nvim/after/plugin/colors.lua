local function ColorMyPencils()
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("tokyonight")
end

ColorMyPencils()
