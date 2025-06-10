return {
		"Aietes/esp32.nvim",
		dependencies = {
			"folke/snacks.nvim", -- esp32.nvim depends on this
		},
		opts = {
			build_dir = "build.clang",
		},
}

