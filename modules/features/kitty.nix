{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;
        settings = {
          enable_audio_bell = "no";

          font_size = 12;
          font_family = "JetBrainsMono Nerd Font";

          cursor_text_color = "background";

          allow_remote_control = "yes";
          shell_integration = "enabled";

          cursor_trail = 3;

          background = self.lib.theme.base00;
          foreground = self.lib.theme.base07;

          cursor = self.lib.theme.base07;

          selection_foreground = self.lib.theme.base02;
          selection_background = self.lib.theme.base01;

          active_tab_foreground = self.lib.theme.base0B;
          active_tab_background = self.lib.theme.base03;
          inactive_tab_background = self.lib.theme.base01;

          color0 = self.lib.theme.base00;
          color8 = self.lib.theme.base02;
          color1 = self.lib.theme.base08;
          color9 = self.lib.theme.base08;
          color2 = self.lib.theme.base0B;
          color10 = self.lib.theme.base0B;
          color3 = self.lib.theme.base0A;
          color11 = self.lib.theme.base0A;
          color4 = self.lib.theme.base0D;
          color12 = self.lib.theme.base0D;
          color5 = self.lib.theme.base0E;
          color13 = self.lib.theme.base0E;
          color6 = self.lib.theme.base0C;
          color14 = self.lib.theme.base0C;
          color7 = self.lib.theme.base03;
          color15 = self.lib.theme.base03;
        };
      };
    };
}
