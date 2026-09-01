local mod = "SUPER"
local shift = "SUPER + SHIFT"
local s = SCRIPTS

local locked = { locked = true }
local locked_r = { locked = true, repeating = true }

local function audio(command, notification)
	return function()
		hl.dispatch(hl.dsp.exec_cmd(command))
		hl.notification.create({ text = notification, timeout = 1000, icon = "info" })
	end
end

-- Apps
-- Tmux sessioniser by default
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(s.kitty .. " -T"))
-- Normal kitty
hl.bind(mod .. " + T", hl.dsp.exec_cmd(s.kitty))
hl.bind(mod .. " + X", hl.dsp.exec_cmd(s.wlogout))
hl.bind(mod .. " + A", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd(s.colorpicker))
hl.bind(mod .. " + escape", hl.dsp.exec_cmd("hyprlock"))

-- Launcher (released SUPER)
hl.bind(mod .. " + SUPER_L", hl.dsp.exec_cmd(s.rofi), { release = true })

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
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(s.backlight .. " --inc"), locked_r)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(s.backlight .. " --dec"), locked_r)
hl.bind("XF86AudioRaiseVolume", audio(
	"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", "Volume +5%"
), locked_r)
hl.bind("XF86AudioLowerVolume", audio(
	"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", "Volume -5%"
), locked_r)
hl.bind("XF86AudioMute", audio(
	"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", "Volume mute toggled"
), locked)
hl.bind("XF86AudioMicMute", audio(
	"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", "Microphone mute toggled"
), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), locked)
