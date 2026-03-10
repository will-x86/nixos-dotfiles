{
  pkgs,
  secrets,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "${secrets.git.username}";
      user.email = "${secrets.git.email}";
      user.editor = "nvim";
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
