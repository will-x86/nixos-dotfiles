local home = os.getenv("HOME")
_G.SCRIPTS = {
	kitty = home .. "/.config/hypr/scripts/kitty",
	backlight = home .. "/.config/hypr/scripts/brightness",
	colorpicker = home .. "/.config/hypr/scripts/colorpicker",
	wlogout = "wlogout -b 4 -m 260px",
	rofi = "rofi -show drun",
	notify = "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low",
}
