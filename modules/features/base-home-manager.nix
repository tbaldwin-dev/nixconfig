{ ... }:
{
  flake.homeModules.base =
    { ... }:
    {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Allow polkit to work
      services.polkit-gnome.enable = true;

      # Handle font management
      fonts.fontconfig.enable = true;
    };
}
