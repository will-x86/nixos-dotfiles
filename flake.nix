{
  description = "Will's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    with inputs; let
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
      commonSpecialArgs = {inherit inputs secrets system;};
    in {
      overlays.default = final: prev: {
        willPkgs = import ./pkgs {pkgs = final;};
      };

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
        framework = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/all.nix
            ./hosts/framework/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = commonSpecialArgs;
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
          ];
        };
        nixos-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/all.nix
            ./hosts/nixos-vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = commonSpecialArgs;
              home-manager.users.will = import ./home/base/base.nix;
            }
          ];
        };
        wsl-nix = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/all.nix
            ./hosts/wsl-nix/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = commonSpecialArgs;
              home-manager.users.will = import ./home/base/base.nix;
            }
          ];
        };
        bigDaddy = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/all.nix
            ./hosts/bigDaddy/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = commonSpecialArgs;
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
          ];
        };
      };
    };
}
