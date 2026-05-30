{
  lib,
  ...
}:
{
  flake.homeModules.git =
    { config, ... }:
    let
      cfg = config.Git;
    in
    {
      options.Git = {
        enable = lib.mkEnableOption "Enable git module";
        name = lib.mkOption {
          type = lib.types.str;
          description = "Git config name";
        };
        email = lib.mkOption {
          type = lib.types.str;
          description = "Git config email";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.git = {
          enable = true;
          lfs.enable = true;
          settings = {
            user = {
              name = cfg.name;
              email = cfg.email;
              signingkey = "~/.ssh/id_rsa.pub";
            };
            gpg.format = "ssh";
            gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
            commit.gpgsign = true;
            tag.gpgSign = true;
            column.ui = "auto";
            branch.sort = "committerdate";
          };
        };

        programs.difftastic = {
          enable = true;
          git = {
            enable = true;
            diffToolMode = true;
          };
        };
      };
    };
}
