{ ... }:
let
  wallpapers = toString ../dotfiles/hypr/wallpapers;
in
{
  shell = {
    font_family = "SF Pro Display";
    time_format = "{:%I:%M %p}";
    date_format = "%A, %d %B";
    polkit_agent = true;
    settings_show_advanced = true;
    clipboard_enabled = true;
    clipboard_history_max_entries = 100;
    greeter_sync.auto_sync = true;
    panel = {
      transparency_mode = "glass";
      borders = true;
      shadow = true;
      launcher_placement = "floating";
      launcher_position = "center";
      clipboard_placement = "floating";
      clipboard_position = "center";
      control_center_placement = "attached";
      wallpaper_placement = "attached";
      session_placement = "floating";
      open_near_click_control_center = true;
      open_near_click_wallpaper = true;
    };
    launcher = {
      categories = true;
      show_icons = true;
      show_app_origin_indicator = true;
      sort_by_usage = true;
      provider_prefix = "/";
      providers = {
        calculator = {
          prefix = "calc";
          global = true;
        };
        emoji.prefix = "emo";
        session.prefix = "session";
        wallpaper.prefix = "wall";
        windows.prefix = "win";
      };
    };
    screenshot = {
      save_to_file = true;
      copy_to_clipboard = true;
    };
  };

  theme = {
    mode = "dark";
    source = "wallpaper";
    wallpaper_scheme = "m3-content";
    templates = {
      enable_builtin_templates = true;
      builtin_ids = [
        "alacritty"
        "btop"
        "gtk3"
        "gtk4"
        "hyprland"
        "kcolorscheme"
        "kitty"
      ];
      enable_community_templates = false;
    };
  };

  wallpaper = {
    enabled = true;
    directory = wallpapers;
    fill_mode = "crop";
    transition = [
      "fade"
      "wipe"
      "zoom"
    ];
    transition_duration = 1200;
    transition_on_startup = false;
    default.path = "${wallpapers}/wallpaper2.png";
    automation.enabled = false;
  };

  notification = {
    enable_daemon = true;
    show_app_name = true;
    show_actions = true;
    position = "top_right";
    layer = "overlay";
    background_opacity = 0.9;
    offset_x = 12;
    offset_y = 12;
  };

  osd = {
    position = "top_center";
    orientation = "horizontal";
    background_opacity = 0.9;
    offset_y = 12;
    kinds = {
      volume = true;
      volume_output = true;
      volume_input = true;
      brightness = true;
      wifi = true;
      bluetooth = true;
      dnd = true;
      privacy = true;
      power_profile = false;
    };
  };

  lockscreen = {
    enabled = true;
    blurred_desktop = false;
    blur_intensity = 0.5;
    tint_intensity = 0.25;
  };

  idle = {
    pre_action_fade_seconds = 2.0;
    behavior = {
      lock = {
        timeout = 300;
        action = "lock";
        enabled = true;
      };
      "screen-off" = {
        timeout = 600;
        action = "screen_off";
        enabled = true;
      };
      suspend = {
        timeout = 1800;
        action = "command";
        command = "noctalia msg session lock-and-suspend";
        enabled = true;
      };
    };
  };

  audio.enable_overdrive = false;
  brightness.enable_ddcutil = false;
  system.monitor.enabled = true;
  dock.enabled = false;
  desktop_widgets.enabled = false;
  weather.enabled = false;
  calendar.enabled = false;

  bar.main = {
    position = "top";
    thickness = 34;
    background_opacity = 0.0;
    capsule_opacity = 0.45;
    radius = 20;
    margin_ends = 10;
    margin_edge = 5;
    padding = 14;
    widget_spacing = 6;
    shadow = false;
    reserve_space = true;
    capsule = true;
    start = [
      "cpu"
      "network_rx"
      "network_tx"
    ];
    center = [
      "clock"
      "clipboard"
      "battery"
      "control-center"
      "tray"
    ];
    end = [ "nix-monitor" ];
  };

  control_center = {
    sidebar = "compact";
    sidebar_section = "compact";
    width = 760;
    show_shortcut_labels = true;
    show_session_button = true;
    hidden_tabs = [
      "weather"
      "calendar"
    ];
    shortcuts = [
      { type = "wifi"; }
      { type = "bluetooth"; }
      { type = "notification"; }
      { type = "wallpaper"; }
      { type = "nightlight"; }
      { type = "session"; }
    ];
  };

  widget = {
    "nix-monitor".type = "avivbintangaringga/nix-monitor:nix-monitor";
    media.hide_when_no_media = true;
    network.show_label = false;
    bluetooth.show_label = false;
    volume.show_label = false;
    brightness.show_label = false;
    notifications.hide_when_no_unread = false;
    clock = {
      format = "{:%I:%M %p}";
      tooltip_format = "{:%A, %d %B %Y}";
      font_weight = 700;
    };
  };

  hooks = {
    started = "noctalia msg plugins enable oldirtty/color_picker";
    colors_changed = "hyprctl reload";
  };

  plugins = {
    enabled = [ "avivbintangaringga/nix-monitor" ];
    auto_update = "all";
    source = [
      {
        name = "community";
        kind = "git";
        location = "https://github.com/noctalia-dev/community-plugins";
        enabled = true;
      }
    ];
  };
}
