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
  outputs =
    inputs:
    let
      inherit (inputs)
        nixpkgs
        nixpkgs-stable
        home-manager
        nixos-wsl
        ;
      system = "x86_64-linux";

      # Helper function to load secrets
      loadSecrets =
        let
          secretsPath = ./secrets/secrets.json;
        in
        if builtins.pathExists secretsPath then builtins.fromJSON (builtins.readFile secretsPath) else { };

      # Common pkgs configuration
      mkPkgs = pkgs: {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs = import nixpkgs (mkPkgs nixpkgs);
      pkgs-stable = import nixpkgs-stable (mkPkgs nixpkgs-stable);

      # Common special arguments for all configurations
      commonSpecialArgs = {
        inherit inputs system;
        secrets = loadSecrets;
      };

      # Common home-manager configuration
      mkHomeManagerConfig = homeConfig: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = commonSpecialArgs;
        home-manager.users.will = import homeConfig;
      };

      # Helper function to create NixOS configurations
      mkHost =
        {
          hostName,
          extraModules ? [ ],
          homeConfig ? ./home/base/base.nix,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/all.nix
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHomeManagerConfig homeConfig)
          ] ++ extraModules;
        };

      # Load local packages
      localPkgsDefinition = import ./pkgs;
      systemPackages = localPkgsDefinition.perSystem { inherit pkgs system; };
    in
    {
      packages.${system} = systemPackages.packages;

      # Automatically generate templates from the templates directory
      templates =
        let
          # Get all subdirectories in templates folder
          templateDirs =
            let
              templatesPath = ./templates;
              dirContent = builtins.readDir templatesPath;
              subdirs = nixpkgs.lib.filterAttrs (name: type: type == "directory") dirContent;
            in
            builtins.attrNames subdirs;

          # Generate template configurations
          mkTemplate = name: {
            path = ./templates + "/${name}";
            description = "${name} dev env";
          };
        in
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = mkTemplate name;
          }) templateDirs
        );

      nixosConfigurations = {
        # Desktop configurations
        framework = mkHost {
          hostName = "framework";
          homeConfig = ./home/desktop/desktop.nix;
        };

        bigDaddy = mkHost {
          hostName = "bigDaddy";
          homeConfig = ./home/desktop/desktop.nix;
        };

        # VM configuration
        nixos-vm = mkHost {
          hostName = "nixos-vm";
        };

        # WSL configuration
        wsl-nix = mkHost {
          hostName = "wsl-nix";
          extraModules = [ nixos-wsl.nixosModules.default ];
        };
      };
    };
}
