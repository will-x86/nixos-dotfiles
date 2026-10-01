{ ... }:
{
  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "lazy";
    };
  };
}
