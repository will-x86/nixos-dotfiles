{
  description = "Will's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    with inputs; let
      #  secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
      secretsPath = ./secrets/secrets.json;
      secrets =
        if builtins.pathExists secretsPath
        then builtins.fromJSON (builtins.readFile secretsPath)
        else {};
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      templates = {
        go = {
          path = ./templates/go;
          description = "Go dev env";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust dev env";
        };
        expo = {
          path = ./templates/expo;
          description = "Expo dev env";
        };
        react = {
          path = ./templates/react;
          description = "React dev env";
        };
      };

      nixosConfigurations = {
        prodesk = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/all.nix
            ./hosts/prodesk/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit secrets inputs system;};

              home-manager.users.will = import ./home/base/base.nix;
            }
            {
              _module.args.secrets = secrets;
            }
          ];
        };
        framework = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/all.nix
            ./hosts/framework/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit secrets inputs system;};
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
            {
              _module.args.secrets = secrets;
            }
          ];
        };
        nixos-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/all.nix
            ./hosts/nixos-vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit secrets inputs system;};
              home-manager.users.will = import ./home/base/base.nix;
            }
            {
              _module.args.secrets = secrets;
            }
          ];
        };

        bigDaddy = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/all.nix
            ./hosts/bigDaddy/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit secrets inputs system;};
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
            {
              _module.args.secrets = secrets;
            }
          ];
        };
      };
    };
}
