{
  config,
  secrets,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = "# Managed via lua";
  };
}
