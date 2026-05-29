{
  ...
}:
{
  flake.homeModules.brave =
    {
      ...
    }:
    {
      programs.brave = {
        enable = true;
        extensions = [
          # Bitwarden plugin
          { id = "nngceckbapebfimnlniiiahkandclblb"; }
        ];
      };
    };
}
