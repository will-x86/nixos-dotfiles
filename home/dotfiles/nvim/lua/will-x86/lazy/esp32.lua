-- esp32.lua
--[[return {
	{
		"Aietes/esp32.nvim",
		lazy = false, -- Load immediately to ensure it's available for LSP config
		priority = 100, -- Load before LSP config
		dependencies = {
			"folke/snacks.nvim",
		},
		opts = {
			build_dir = "build.clang",
		},
		keys = {
			-- Monitor commands
			{
				"<leader>RM",
				function()
					require("esp32").pick("monitor")
				end,
				desc = "ESP32: Pick & Monitor",
			},
			{
				"<leader>Rm",
				function()
					require("esp32").command("monitor")
				end,
				desc = "ESP32: Monitor",
			},
			-- Flash commands
			{
				"<leader>RF",
				function()
					require("esp32").pick("flash")
				end,
				desc = "ESP32: Pick & Flash",
			},
			{
				"<leader>Rf",
				function()
					require("esp32").command("flash")
				end,
				desc = "ESP32: Flash",
			},
			-- Build and configuration
			{
				"<leader>Rb",
				function()
					require("esp32").command("build")
				end,
				desc = "ESP32: Build",
			},
			{
				"<leader>Rc",
				function()
					require("esp32").command("menuconfig")
				end,
				desc = "ESP32: Configure",
			},
			{
				"<leader>RC",
				function()
					require("esp32").command("clean")
				end,
				desc = "ESP32: Clean",
			},
			-- Project management
			{ "<leader>Rr", ":ESPReconfigure<CR>", desc = "ESP32: Reconfigure project" },
			{ "<leader>Ri", ":ESPInfo<CR>", desc = "ESP32: Project Info" },
		},
	},
}]]--
