{
  config,
  secrets,
  pkgs,
  ...
}:
{

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "eDP-1, 2256x1504@60, 0x0, 1.25"
        "DP-4, 1920x1080@144, auto, 1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      "$kitty" = "~/.config/hypr/scripts/kitty";
      "$volume" = "~/.config/hypr/scripts/volume";
      "$backlight" = "~/.config/hypr/scripts/brightness";
      "$wlogout" = "~/.config/hypr/scripts/wlogout";
      "$colorpicker" = "~/.config/hypr/scripts/colorpicker";
      "$rofi_launcher" = "rofi -show drun";
      "$wlogout_cmd" = "wlogout -b 4 -m 260px";

      exec-once = [
        "~/.config/hypr/scripts/startup"
        "udiskie"
        "[workspace 1 silent] ${pkgs.kitty}/bin/kitty -T"
        "[workspace 2 silent] firefox"
        "[workspace 3 silent] obsidian"
        "[workspace 8 silent] 1password"
        # This handles the lid state on startup
        ''sh -c 'if cat /proc/acpi/button/lid/LID0/state | grep -q "closed"; then hyprctl keyword monitor "eDP-1, disable"; fi' ''
      ];

      general = {
        border_size = "expr:round(1 * $monitorSCALE)";
        gaps_in = "expr:round(2 * $monitorSCALE)";
        gaps_out = "expr:round(5 * $monitorSCALE)";
        gaps_workspaces = -10;

        "col.active_border" = "rgba(808080ee) rgba(808080ee) 45deg";
        "col.inactive_border" = "0xFF2a323b 0xFF353f4a 45deg";

        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = "expr:round(6 * $monitorSCALE)";
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        blur = {
          enabled = true;
          size = "expr:round(5 * $monitorSCALE)";
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = "expr:round(20 * $monitorSCALE)";
          render_power = 4;
          "col.shadow" = "rgba(000000b3)";
        };
      };

      animations = {
        enabled = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 1.5;
        accel_profile = "flat";
        touchpad = {
          disable_while_typing = true;
          natural_scroll = false;
          tap-to-click = true;
          tap-and-drag = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = "expr:round(300 * $monitorSCALE)";
      };

      misc = {
        focus_on_activate = true;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        vfr = "on";
      };

      windowrulev2 = [
        "float,class:^(yad)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(xfce-polkit)$"
        "float,class:^(kvantummanager)$"
        "float,class:^(qt5ct)$"
        "float,class:^(feh)$"
        "float,class:^(Viewnior)$"
        "float,class:^(Gpicview)$"
        "float,class:^(Gimp)$"
        "float,class:^(MPlayer)$"
      ];

      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
        "blur, rofi"
        "ignorezero, rofi"
        "blur, swaync-control-center"
        "ignorezero, swaync-control-center"
        "blur, swaync-notification-window"
        "ignorezero, swaync-notification-window"
      ];

      # -- Keybinds ----------------------------------------------------------
      bind = [
        "SUPER, e, exec, $kitty -e lf"
        "SUPER, Return, exec, $kitty -T"
        "SUPER, T, exec, $kitty"
        "SUPER, O, exec, firefox --new-tab ${secrets.owu}"
        "SUPER, B, exec, firefox --new-tab ${secrets.ha}"
        "SUPER, X, exec, $wlogout_cmd"
        "SUPER, A, exec, hyprshot -m region"
        "SUPER, P, exec, $colorpicker"
        ",XF86MonBrightnessUp, exec, $backlight --inc"
        ",XF86MonBrightnessDown, exec, $backlight --dec"
        ",XF86AudioRaiseVolume, exec, $volume --inc"
        ",XF86AudioLowerVolume, exec, $volume --dec"
        ",XF86AudioMute, exec, $volume --toggle"
        ",XF86AudioMicMute, exec, $volume --toggle-mic"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioStop, exec, playerctl stop"
        "SUPER, Q, killactive,"
        "SUPER, F, fullscreen, 0"
        "SUPER, Space, togglefloating,"
        "SUPER, Space, centerwindow,"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER_SHIFT, h, movewindow, l"
        "SUPER_SHIFT, l, movewindow, r"
        "SUPER_SHIFT, k, movewindow, u"
        "SUPER_SHIFT, j, movewindow, d"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 0"
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
        "SUPER_SHIFT, 6, movetoworkspace, 6"
        "SUPER_SHIFT, 7, movetoworkspace, 7"
        "SUPER_SHIFT, 8, movetoworkspace, 8"
        "SUPER_SHIFT, 9, movetoworkspace, 9"
        "SUPER_SHIFT, 0, movetoworkspace, 0"
        "SUPER, escape, exec, hyprlock"
        "ALT, R, submap, passthrough" # VM passthrough submap
      ];

      binde = [
        "SUPER_CTRL, h, resizeactive, -20 0"
        "SUPER_CTRL, l, resizeactive, 20 0"
        "SUPER_CTRL, k, resizeactive, 0 -20"
        "SUPER_CTRL, j, resizeactive, 0 20"
      ];

      # Bind for launcher
      bindr = [ "SUPER, SUPER_L, exec, $rofi_launcher" ];

      # Bind for lid switch
      bindl = [
        # When lid closes, disable the laptop screen
        ", switch:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        # When lid opens, re-enable it
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 2256x1504@60, 0x0, 1.25\""
      ];

      # Submap for the VM passthrough
      submap = {
        passthrough = [
          "bind=,escape,submap,reset"
        ];
        reset = [ ];
      };
    };
  };
}
