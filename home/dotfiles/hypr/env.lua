local home = os.getenv("HOME")
_G.SCRIPTS = {
	kitty = home .. "/.config/hypr/scripts/kitty",
}

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
