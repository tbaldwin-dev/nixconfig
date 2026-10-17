{ ... }:
{
  flake.nixosModules.gaming =
    { ... }:
    {
      # Enable steam
      programs.steam.enable = true;
    };

  flake.homeModules.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
      ];
    };
}
