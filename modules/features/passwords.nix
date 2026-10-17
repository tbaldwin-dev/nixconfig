{ ... }:
{
  flake.homeModules.passwords =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Password manager
        bitwarden-desktop
      ];

      home.sessionVariables = {
        # Allow password manager to provide SSH keys
        SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
      };
    };
}
