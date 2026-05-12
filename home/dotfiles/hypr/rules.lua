hl.window_rule({
	name = "float-utilities",
	match = {
		class = "^(yad|nm-connection-editor|pavucontrol|xfce-polkit|kvantummanager|qt5ct|feh|Viewnior|Gpicview|Gimp|MPlayer|bt-manager|wifi-manager)$",
	},
	float = true,
})

hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.0, blur_popups = true })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, animation = "popin 95%" })
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.0,
	animation = "popin 95%",
})
hl.layer_rule({
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0.0,
	animation = "popin 95%",
})
hl.layer_rule({
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0.0,
	animation = "slide",
})
