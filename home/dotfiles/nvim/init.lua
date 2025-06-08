vim.g.mapleader = " "

require("will-x86")

require("Arduino-Nvim.lsp").setup()

-- Set up Arduino file type detection
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        require("Arduino-Nvim")
    end
})
