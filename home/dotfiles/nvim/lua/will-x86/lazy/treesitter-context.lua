return {
	"nvim-treesitter/nvim-treesitter-context",
	config = function()
		require("treesitter-context").setup({
			enable = true,
			multiwindow = false,
			max_lines = 3, -- def 0
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 3, -- def (20) Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		})
	end,
	vim.keymap.set("n", "]c", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { silent = true }),
}
--[["folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup {
            window = {
                width = 90,
                options = {
                    number = true,
                    relativenumber = true,
                }
            },
        }
        vim.keymap.set("n", "<leader>zz", function()
            require("zen-mode").toggle()
            vim.wo.wrap = false
        --    ColorMyPencils()
            vim.cmd("TransparentEnable")
        end)
    end
}]]
--
