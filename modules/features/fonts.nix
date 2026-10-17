{
self,
  ...
}:
{
  flake.homeModules.font =
    { pkgs, ... }:
    {
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.font
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.font = pkgs.stdenvNoCC.mkDerivation {
        pname = "my-font";
        version = "1.0.0";

        src = pkgs.fetchFromGitHub {
          owner = "mrbvrz";
          repo = "segoe-ui-linux";
          rev = "a89213b7136da6dd5c3638db1f2c6e814c40fa84";
          hash = "sha256-0KXfNu/J1/OUnj0jeQDnYgTdeAIHcV+M+vCPie6AZcU=";
        };

        nativeBuildInputs = [ pkgs.installFonts ];
      };
    };
}
