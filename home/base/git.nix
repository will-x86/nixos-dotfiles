{
  secrets,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "${secrets.git.username}";
      user.email = "${secrets.git.email}";
      color = {
        ui = "auto";
        diff = {
          meta = "blue";
        };
      };
      core = {
        autocrlf = false;
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
  home.packages = with pkgs; [
    git-crypt
    git-lfs
  ];

}
