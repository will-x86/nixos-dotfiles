{
  opts = {
    # Disable cursor styling
    guicursor = "";

    # Line numbers
    number = true;
    relativenumber = true;

    # Tab settings
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = true;

    # Indentation
    smartindent = true;

    # Line wrapping
    wrap = false;

    # File handling
    swapfile = false;
    backup = false;
    undofile = true;

    # Search settings
    hlsearch = false;
    incsearch = true;

    # Display settings
    termguicolors = true;
    scrolloff = 10;
    signcolumn = "yes";
    updatetime = 50;
    colorcolumn = "80";
  };

  extraConfigLua = ''
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
    vim.opt.isfname:append("@-@")
  '';
}
