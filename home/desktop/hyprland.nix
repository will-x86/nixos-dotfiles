{
  config,
  secrets,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = "# Managed via lua";
  };
}
