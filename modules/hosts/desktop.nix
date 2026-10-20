{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations.desktop = withSystem "x86_64-linux" (
    { system, pkgs, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        self.nixosModules.desktop
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tbaldwin = self.homeModules.desktop;
        }
      ];
    }
  );

  flake.homeModules.desktop =
    { pkgs, ... }:
    {
      # Use these features for this configuration
      imports = [
        self.homeModules.base
        self.homeModules.tbaldwin
        self.homeModules.passwords
        self.homeModules.development
        self.homeModules.reverseEngineering
        self.homeModules.gaming
      ];

      nixconfig.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri.wrap {
        settings.outputs = {
          "DP-1".mode = "2560x1440@165.000";
        };
      };

      services.tailscale-systray.enable = true;
    };

  flake.nixosModules.desktop =
    { ... }:
    {
      imports = [
        self.nixosModules.desktop_hardware
        self.nixosModules.niri
        self.nixosModules.tbaldwin
        self.nixosModules.reverseEngineering
        self.nixosModules.gaming
      ];

      system.stateVersion = "26.05";

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

      # Enable nvidia drivers
      services.xserver.videoDrivers = [ "nvidia" ];

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      services.displayManager.defaultSession = "niri";

      services.tailscale.enable = true;

      services.udev.extraRules = ''
        # 8BitDo Ultimate Bluetooth Controller's boot HID interface (seems to be shared by multiple 8BitDo devices)
        # Change it only if lsusb prints different Product ID when device is in bootloader mode.
        SUBSYSTEM=="hidraw", ATTRS{idProduct}=="028e", ATTRS{idVendor}=="045e", TAG+="uaccess"
      '';

      security.polkit.enablePkexecWrapper = true;

      services.rsyslogd = {
        enable = true;
        extraConfig = ''
          module(load="imudp")
          input(type="imudp" port="514")

          module(load="imtcp")
          input(type="imtcp" port="514")
          local2.* -/var/log/adtran.log
        '';
      };

    };
}
