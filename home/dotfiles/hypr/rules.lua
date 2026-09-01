hl.window_rule({
	name = "float-utilities",
	match = {
		class = "^(yad|nm-connection-editor|pavucontrol|xfce-polkit|kvantummanager|qt5ct|feh|Viewnior|Gpicview|Gimp|MPlayer|bt-manager|wifi-manager)$",
	},
	float = true,
})

hl.layer_rule({
	name = "noctalia-surfaces",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},
	no_anim = true,
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.5,
})

hl.window_rule({
	name = "noctalia-settings",
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})
