{
  description = "Master Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixos-hardware.url = "github:tbaldwin-dev/nixos-hardware/dell-vostro-7590";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-helix-mode = {
      url = "github:multirious/zsh-helix-mode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (
        {
          self,
          lib,
          withSystem,
          ...
        }:
        let
          users = lib.attrNames self.lib.users;
          systems = lib.systems.flakeExposed;
        in
        {
          # Import home manager into the module system
          # Import all flake-parts modules from the modules directory
          imports = [
            inputs.home-manager.flakeModules.home-manager
            (inputs.import-tree ./modules)
          ];

          # Allow flake.lib to be mergable
          options.flake.lib = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.anything;
            default = { };
          };

          # Use config because of the options above
          config = {
            inherit systems;

            # Dynamically compute all of the homeConfigurations
            # This build a configuration for each system for every user
            flake.homeConfigurations = lib.listToAttrs (
              lib.concatMap (
                system:
                map (user: {
                  name = "${user}@${system}";
                  value = withSystem system (
                    { pkgs, ... }:
                    inputs.home-manager.lib.homeManagerConfiguration {
                      inherit pkgs;
                      modules = [ self.homeModules.${user} ];
                    }
                  );
                }) users
              ) systems
            );

            # Setup nixpkgs that will be used by every module
            perSystem =
              { system, ... }:
              {
                _module.args.pkgs = import inputs.nixpkgs {
                  inherit system;
                  config = {
                    allowUnfree = true;
                  };
                };
              };
          };
        }
      );
}
