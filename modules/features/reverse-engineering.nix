{ ... }:
{
  flake.nixosModules.reverseEngineering =
    { pkgs, ... }:
    {
      # Enable wireshark
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };
    };

  flake.homeModules.reverseEngineering =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghidra
        biodiff
        pwndbg
      ];

      home.sessionVariables = {
        # Set for Java runtime windows on tiling window managers
        _JAVA_AWT_WM_NONREPARENTING = 1;

        # Set ghidra install dir path
        GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra/";
      };

      # Enable java
      programs.java.enable = true;
    };
}
