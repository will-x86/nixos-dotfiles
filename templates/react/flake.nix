{
  description = "Node.js development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    playwright.url = "github:pietdevries94/playwright-web-flake/1.51.0";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    playwright,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlay = final: prev: {
          inherit (playwright.packages.${system}) playwright-test playwright-driver;
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [overlay];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            python3
            python3Packages.pip
            python3Packages.setuptools
            python312Packages.gyp
            pkg-config
            python312Packages.distutils
            playwright-test

            sqlite
            eza
            fd
            zsh
          ];

          shellHook = ''
            alias ls=eza
            alias find=fd
            export PATH=$PATH:$PWD/node_modules/.bin
                   export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
              export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"
          '';
        };
      }
    );
}
