{
  self,
  ...
}:
{
  flake.nixosModules.tbaldwin =
    { config, pkgs, ... }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.zsh
      ];

      users.users.tbaldwin = {
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
        ]
        ++ (if config.networking.networkmanager.enable then [ "networkmanager" ] else [ ])
        ++ (if config.programs.wireshark.enable then [ "wireshark" ] else [ ])
        ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);
      };
    };

  flake.homeModules.tbaldwin =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.niri
        self.homeModules.helix
        self.homeModules.git
        self.homeModules.brave
        self.homeModules.zsh
      ];

      home.username = "tbaldwin";
      home.homeDirectory = "/home/tbaldwin";
      home.stateVersion = "26.05";

      home.packages = with pkgs; [
        # Nix tools
        nix-tree

        # Messaging Clients
        simplex-chat-desktop
        signal-desktop

        # General Utilities
        witr
        localsend
      ];

      # Enable basic system monitoring
      programs.btop = {
        enable = true;
        package = pkgs.btop-cuda;
        settings = {
          vim_keys = true;
        };
      };
    };
}
