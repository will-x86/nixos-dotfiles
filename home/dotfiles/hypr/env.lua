local home = os.getenv("HOME")
_G.SCRIPTS = {
	kitty = home .. "/.config/hypr/scripts/kitty",
	colorpicker = home .. "/.config/hypr/scripts/colorpicker",
	notify = "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low",
}

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
