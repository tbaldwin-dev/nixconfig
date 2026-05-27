{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.dell = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.dell
      inputs.nixos-hardware.nixosModules.dell-vostro-7590
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tbaldwin = self.homeModules.tbaldwin;
      }
    ];
  };

  flake.nixosModules.dell =
    { ... }:
    {
      imports = [
        self.nixosModules.dell_hardware
        self.nixosModules.niri
      ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Enable networking
      networking.networkmanager.enable = true;
      networking.hostName = "nixos"; # Define your hostname.

      # Set your time zone.
      time.timeZone = "America/New_York";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.tbaldwin = {
        isNormalUser = true;
        description = "Trent Baldwin";
        initialPassword = "password";
        extraGroups = [
          "networkmanager"
          "wheel"
          "wireshark"
        ];
      };

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Enable steam
      programs.steam.enable = true;

      # Enable wireshark
      programs.wireshark.enable = true;

      # Enable localsend
      programs.localsend.enable = true;

      # Enable display manager
      # Disable for now because of https://github.com/NixOS/nixpkgs/issues/523332
      # services.displayManager.gdm = {
      #   enable = true;
      # };

      # Set default portals
      # xdg.portal = {
      #   enable = true;
      #   xdgOpenUsePortal = true;
      #   extraPortals = with pkgs; [
      #     xdg-desktop-portal-gtk
      #   ];
      #   config.common.default = [ "gtk" ];
      # };

      security.rtkit.enable = true;
      networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
