{ ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };
      indent.enable = true;
      ensure_installed = [
        "lua"
        "nix"
        "bash"
        "c"
        "cpp"
        "css"
        "go"
        "html"
        "javascript"
        "json"
        "python"
        "rust"
        "typescript"
        "yaml"
        "zig"
        "cmake"
        "markdown"
      ];
    };
  };
}

