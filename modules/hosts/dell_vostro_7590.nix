{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations.dell = withSystem "x86_64-linux" (
    { system, pkgs, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        self.nixosModules.dell
        inputs.nixos-hardware.nixosModules.dell-vostro-7590
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.tbaldwin = self.homeModules.tbaldwin;
        }
      ];
    }
  );

  flake.nixosModules.dell =
    { ... }:
    {
      imports = [
        self.nixosModules.dell_hardware
        self.nixosModules.niri
        self.nixosModules.tbaldwin
      ];

      system.stateVersion = "25.11"; # Did you read the comment?

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Enable networking
      networking.networkmanager.enable = true;
      networking.hostName = "nixos"; # Define your hostname.
      networking.firewall.enable = false;

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

      # # Configure keymap in X11
      # services.xserver.xkb = {
      #   layout = "us";
      #   variant = "";
      # };

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Enable display manager
      # Disable for now because of https://github.com/NixOS/nixpkgs/issues/523332
      # services.displayManager.gdm = {
      #   enable = true;
      # };

      # Enable rtkit for pipewire
      security.rtkit.enable = true;

      # Enable upower for niri
      services.upower.enable = true;
    };
}
