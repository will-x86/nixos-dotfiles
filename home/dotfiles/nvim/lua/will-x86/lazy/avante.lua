return {
}
--[[return {
	"yetone/avante.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
				code = { sign = true, border = "thin" },
				latex = { enabled = false },
				pipe_table = { style = "normal" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function()
		require("avante").setup({
			provider = "claude",
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-latest",
				temperature = 0,
				max_tokens = 8192,
			},
			hints = { enabled = false },
			windows = {
				width = 40,
			},
		})
	end,
	build = "make", -- Optional, only if you want to use tiktoken_core to calculate tokens count
}]]--
