{
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      bindm = SUPER, mouse:272, movewindow
      general {
      	border_size = 1
      	no_border_on_floating = false
      	gaps_in = 2
      	gaps_out = 5
      	gaps_workspaces = -10
        col.active_border = rgba(808080ee) rgba(808080ee) 45deg
      	col.inactive_border = 0xFF2a323b 0xFF353f4a 45deg
      	layout = dwindle
      	no_focus_fallback = false
      	resize_on_border = true
      	extend_border_grab_area = 15
      	hover_icon_on_border = true
      	allow_tearing = false
      }
      # This is for VM's
      # ALT + R = ignore all hyprland keybindings
      bind=ALT,R,submap,passthrough
      submap=passthrough
      bind=,escape,submap,reset
      submap=reset
      #END VM MAPPING
      decoration {
        rounding = 6
        active_opacity = 1
        inactive_opacity = 0.9

          blur {
            enabled = true
            size = 5
            passes = 2
            ignore_opacity = true
            popups = true
            new_optimizations = true
            noise = 0.0200
            contrast = 1
            brightness = 0.8172
            vibrancy = 0.1696
          }

        shadow {
          enabled = true
          range = 20
          render_power = 4
          color = rgba(000000b3)
          ignore_window = true
        }
      }

      animations {
          enabled = yes

          bezier = wind, 0.05, 0.9, 0.1, 1.05
          bezier = winIn, 0.1, 1.1, 0.1, 1.1
          bezier = winOut, 0.3, -0.3, 0, 1
          bezier = liner, 1, 1, 1, 1
          animation = windows, 1, 6, wind, slide
          animation = windowsIn, 1, 6, winIn, slide
          animation = windowsOut, 1, 5, winOut, slide
          animation = windowsMove, 1, 5, wind, slide
          animation = border, 1, 1, liner
          animation = borderangle, 1, 30, liner, loop
          animation = fade, 1, 10, default
          animation = workspaces, 1, 5, wind
      }
      # Laptop shit idk
      exec-once = cat /proc/acpi/button/lid/LID0/state | grep closed && sleep 3 && hyprctl keyword monitor "eDP-1, disable" && notify-send "Laptop lid closed, disabling monitor"
      exec-once = kdeconnect-indicator
      exec-once = kdeconnectd
      bindl = , switch:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"
      bindl = , switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred,auto,1"
      input {
      	kb_model =
      	kb_layout =
      	kb_variant =
      	kb_options =
      	kb_rules =
      	kb_file =
      	numlock_by_default = false
      	repeat_rate = 25
      	repeat_delay = 600
          sensitivity = 1.5
      	accel_profile = flat
      	force_no_accel = false
      	left_handed = false
      	scroll_method = 2fg
      	scroll_button = 0
      	scroll_button_lock = 0
      	natural_scroll = false
      	follow_mouse = 1
      	mouse_refocus = true
      	float_switch_override_focus = 1
      	touchpad {
      		disable_while_typing = true
      		natural_scroll = false
      		scroll_factor = 1.0
      		middle_button_emulation = false
      		tap_button_map =
      		clickfinger_behavior = false
      		tap-to-click = true
      		drag_lock = false
      		tap-and-drag = true
      	}

      }

      gestures {
      	workspace_swipe = true
      	workspace_swipe_fingers = 3
      	workspace_swipe_distance = 300
      	workspace_swipe_invert = true
      	workspace_swipe_min_speed_to_force = 30
      	workspace_swipe_cancel_ratio = 0.5
      	workspace_swipe_create_new = true
      	workspace_swipe_direction_lock = true
      	workspace_swipe_direction_lock_threshold = 10
      	workspace_swipe_forever = false
      	workspace_swipe_use_r = false
      }


      misc {
      	disable_hyprland_logo = true
      	force_default_wallpaper = 0
      	vfr = on
      	background_color = 0x000000
      }


      xwayland {
      	use_nearest_neighbor = true
      	force_zero_scaling = false
      }



      monitor=eDP-1,2256x1504,0x0,1


      $notifycmd = notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low



      windowrulev2 = float,class:^(yad)$
      windowrulev2 = float,class:^(nm-connection-editor)$
      windowrulev2 = float,class:^(pavucontrol)$

      windowrulev2 = float,class:^(xfce-polkit)$
      windowrulev2 = float,class:^(kvantummanager)$
      windowrulev2 = float,class:^(qt5ct)$

      windowrulev2 = float,class:^(feh)$
      windowrulev2 = float,class:^(Viewnior)$
      windowrulev2 = float,class:^(Gpicview)$
      windowrulev2 = float,class:^(Gimp)$
      windowrulev2 = float,class:^(MPlayer)$

      $kitty= ~/.config/hypr/scripts/kitty
      $volume      = ~/.config/hypr/scripts/volume
      $backlight   = ~/.config/hypr/scripts/brightness
      $wlogout     = ~/.config/hypr/scripts/wlogout
      $colorpicker = ~/.config/hypr/scripts/colorpicker

      $rofi_launcher = rofi -show drun
      $wlogout= wlogout -b 4 -m 260px

      bind = SUPER, e, exec, $kitty -e lf

      bind = SUPER,       Return, exec, $kitty -T
      bind = SUPER_SHIFT, w, exec,  $kitty -W
      bind = SUPER_SHIFT, Return, exec, $kitty -f
      bind = SUPER,       T,      exec, $kitty
      bind = SUPER_SHIFT, F, exec, XDG_CURRENT_DESKTOP=kde dolphin
      bindr = SUPER, SUPER_L, exec, $rofi_launcher



      bind = SUPER_SHIFT, V, exec, ~/.config/rofi/assets/clipManager.sh
      bind  = SUPER, O,exec, firefox -P "j" --new-instance
      bind  = SUPER, X,       exec, $wlogout
      bind  = SUPER, A,       exec, hyprshot -m region


      bind = SUPER,    P, exec, $colorpicker

      bind = ,XF86MonBrightnessUp,   exec, $backlight --inc
      bind = ,XF86MonBrightnessDown, exec, $backlight --dec
      bind = ,XF86AudioRaiseVolume,  exec, $volume --inc
      bind = ,XF86AudioLowerVolume,  exec, $volume --dec
      bind = ,XF86AudioMute,         exec, $volume --toggle
      bind = ,XF86AudioMicMute,      exec, $volume --toggle-mic
      bind = ,XF86AudioNext,         exec, playerctl next
      bind = ,XF86AudioPrev,         exec, playerctl previous
      bind = ,XF86AudioPlay,         exec, playerctl play-pause
      bind = ,XF86AudioStop,         exec, playerctl stop



      bind = SUPER,       Q,      killactive,
      bind = SUPER,       F,      fullscreen, 0
      bind = SUPER,       Space,  togglefloating,
      bind = SUPER,       Space,  centerwindow,

      # Change Focus
      bind = SUPER, h,  movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k,    movefocus, u
      bind = SUPER, j,  movefocus, d

      # Move Active
      bind = SUPER_SHIFT, h,  movewindow, l
      bind = SUPER_SHIFT, l, movewindow, r
      bind = SUPER_SHIFT, k,    movewindow, u
      bind = SUPER_SHIFT, j,  movewindow, d

      # Resize Active
      binde = SUPER_CTRL, h,  resizeactive, -20 0
      binde = SUPER_CTRL, l, resizeactive, 20 0
      binde = SUPER_CTRL, k,    resizeactive, 0 -20
      binde = SUPER_CTRL, j,  resizeactive, 0 20



      # Workspaces
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 0

      exec-once=[workspace 1 silent] $kitty -T
      exec-once=[workspace 2 silent] firefox
      exec-once=[workspace 3 silent] obsidian
      exec-once=[workspace 4 silent] bruno
      exec-once=[workspace 5 silent] beekeeper-studio
      exec-once=[workspace 8 silent] 1password
      exec-once=[workspace 9 silent] firefox -P "j" --new-instance

      # Send to Workspaces
      bind = SUPER_SHIFT, 1, movetoworkspace, 1
      bind = SUPER_SHIFT, 2, movetoworkspace, 2
      bind = SUPER_SHIFT, 3, movetoworkspace, 3
      bind = SUPER_SHIFT, 4, movetoworkspace, 4
      bind = SUPER_SHIFT, 5, movetoworkspace, 5
      bind = SUPER_SHIFT, 6, movetoworkspace, 6
      bind = SUPER_SHIFT, 7, movetoworkspace, 7
      bind = SUPER_SHIFT, 8, movetoworkspace, 8
      bind = SUPER_SHIFT, 9, movetoworkspace, 9
      bind = SUPER_SHIFT, 0, movetoworkspace, 0
      bind = SUPER, escape, exec, hyprlock


      #-- Startup ----------------------------------------------------
      exec-once=~/.config/hypr/scripts/startup
      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store
      exec-once = udiskie

        ## LAyer rules
        layerrule = blur, waybar
        layerrule = ignorezero, waybar
        layerrule = blurpopups, waybar

        layerrule = blur, logout_dialog
        layerrule = animation popin 95%, logout_dialog

        layerrule = blur, rofi
        layerrule = ignorezero, rofi
        layerrule = animation popin 95%, rofi
        layerrule = unset, rofi

        layerrule = blur, swaync-control-center
        layerrule = ignorezero, swaync-control-center
        layerrule = animation popin 95%, swaync-control-center

        layerrule = blur, swaync-notification-window
        layerrule = ignorezero, swaync-notification-window
        layerrule = animation slide, swaync-notification-window
    '';
  };
}
