--[[return {
}]]--
return {
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
            provider = "ollama",
            ollama = {
                endpoint = "http://100.74.103.8:11434",
                model = "deepseek-coder-v2:16b",
                temperature = 1,
                max_tokens = 1000000,
            },
            windows = {
                width = 40,
            },
        })
    end,
    build = 'make', -- Optional, only if you want to use tiktoken_core to calculate tokens count
}
