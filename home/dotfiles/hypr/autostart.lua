-- autostart.lua

hl.on("hyprland.start", function()
  hl.exec_cmd("udiskie")

  -- Workspace-pinned launches (previously exec-once=[workspace N silent] ...)
  hl.exec_cmd("[workspace 1 silent] " .. os.getenv("HOME") .. "/.config/hypr/scripts/kitty -T")
  hl.exec_cmd("[workspace 8 silent] 1password")
end)
