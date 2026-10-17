{ ... }:
{
  flake.homeModules.development =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Python
        ruff
        pyright
      ];

      # Enable activating development environments when entering directories
      programs.direnv = {
        enable = true;
        silent = true;
      };

      # Enable lazydocker
      programs.lazydocker.enable = true;

      # Enable lazysql
      programs.lazysql.enable = true;
    };
}
