require("monitors")
require("autostart")
require("env")
require("colors")

require("general")
require("decoration")
require("animations")

require("input")
require("gestures")

require("misc")
require("xwayland")

require("binds")
require("rules")

-- Noctalia generates this module from the active wallpaper. Keep the static
-- colors above as a safe fallback during the first session startup.
local theme_ok, noctalia_theme = pcall(require, "noctalia")
if theme_ok then
	noctalia_theme.apply_theme()
end
