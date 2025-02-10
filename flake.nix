{
  description = "Will's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    with inputs; let
      secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
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
              home-manager.extraSpecialArgs = {inherit secrets;};
              home-manager.users.will = import ./home/base/base.nix;
            }
            {
              _module.args.secrets = secrets; # Pass secrets explicitly
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
              home-manager.extraSpecialArgs = {inherit secrets;};
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
            {
              _module.args.secrets = secrets; # Pass secrets explicitly
            }
          ];
        };
        frameworkold = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/all.nix
            ./hosts/frameworkold/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit secrets;};
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
            {
              _module.args.secrets = secrets; # Pass secrets explicitly
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
              home-manager.extraSpecialArgs = {inherit secrets;};
              home-manager.users.will = import ./home/desktop/desktop.nix;
            }
            {
              _module.args.secrets = secrets; # Pass secrets explicitly
            }
          ];
        };
      };
    };
}
