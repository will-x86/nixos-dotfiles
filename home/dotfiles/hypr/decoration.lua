hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 8,
		border_size = 2,
		extend_border_grab_area = 10,
		resize_on_border = true,
		col = {
			active_border = {
				colors = { LGREEN, DGREEN },
				angle = 45,
			},
			inactive_border = GRAY,
		},
	},
	group = {
		col = {
			border_active = LBLUE,
			border_inactive = GRAY,
			border_locked_active = DBLUE,
			border_locked_inactive = GRAY,
		},
		groupbar = {
			col = {
				active = LGREEN,
				inactive = GRAY,
				locked_active = DBLUE,
				locked_inactive = GRAY,
			},
		},
	},
	decoration = {
		dim_special = 0.3,
		rounding = 10,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
		fullscreen_opacity = 1,
		blur = {
			size = 5,
			passes = 4,
			special = true,
		},
	},
})
