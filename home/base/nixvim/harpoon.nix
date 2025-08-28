{
  plugins = {
    harpoon = {
      enable = true;
      enableTelescope = true; 
    };
  };

  # Harpoon keymaps
  keymaps = [
    # Add current file to harpoon list
    {
      mode = "n";
      key = "<leader>a";
      action.__raw = "function() require('harpoon'):list():add() end";
    }
    # Toggle harpoon quick menu
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "function() local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list()) end";
    }
    # Select harpoon files 1-4
    {
      mode = "n";
      key = "<C-b>";
      action.__raw = "function() require('harpoon'):list():select(1) end";
    }
    {
      mode = "n";
      key = "<C-t>";
      action.__raw = "function() require('harpoon'):list():select(2) end";
    }
    {
      mode = "n";
      key = "<C-n>";
      action.__raw = "function() require('harpoon'):list():select(3) end";
    }
    {
      mode = "n";
      key = "<C-s>";
      action.__raw = "function() require('harpoon'):list():select(4) end";
    }
    # Navigate through harpoon list
    {
      mode = "n";
      key = "<C-S-P>";
      action.__raw = "function() require('harpoon'):list():prev() end";
    }
    {
      mode = "n";
      key = "<C-S-N>";
      action.__raw = "function() require('harpoon'):list():next() end";
    }
  ];

}
