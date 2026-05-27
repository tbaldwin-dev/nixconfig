{
  self,
  ...
}:
{
  flake.homeModules.tbaldwin =
    { pkgs, ... }:
    {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "tbaldwin";
      home.homeDirectory = "/home/tbaldwin";

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "25.11"; # Please read the comment before changing.

      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = [
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')

        # Nix tools
        pkgs.nix-tree

        # RE Tools
        pkgs.ghidra
        pkgs.biodiff
        pkgs.wireshark
        pkgs.gdb

        # Repo management
        pkgs.just
        pkgs.scuba
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
      ];

      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
        GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra/";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Use these modules for this configuration
      imports = [
        self.homeModules.niri
        self.homeModules.helix
        self.homeModules.git
      ];

      programs.bash.enable = true;

      programs.starship = {
        enable = true;
        settings = {
          nix_shell.heuristic = true;
        };
      };

      programs.direnv = {
        enable = true;
        silent = true;
      };

      programs.lazydocker.enable = true;

      programs.lazysql.enable = true;

      programs.btop = {
        enable = true;
        package = pkgs.btop-cuda;
        settings = {
          vim_keys = true;
        };
      };
    };
}
