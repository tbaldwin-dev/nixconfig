{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.tbaldwin =
    { config, ... }:
    {
      users.users.tbaldwin = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [
          "wheel"
        ]
        ++ (if config.networking.networkmanager.enable then [ "networkmanager" ] else [ ])
        ++ (if config.programs.wireshark.enable then [ "wireshark" ] else [ ]);
      };

      # Enable steam
      programs.steam.enable = true;

      # Enable wireshark
      programs.wireshark.enable = true;
    };

  flake.homeModules.tbaldwin =
    { pkgs, ... }:
    {
      # Use these features for this configuration
      imports = [
        self.homeModules.niri
        self.homeModules.helix
        self.homeModules.git
        self.homeModules.brave
        self.homeModules.zsh
      ];

      home.username = "tbaldwin";
      home.homeDirectory = "/home/tbaldwin";
      home.stateVersion = "25.11";

      home.packages = [
        # Nix tools
        pkgs.nix-tree

        # RE Tools
        pkgs.ghidra
        pkgs.biodiff
        inputs.pwndbg.packages.${pkgs.stdenv.system}.pwndbg

        # Repo management
        pkgs.just
        pkgs.pre-commit

        # Linting Tools
        pkgs.ruff
        pkgs.pyright
        pkgs.clang-tools
        pkgs.buf

        # Other packages
        pkgs.witr
        pkgs.simplex-chat-desktop
        pkgs.signal-desktop
        pkgs.localsend
      ];

      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
        GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra/";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      programs.bash.enable = true;

      programs.starship.enable = true;

      programs.direnv = {
        enable = true;
        silent = true;
      };

      programs.lazydocker.enable = true;

      programs.lazysql.enable = true;

      programs.java.enable = true;

      programs.btop = {
        enable = true;
        package = pkgs.btop-cuda;
        settings = {
          vim_keys = true;
        };
      };
    };
}
