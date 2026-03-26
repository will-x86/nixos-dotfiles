{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    impala # wifi
    uwsm # launch tui
    xdg-terminal-exec # launch tui
    tmux
    btop

  ];
}
