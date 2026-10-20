{ self, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      # Link xdg-desktop paths managed by home-manager
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      # Enable display manager and add niri to options
      services.displayManager = {
        gdm.enable = true;
        sessionPackages = [
          # Hack to add in the desktop file to XDG_DATA_DIRS
          pkgs.niri
        ];
      };
    };

  flake.homeModules.niri =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.nixconfig.niri.package = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };
      config = {
        home = {
          sessionVariables = {
            # Add platform hints for electorn apps
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          };

          packages = with pkgs; [
            config.nixconfig.niri.package
            # Add a file picker
            pkgs.nautilus
            # Add a clipboard provider
            wl-clipboard
          ];

          # Set the pointer cursor for Xorg apps
          pointerCursor = {
            enable = true;
            package = pkgs.adwaita-icon-theme;
            size = 24;
            name = "Adwaita";
            gtk.enable = true;
            x11.enable = true;
          };
        };

        dbus.packages = [
          pkgs.nautilus
        ];

        services.gnome-keyring.enable = true;

        # Configure XDG portals to use the GTK implementation
        systemd.user.packages = [
          pkgs.xdg-desktop-portal
        ]
        ++ config.xdg.portal.extraPortals;
        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
          config = {
            common.default = [
              "gtk"
            ];
            niri = {
              default = [
                "gnome"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Access" = "gtk";
              "org.freedesktop.impl.portal.Notification" = "gtk";
              "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
            };
          };
        };
      };
    };

  flake.wrappers.niri =
    {
      pkgs,
      wlib,
      lib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.niri ];
      runtimePkgs = [
        pkgs.adwaita-icon-theme
      ];
      settings =
        let
          noctaliaExe = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;
        in
        {
          prefer-no-csd = _: { };

          input = {
            focus-follows-mouse = _: { };

            keyboard = {
              xkb = {
                layout = "us";
                options = "caps:super";
              };
              repeat-rate = 40;
              repeat-delay = 250;
            };

            touchpad = {
              natural-scroll = _: { };
              tap = _: { };
            };

            mouse = {
              accel-profile = "flat";
            };
          };

          binds = {
            "Mod+Return".spawn-sh = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.kitty}";

            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+G".fullscreen-window = _: { };
            "Mod+Shift+F".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            "Mod+1".focus-workspace = "w0";
            "Mod+2".focus-workspace = "w1";
            "Mod+3".focus-workspace = "w2";
            "Mod+4".focus-workspace = "w3";
            "Mod+5".focus-workspace = "w4";
            "Mod+6".focus-workspace = "w5";
            "Mod+7".focus-workspace = "w6";
            "Mod+8".focus-workspace = "w7";
            "Mod+9".focus-workspace = "w8";
            "Mod+0".focus-workspace = "w9";

            "Mod+Shift+1".move-column-to-workspace = "w0";
            "Mod+Shift+2".move-column-to-workspace = "w1";
            "Mod+Shift+3".move-column-to-workspace = "w2";
            "Mod+Shift+4".move-column-to-workspace = "w3";
            "Mod+Shift+5".move-column-to-workspace = "w4";
            "Mod+Shift+6".move-column-to-workspace = "w5";
            "Mod+Shift+7".move-column-to-workspace = "w6";
            "Mod+Shift+8".move-column-to-workspace = "w7";
            "Mod+Shift+9".move-column-to-workspace = "w8";
            "Mod+Shift+0".move-column-to-workspace = "w9";

            "Mod+D".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
            "Mod+V".spawn-sh = "${pkgs.alsa-utils}/bin/amixer sset Capture toggle";

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            "XF86MonBrightnessUp".spawn-sh = "${lib.getExe pkgs.brightnessctl} set +5%";
            "XF86MonBrightnessDown".spawn-sh = "${lib.getExe pkgs.brightnessctl} set 5%-";

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Mod+WheelScrollDown".focus-column-left = _: { };
            "Mod+WheelScrollUp".focus-column-right = _: { };
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

            "Mod+Ctrl+S".spawn-sh = "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy";

            "Mod+Shift+E".spawn-sh = "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";

            "Mod+Shift+S".spawn-sh = lib.getExe (
              pkgs.writeShellApplication {
                name = "screenshot";
                text = ''
                  ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
                  | ${pkgs.wl-clipboard}/bin/wl-copy
                '';
              }
            );
          };

          layout = {
            gaps = 5;

            focus-ring = {
              width = 2;
              active-color = "#${self.lib.themeNoHash.base09}";
            };
          };

          cursor = {
            xcursor-theme = "Adwaita";
            xcursor-size = 24;
          };

          workspaces =
            let
              settings = {
                layout.gaps = 5;
              };
            in
            {
              "w0" = settings;
              "w1" = settings;
              "w2" = settings;
              "w3" = settings;
              "w4" = settings;
              "w5" = settings;
              "w6" = settings;
              "w7" = settings;
              "w8" = settings;
              "w9" = settings;
            };

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          spawn-at-startup = [
            noctaliaExe
            (lib.getExe (
              pkgs.writeShellScriptBin "wallpaper" "${lib.getExe pkgs.swaybg} -i ${../themes/wallpaper.png} -m fill"
            ))
          ];
        };
    };
}
