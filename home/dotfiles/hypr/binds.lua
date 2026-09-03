local mod = "SUPER"
local shift = "SUPER + SHIFT"

local locked = { locked = true }
local locked_r = { locked = true, repeating = true }

-- Apps
-- Tmux sessioniser by default
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty -e " .. os.getenv("HOME") .. "/tmux-sessioniser"))
-- Normal kitty
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + X", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("noctalia msg plugin oldirtty/color_picker:service all pick"))
hl.bind(mod .. " + escape", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind(mod .. " + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))

-- Launcher (released SUPER)
hl.bind(mod .. " + SUPER_L", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { release = true })

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Windows
hl.bind(mod .. " + Q", hl.dsp.window.close())
-- normal full screen
hl.bind(shift .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
-- https://wiki.hypr.land/configuring/core/dispatchers/#fullscreen_state
-- mode = 1 means it keeps borders etc
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + Space", hl.dsp.window.center())

-- Focus (hjkl)
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move (hjkl)
hl.bind(shift .. " + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(shift .. " + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(shift .. " + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(shift .. " + j", hl.dsp.window.move({ direction = "d" }))

-- Workspaces
for i = 0, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(shift .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Media / brightness / volume
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), locked_r)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), locked_r)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), locked_r)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), locked_r)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), locked)
