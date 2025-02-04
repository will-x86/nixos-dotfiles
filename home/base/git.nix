{
  pkgs,
  secrets,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "${secrets.git.username}";
    userEmail = "${secrets.git.email}";
  };
}
