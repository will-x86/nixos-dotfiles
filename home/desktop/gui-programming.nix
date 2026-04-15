{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # ide
    android-studio
    jetbrains.idea
    vscode
    stm32cubemx
    arduino-ide
    zed-editor

    # other
    bruno
    # databases
    dbeaver-bin
  ];
}
