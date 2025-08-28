{

  keymaps = [
    {
      key = ";";
      action = ":";
    }
    {
      mode = "n";
      key = "<leader>m";
      options.silent = true;
      action = "<cmd>!make<CR>";
    }
    # File explorer
    {
      mode = "n";
      key = "<leader>pv";
      action = "<cmd>Ex<CR>";
    }
    # Move selected lines up/down
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
    }
    # Join lines but keep cursor position
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
    }
    # Half page jumping with centering
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }
    # Search terms stay in middle
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }
    # Paste without losing register
    {
      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
    }
    # Tmux sessionizer
    {
      mode = "n";
      key = "<C-f>";
      action = "<cmd>silent !tmux neww ~/tmux-sessioniser<CR>";
    }
    # Copy to system clipboard
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = "\"+Y";
    }
    # Delete to void register
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>d";
      action = "\"_d";
    }
    # Better escape
    {
      mode = "i";
      key = "<C-c>";
      action = "<Esc>";
    }
    # Disable Q
    {
      mode = "n";
      key = "Q";
      action = "<nop>";
    }
    # Format buffer
    {
      mode = "n";
      key = "<leader>f";
      action.__raw = "vim.lsp.buf.format";
    }
    # Quickfix navigation
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>cnext<CR>zz";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>cprev<CR>zz";
    }
    # Location list navigation
    {
      mode = "n";
      key = "<leader>k";
      action = "<cmd>lnext<CR>zz";
    }
    {
      mode = "n";
      key = "<leader>j";
      action = "<cmd>lprev<CR>zz";
    }
    # Search and replace word under cursor
    {
      mode = "n";
      key = "<leader>s";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
    }
    # Make file executable
    {
      mode = "n";
      key = "<leader>x";
      options.silent = true;
      action = "<cmd>!chmod +x %<CR>";
    }
    # Source current file
    {
      mode = "n";
      key = "<leader><leader>";
      action.__raw = "function() vim.cmd('so') end";
    }
    # Format JSON with jq
    {
      mode = "n";
      key = "<leader>jq";
      options = {
        noremap = true;
        silent = true;
      };
      action = ":%!jq '.'<CR>";
    }
  ];
}
