{
  lib,
  ...
}:
{
  flake.homeModules.git =
    { pkgs, config, ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            name = lib.mkDefault "Trent Baldwin";
            email = lib.mkDefault "trent.baldwin@proton.me";
            signingkey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6sPT1O37kHO2NEN8lmIsulOA7njttm5i0jGboJHK+m";
          };
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = toString (
            pkgs.writeText "allowed_signers" ''
              ${config.programs.git.settings.user.email} namespaces="git" ${lib.removePrefix "key::" config.programs.git.settings.user.signingkey}
            ''
          );
          commit.gpgsign = true;
          tag.gpgSign = true;
          rebase.updateRefs = true;
          rerere.enabled = true;
          column.ui = "auto";
          branch.sort = "committerdate";
        };
      };

      home.packages = with pkgs; [
        pre-commit
      ];

      programs.difftastic = {
        enable = true;
        git = {
          enable = true;
          mode = "both";
        };
      };
    };
}
