{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<C-p>" = {
        action = "git_files";
        options = {
          desc = "Telescope Git Files";
        };
      };
      "<leader>ps" = "live_grep";
      "<leader>pf" = {
        action = "find_files";
      };
    };
  };
}
