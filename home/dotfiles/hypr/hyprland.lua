require("monitors")
require("autostart")
require("env")

require("general")
require("decoration")
require("animations")

require("input")
require("gestures")

require("misc")
require("xwayland")

require("binds")
require("rules")

local theme_ok, noctalia_theme = pcall(require, "noctalia")
if theme_ok then
	noctalia_theme.apply_theme()
end
