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
		end,
	},
	--[[
	{
		"oxfist/night-owl.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			require("night-owl").setup()
			vim.o.termguicolors = true
			vim.opt.background = "dark"
			vim.cmd.colorscheme("night-owl")
		end,
	},]]
	--
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat",
				},
			})
			vim.cmd("TransparentEnable")
		end,
	},
}
