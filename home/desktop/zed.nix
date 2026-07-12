{
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;

    # ssh remoting binary
    installRemoteServer = true;

    extensions = [
      "nix"
      "toml"
      "make"
      "lua"
      "cmake"
      "astro"
      "svelte"
      "vue"
      "zig"
      "dart"
      "ruby"
      "html"
      "nord"
    ];

    # LSP servers are downloaded by Zed itself and made to work via nix-ld.
    # Only external formatters (which Zed won't fetch) need to be on PATH.
    extraPackages = with pkgs; [
      nixfmt
      stylua
      prettierd
      eslint_d
      black
      isort
      rustfmt
      go # gofmt
      nodejs
    ];

    userSettings = {
      vim_mode = true;
      relative_line_numbers = true;
      tab_size = 4;
      hard_tabs = false;
      soft_wrap = "none";
      use_autoclose = false;
      scrollbar.show = "auto";
      vertical_scroll_margin = 10;
      wrap_guides = [ 80 ];
      show_wrap_guides = true;

      format_on_save = "on";

      theme = {
        mode = "dark";
        dark = "Nord";
        light = "Nord Light";
      };

      ui_font_size = 15;
      buffer_font_size = 15;

      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      load_direnv = "shell_hook";

      #node = {
      #path = lib.getExe pkgs.nodejs;
      #npm_path = lib.getExe' pkgs.nodejs "npm";
      #};

      terminal = {
        shell = "system";
        working_directory = "current_project_directory";
        copy_on_select = false;
      };

      lsp = {
        nixd.settings.nixd.formatting.command = [ "nixfmt" ];
        rust-analyzer.initialization_options.cargo.allFeatures = true;
        astro-language-server.initialization_options.typescript.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external = {
            command = "nixfmt";
            arguments = [ ];
          };
        };
        Lua = {
          formatter.external = {
            command = "stylua";
            arguments = [ "-" ];
          };
        };
        Python = {
          language_servers = [
            "basedpyright"
            "ruff"
          ];
          formatter = [
            { code_actions."source.organizeImports.ruff" = true; }
            {
              external = {
                command = "black";
                arguments = [
                  "-q"
                  "-"
                ];
              };
            }
          ];
        };
        Go = {
          formatter.external = {
            command = "gofmt";
            arguments = [ ];
          };
        };
        # JS/TS/web + JSON/YAML use Zed's bundled prettier, with eslint autofix.
        JavaScript.code_actions_on_format."source.fixAll.eslint" = true;
        TypeScript.code_actions_on_format."source.fixAll.eslint" = true;
        TSX.code_actions_on_format."source.fixAll.eslint" = true;
        Vue.code_actions_on_format."source.fixAll.eslint" = true;
      };
    };

    # leader = space; ports the custom nixvim binds
    userKeymaps = [
      {
        context = "Editor && VimControl && !menu";
        bindings = {
          # Telescope-style project navigation
          "ctrl-p" = "file_finder::Toggle"; # <C-p> git files
          "space p f" = "file_finder::Toggle"; # <leader>pf find files
          "space p s" = "pane::DeploySearch"; # <leader>ps live grep
          "space p v" = "project_panel::ToggleFocus"; # <leader>pv file explorer
          "space e" = "project_panel::ToggleFocus"; # <leader>e (harpoon menu -> file tree)

          # LSP (mirrors nixvim lsp.keymaps)
          "g d" = "editor::GoToDefinition";
          "g y" = "editor::GoToTypeDefinition";
          "g i" = "editor::GoToImplementation";
          "shift-k" = "editor::Hover";
          "v r r" = "editor::FindAllReferences";
          "v r n" = "editor::Rename";
          "v c a" = "editor::ToggleCodeActions";
          "] d" = "editor::GoToDiagnostic";
          "[ d" = "editor::GoToPreviousDiagnostic";

          # Misc
          "space f" = "editor::Format"; # <leader>f format
          "space y" = "editor::Copy"; # <leader>y system clipboard
          "space q" = "diagnostics::Deploy"; # <leader>q diagnostics list
        };
      }
      {
        # Move selected lines up/down (visual J/K)
        context = "Editor && vim_mode == visual";
        bindings = {
          "shift-j" = "editor::MoveLineDown";
          "shift-k" = "editor::MoveLineUp";
        };
      }
    ];
  };
}
