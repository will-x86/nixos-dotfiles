{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # ide
    android-studio

    # other
    bruno
    # databases
    dbeaver-bin
  ];
}
