{
  pkgs,
  secrets,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "${secrets.git.username}";
    userEmail = "${secrets.git.email}";
    extraConfig = {
      color = {
        ui = "auto";
        diff = {
          meta = "blue";
        };
      };
      core = {
        autocrlf = false;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
