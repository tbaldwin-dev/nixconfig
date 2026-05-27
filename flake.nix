{
  description = "Master Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-helix-mode = {
      url = "github:multirious/zsh-helix-mode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:tbaldwin-dev/nixos-hardware/dell-vostro-7590";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        imports = [
          inputs.home-manager.flakeModules.home-manager
          (inputs.import-tree ./modules)
        ];
        systems = inputs.nixpkgs.lib.systems.flakeExposed;
      };
}
