hl.config({
	general = {
		border_size = 1,
		gaps_in = 2,
		gaps_out = 4,
		gaps_workspaces = -10,
		layout = "dwindle",
		no_focus_fallback = false,
		resize_on_border = true,
		extend_border_grab_area = 16,
		hover_icon_on_border = true,
		allow_tearing = false,

		col = {
			active_border = {
				colors = { "rgba(808080ee)", "rgba(808080ee)" },
				angle = 45,
			},
			inactive_border = {
				colors = { "0xFF2a323b", "0xFF353f4a" },
				angle = 45,
			},
		},
	},
})
